From: akpm@linux-foundation.org
Subject: + do_coredump-fix-the-ispipe-error-check.patch added to -mm tree
Date: Wed, 29 Jun 2011 13:24:31 -0700
Message-ID: <201106292024.p5TKOVij009740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab1F2UYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 16:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, jslaby@suse.cz, nhorman@tuxdriver.com


The patch titled
     do_coredump: fix the "ispipe" error check
has been added to the -mm tree.  Its filename is
     do_coredump-fix-the-ispipe-error-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_coredump: fix the "ispipe" error check
From: Oleg Nesterov <oleg@redhat.com>

do_coredump() assumes that if format_corename() fails it should return
-ENOMEM.  This is not true, for example cn_print_exe_file() can propagate
the error from d_path.  Even if it was true, this is too fragile.  Change
the code to check "ispipe < 0".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~do_coredump-fix-the-ispipe-error-check fs/exec.c
--- a/fs/exec.c~do_coredump-fix-the-ispipe-error-check
+++ a/fs/exec.c
@@ -2118,16 +2118,16 @@ void do_coredump(long signr, int exit_co
 
 	ispipe = format_corename(&cn, signr);
 
-	if (ispipe == -ENOMEM) {
-		printk(KERN_WARNING "format_corename failed\n");
-		printk(KERN_WARNING "Aborting core\n");
-		goto fail_corename;
-	}
