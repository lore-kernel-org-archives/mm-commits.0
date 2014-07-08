From: akpm@linux-foundation.org
Subject: + proc-remove-proc_tty_ldisc-variable.patch added to -mm tree
Date: Tue, 08 Jul 2014 15:55:09 -0700
Message-ID: <53bc76cd.x+2ehU/ccSmegofe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56807 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaGHWzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 18:55:10 -0400
Received: by mail-ve0-f201.google.com with SMTP id i13so259645veh.2
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 15:55:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove proc_tty_ldisc variable
has been added to the -mm tree.  Its filename is
     proc-remove-proc_tty_ldisc-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-remove-proc_tty_ldisc-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-proc_tty_ldisc-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: remove proc_tty_ldisc variable

/proc/tty/ldisc appear to be unused as a directory and
it had been always that way.

But it is userspace visible thing.

Cowardly remove only in-kernel variable holding it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_tty.c~proc-remove-proc_tty_ldisc-variable fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-remove-proc_tty_ldisc-variable
+++ a/fs/proc/proc_tty.c
@@ -18,7 +18,7 @@
 /*
  * The /proc/tty directory inodes...
  */
-static struct proc_dir_entry *proc_tty_ldisc, *proc_tty_driver;
+static struct proc_dir_entry *proc_tty_driver;
 
 /*
  * This is the handler for /proc/tty/drivers
@@ -176,7 +176,7 @@ void __init proc_tty_init(void)
 {
 	if (!proc_mkdir("tty", NULL))
 		return;
-	proc_tty_ldisc = proc_mkdir("tty/ldisc", NULL);
+	proc_mkdir("tty/ldisc", NULL);
 	/*
 	 * /proc/tty/driver/serial reveals the exact character counts for
 	 * serial links which is just too easy to abuse for inferring
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
proc-add-and-remove-proc-entry-create-checks.patch
proc-faster-proc-pid-lookup.patch
proc-make-proc_subdir_lock-static.patch
proc-remove-proc_tty_ldisc-variable.patch
proc-remove-proc_tty_ldisc-variable-fix.patch

