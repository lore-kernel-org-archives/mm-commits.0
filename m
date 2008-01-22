From: akpm@linux-foundation.org
Subject: + random-use-unlocked_ioctl.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:15 -0800
Message-ID: <200801220932.m0M9Wtgv014420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671AbYAVJde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: use unlocked_ioctl
has been added to the -mm tree.  Its filename is
     random-use-unlocked_ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: use unlocked_ioctl
From: Matt Mackall <mpm@selenic.com>

No locking actually needed.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/random.c~random-use-unlocked_ioctl drivers/char/random.c
--- a/drivers/char/random.c~random-use-unlocked_ioctl
+++ a/drivers/char/random.c
@@ -1063,8 +1063,7 @@ static ssize_t random_write(struct file 
 	return (ssize_t)count;
 }
 
-static int random_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1072,8 +1071,8 @@ static int random_ioctl(struct inode *in
 
 	switch (cmd) {
 	case RNDGETENTCNT:
-		ent_count = input_pool.entropy_count;
-		if (put_user(ent_count, p))
+		/* inherently racy, no point locking */
+		if (put_user(input_pool.entropy_count, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1116,13 +1115,13 @@ const struct file_operations random_fops
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
-	.ioctl = random_ioctl,
+	.unlocked_ioctl = random_ioctl,
 };
 
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
-	.ioctl = random_ioctl,
+	.unlocked_ioctl = random_ioctl,
 };
 
 /***************************************************************
_

Patches currently in -mm which might be from mpm@selenic.com are

git-x86.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-pid-pagemap-interface-fix.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
