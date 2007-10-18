From: akpm@linux-foundation.org
Subject: - ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:19 -0700
Message-ID: <200710180655.l9I6tJcS030597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759999AbXJRHR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: Fix mount check in ufs_fill_super()
has been removed from the -mm tree.  Its filename was
     ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: Fix mount check in ufs_fill_super()
From: Satyam Sharma <satyam@infradead.org>

The current code skips the check to verify whether the filesystem was
previously cleanly unmounted, if (flags & UFS_ST_MASK) == UFS_ST_44BSD or
UFS_ST_OLD.  This looks like an inadvertent bug that slipped in due to
parantheses in the compound conditional to me, especially given that
ufs_get_fs_state() handles the UFS_ST_44BSD case perfectly well.  So, let's
fix the compound condition appropriately.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/ufs/super.c~ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super
+++ a/fs/ufs/super.c
@@ -933,19 +933,20 @@ magic_found:
 		goto again;
 	}
 
-	sbi->s_flags = flags;/*after that line some functions use s_flags*/
+	/* Set sbi->s_flags here, used by ufs_get_fs_state() below */
+	sbi->s_flags = flags;
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
 	/*
 	 * Check, if file system was correctly unmounted.
 	 * If not, make it read only.
 	 */
-	if (((flags & UFS_ST_MASK) == UFS_ST_44BSD) ||
-	  ((flags & UFS_ST_MASK) == UFS_ST_OLD) ||
-	  (((flags & UFS_ST_MASK) == UFS_ST_SUN || 
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
-	  (flags & UFS_ST_MASK) == UFS_ST_SUNx86) && 
-	  (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time))))) {
+	if ((((flags & UFS_ST_MASK) == UFS_ST_44BSD)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_OLD)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUN)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUNOS)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUNx86))	&&
+	    (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time)))) {
 		switch(usb1->fs_clean) {
 		case UFS_FSCLEAN:
 			UFSD("fs is clean\n");
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-watchdog.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
