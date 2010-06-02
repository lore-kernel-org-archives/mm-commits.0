From: akpm@linux-foundation.org
Subject: + drivers-mfd-kzalloc-doesnt-return-err_ptr.patch added to -mm tree
Date: Wed, 02 Jun 2010 13:08:04 -0700
Message-ID: <201006022008.o52K847i014210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853Ab0FBUI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 16:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, sameo@linux.intel.com


The patch titled
     drivers/mfd: kzalloc doesn't return ERR_PTR
has been added to the -mm tree.  Its filename is
     drivers-mfd-kzalloc-doesnt-return-err_ptr.patch

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
Subject: drivers/mfd: kzalloc doesn't return ERR_PTR
From: Julia Lawall <julia@diku.dk>

Use !x rather than IS_ERR(x) to test the result of kzalloc.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@

x = \(kmalloc\|kzalloc\|kcalloc\)(...)
... when != x = E
- IS_ERR(x)
+ !x
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/abx500-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/abx500-core.c~drivers-mfd-kzalloc-doesnt-return-err_ptr drivers/mfd/abx500-core.c
--- a/drivers/mfd/abx500-core.c~drivers-mfd-kzalloc-doesnt-return-err_ptr
+++ a/drivers/mfd/abx500-core.c
@@ -36,7 +36,7 @@ int abx500_register_ops(struct device *d
 	struct abx500_device_entry *dev_entry;
 
 	dev_entry = kzalloc(sizeof(struct abx500_device_entry), GFP_KERNEL);
-	if (IS_ERR(dev_entry)) {
+	if (!dev_entry) {
 		dev_err(dev, "register_ops kzalloc failed");
 		return -ENOMEM;
 	}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-x86-kernel-add-missing-spin_unlock-fix2.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-ide-use-memdup_user.patch
drivers-mfd-kzalloc-doesnt-return-err_ptr.patch
fs-ubifs-use-err_cast.patch
drivers-net-wireless-prism54-use-memdup_user.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch
drivers-staging-eliminate-a-null-pointer-dereference.patch
drivers-usb-gadget-use-memdup_user.patch
drivers-usb-serial-eliminate-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch

