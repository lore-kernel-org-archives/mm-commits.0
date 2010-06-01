From: akpm@linux-foundation.org
Subject: + arch-ia64-kvm-add-missing-spin_unlock.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:18:59 -0700
Message-ID: <201006012118.o51LIx3C019284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605Ab0FAVTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, avi@redhat.com, mtosatti@redhat.com, xiantao.zhang@intel.com


The patch titled
     arch/ia64/kvm: add missing spin_unlock
has been added to the -mm tree.  Its filename is
     arch-ia64-kvm-add-missing-spin_unlock.patch

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
Subject: arch/ia64/kvm: add missing spin_unlock
From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.

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
Cc: Xiantao Zhang <xiantao.zhang@intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kvm/kvm-ia64.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/kvm/kvm-ia64.c~arch-ia64-kvm-add-missing-spin_unlock arch/ia64/kvm/kvm-ia64.c
--- a/arch/ia64/kvm/kvm-ia64.c~arch-ia64-kvm-add-missing-spin_unlock
+++ a/arch/ia64/kvm/kvm-ia64.c
@@ -144,6 +144,7 @@ int kvm_arch_hardware_enable(void *garba
 				VP_INIT_ENV : VP_INIT_ENV_INITALIZE,
 			__pa(kvm_vm_buffer), KVM_VM_BUFFER_BASE, &tmp_base);
 	if (status != 0) {
+		spin_unlock(&vp_lock);
 		printk(KERN_WARNING"kvm: Failed to Enable VT Support!!!!\n");
 		return -EINVAL;
 	}
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
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch

