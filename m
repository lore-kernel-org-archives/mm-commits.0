From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-add-missing-spin_unlock.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:14:46 -0700
Message-ID: <201006012114.o51LEkoX019013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756258Ab0FAVPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, hpa@zytor.com, joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     arch/x86/kernel: add missing spin_unlock
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-add-missing-spin_unlock.patch

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
Subject: arch/x86/kernel: add missing spin_unlock
From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  The locks and unlocks are
balanced in other functions, so it seems that the same should be the case
here.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_iommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock
+++ a/arch/x86/kernel/amd_iommu.c
@@ -1499,12 +1499,16 @@ static int __attach_device(struct device
 
 	/* Some sanity checks */
 	if (alias_data->domain != NULL &&
-	    alias_data->domain != domain)
+	    alias_data->domain != domain) {
+		spin_unlock(&domain->lock);
 		return -EBUSY;
+	}
 
 	if (dev_data->domain != NULL &&
-	    dev_data->domain != domain)
+	    dev_data->domain != domain) {
+		spin_unlock(&domain->lock);
 		return -EBUSY;
+	}
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-media-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
fs-ubifs-use-err_cast.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-x86-kernel-add-missing-spin_unlock-fix.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch

