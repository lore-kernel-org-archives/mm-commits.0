From: akpm@linux-foundation.org
Subject: + drivers-staging-eliminate-a-null-pointer-dereference.patch added to -mm tree
Date: Tue, 01 Jun 2010 22:57:49 -0700
Message-ID: <201006020557.o525vkXV007939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647Ab0FBF5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 01:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, greg@kroah.com


The patch titled
     drivers/staging: eliminate a NULL pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-staging-eliminate-a-null-pointer-dereference.patch

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
Subject: drivers/staging: eliminate a NULL pointer dereference
From: Julia Lawall <julia@diku.dk>

Eliminate a NULL or near NULL pointer dereference.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/usbdux.c |    3 +--
 drivers/staging/dt3155/allocator.c      |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/staging/comedi/drivers/usbdux.c~drivers-staging-eliminate-a-null-pointer-dereference drivers/staging/comedi/drivers/usbdux.c
--- a/drivers/staging/comedi/drivers/usbdux.c~drivers-staging-eliminate-a-null-pointer-dereference
+++ a/drivers/staging/comedi/drivers/usbdux.c
@@ -351,8 +351,7 @@ static int usbdux_ai_stop(struct usbduxs
 	int ret = 0;
 
 	if (!this_usbduxsub) {
-		dev_err(&this_usbduxsub->interface->dev,
-			"comedi?: usbdux_ai_stop: this_usbduxsub=NULL!\n");
+		pr_err("comedi?: usbdux_ai_stop: this_usbduxsub=NULL!\n");
 		return -EFAULT;
 	}
 	dev_dbg(&this_usbduxsub->interface->dev, "comedi: usbdux_ai_stop\n");
diff -puN drivers/staging/dt3155/allocator.c~drivers-staging-eliminate-a-null-pointer-dereference drivers/staging/dt3155/allocator.c
--- a/drivers/staging/dt3155/allocator.c~drivers-staging-eliminate-a-null-pointer-dereference
+++ a/drivers/staging/dt3155/allocator.c
@@ -176,9 +176,7 @@ int allocator_free_dma(unsigned long add
 	prev = ptr; ptr = ptr->next;
 
 	if (!ptr) {
-		printk(KERN_ERR ALL_MSG
-			"free_dma(0x%08lx) but add. not allocated\n",
-			ptr->address);
+		pr_err(ALL_MSG "free_dma but add. not allocated\n");
 		return -EINVAL;
 	}
 	PDEBUGG("freeing: %08lx (%li) next %08lx\n", ptr->address, ptr->size,
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-x86-kernel-add-missing-spin_unlock-fix2.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-i2c-use-memdup_user.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-ide-use-memdup_user.patch
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
drivers-staging-dream-camera-use-memdup_user.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
drivers-usb-serial-eliminate-a-null-pointer-dereference.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-eliminate-a-null-pointer-dereference.patch
drivers-staging-eliminate-a-null-pointer-dereference.patch

