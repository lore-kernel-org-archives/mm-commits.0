From: akpm@linux-foundation.org
Subject: - kvm-add-a-global-list-of-all-virtual-machines-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:25:26 -0800
Message-ID: <200702120725.l1C7PQTH024777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbXBLHZp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:25:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm-add-a-global-list-of-all-virtual-machines tidy
has been removed from the -mm tree.  Its filename was
     kvm-add-a-global-list-of-all-virtual-machines-tidy.patch

This patch was dropped because it was folded into kvm-add-a-global-list-of-all-virtual-machines.patch

------------------------------------------------------
Subject: kvm-add-a-global-list-of-all-virtual-machines tidy
From: Andrew Morton <akpm@osdl.org>

Use standard (ugly) initialisers.

Cc: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-add-a-global-list-of-all-virtual-machines-tidy drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-a-global-list-of-all-virtual-machines-tidy
+++ a/drivers/kvm/kvm_main.c
@@ -41,8 +41,8 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-static spinlock_t kvm_lock = SPIN_LOCK_UNLOCKED;
-static struct list_head vm_list = LIST_HEAD_INIT(vm_list);
+static DEFINE_SPINLOCK(kvm_lock);
+static LIST_HEAD(vm_list);
 
 struct kvm_arch_ops *kvm_arch_ops;
 struct kvm_stat kvm_stat;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-generalize-metadata-read-write.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
