From: akpm@linux-foundation.org
Subject: [merged] do_coredump-fix-the-ispipe-error-check.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:31 -0700
Message-ID: <201107271927.p6RJRI22003202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, jslaby@suse.cz, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     do_coredump: fix the "ispipe" error check
has been removed from the -mm tree.  Its filename was
     do_coredump-fix-the-ispipe-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2133,16 +2133,16 @@ void do_coredump(long signr, int exit_co
 
 	ispipe = format_corename(&cn, signr);
 
-	if (ispipe == -ENOMEM) {
-		printk(KERN_WARNING "format_corename failed\n");
-		printk(KERN_WARNING "Aborting core\n");
-		goto fail_corename;
-	}
