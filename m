From: akpm@linux-foundation.org
Subject: - uml-remove-fakehd.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:15 -0800
Message-ID: <200802052237.m15Mbuwa012908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760896AbYBEWlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove fakehd
has been removed from the -mm tree.  Its filename was
     uml-remove-fakehd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove fakehd
From: Jeff Dike <jdike@addtoit.com>

The fakehd switch lost its implementation at some point.  Since no one is
screaming for it, we might as well remove it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-remove-fakehd arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-remove-fakehd
+++ a/arch/um/drivers/ubd_kern.c
@@ -460,20 +460,6 @@ __uml_help(udb_setup,
 "    in the boot output.\n\n"
 );
 
-static int fakehd_set = 0;
-static int fakehd(char *str)
-{
-	printk(KERN_INFO "fakehd : Changing ubd name to \"hd\".\n");
-	fakehd_set = 1;
-	return 1;
-}
-
-__setup("fakehd", fakehd);
-__uml_help(fakehd,
-"fakehd\n"
-"    Change the ubd device name to \"hd\".\n\n"
-);
-
 static void do_ubd_request(struct request_queue * q);
 
 /* Only changed by ubd_init, which is an initcall. */
@@ -722,8 +708,10 @@ static int ubd_add(int n, char **error_o
 		ubd_disk_register(fake_major, ubd_dev->size, n,
 				  &fake_gendisk[n]);
 
-	/* perhaps this should also be under the "if (fake_major)" above */
-	/* using the fake_disk->disk_name and also the fakehd_set name */
+	/*
+	 * Perhaps this should also be under the "if (fake_major)" above
+	 * using the fake_disk->disk_name
+	 */
 	if (fake_ide)
 		make_ide_entries(ubd_gendisk[n]->disk_name);
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
