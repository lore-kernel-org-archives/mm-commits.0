From: akpm@linux-foundation.org
Subject: - brk-check-lower-bound-properly.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:25 -0700
Message-ID: <200806081947.m58JlP57017417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982AbYFHTsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, geert@linux-m68k.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     brk: make sys_brk() honor COMPAT_BRK when computing lower bound
has been removed from the -mm tree.  Its filename was
     brk-check-lower-bound-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: brk: make sys_brk() honor COMPAT_BRK when computing lower bound
From: Jiri Kosina <jkosina@suse.cz>

Fix a regression introduced by

commit 4cc6028d4040f95cdb590a87db478b42b8be0508
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Feb 6 22:39:44 2008 +0100

    brk: check the lower bound properly

The check in sys_brk() on minimum value the brk might have must take
CONFIG_COMPAT_BRK setting into account.  When this option is turned on
(i.e.  we support ancient legacy binaries, e.g.  libc5-linked stuff), the
lower bound on brk value is mm->end_code, otherwise the brk start is
allowed to be arbitrarily shifted.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~brk-check-lower-bound-properly mm/mmap.c
--- a/mm/mmap.c~brk-check-lower-bound-properly
+++ a/mm/mmap.c
@@ -245,10 +245,16 @@ asmlinkage unsigned long sys_brk(unsigne
 	unsigned long rlim, retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
+	unsigned long min_brk;
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->start_brk)
+#ifdef CONFIG_COMPAT_BRK
+	min_brk = mm->end_code;
+#else
+	min_brk = mm->start_brk;
+#endif
+	if (brk < min_brk)
 		goto out;
 
 	/*
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
elantech-touchpad-driver.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch

