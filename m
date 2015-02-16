From: akpm@linux-foundation.org
Subject: [merged] module_device_table-fix-some-callsites.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:17:42 -0800
Message-ID: <54e25066.t0YLqr549HXOqauJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbbBPUST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, a.ryabinin@samsung.com, davem@davemloft.net, hverkuil@xs4all.nl, mchehab@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MODULE_DEVICE_TABLE: fix some callsites
has been removed from the -mm tree.  Its filename was
     module_device_table-fix-some-callsites.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MODULE_DEVICE_TABLE: fix some callsites

The patch "module: fix types of device tables aliases" newly requires that
invocations of

MODULE_DEVICE_TABLE(type, name);

come *after* the definition of `name'.  That is reasonable, but some
drivers weren't doing this.  Fix them.

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: David Miller <davem@davemloft.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/video4linux/v4l2-pci-skeleton.c |    2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |    1 -
 drivers/scsi/be2iscsi/be_main.c               |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff -puN Documentation/video4linux/v4l2-pci-skeleton.c~module_device_table-fix-some-callsites Documentation/video4linux/v4l2-pci-skeleton.c
--- a/Documentation/video4linux/v4l2-pci-skeleton.c~module_device_table-fix-some-callsites
+++ a/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -42,7 +42,6 @@
 MODULE_DESCRIPTION("V4L2 PCI Skeleton Driver");
 MODULE_AUTHOR("Hans Verkuil");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(pci, skeleton_pci_tbl);
 
 /**
  * struct skeleton - All internal data for one instance of device
@@ -95,6 +94,7 @@ static const struct pci_device_id skelet
 	/* { PCI_DEVICE(PCI_VENDOR_ID_, PCI_DEVICE_ID_) }, */
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, skeleton_pci_tbl);
 
 /*
  * HDTV: this structure has the capabilities of the HDTV receiver.
diff -puN drivers/net/ethernet/emulex/benet/be_main.c~module_device_table-fix-some-callsites drivers/net/ethernet/emulex/benet/be_main.c
--- a/drivers/net/ethernet/emulex/benet/be_main.c~module_device_table-fix-some-callsites
+++ a/drivers/net/ethernet/emulex/benet/be_main.c
@@ -26,7 +26,6 @@
 #include <net/vxlan.h>
 
 MODULE_VERSION(DRV_VER);
-MODULE_DEVICE_TABLE(pci, be_dev_ids);
 MODULE_DESCRIPTION(DRV_DESC " " DRV_VER);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
diff -puN drivers/scsi/be2iscsi/be_main.c~module_device_table-fix-some-callsites drivers/scsi/be2iscsi/be_main.c
--- a/drivers/scsi/be2iscsi/be_main.c~module_device_table-fix-some-callsites
+++ a/drivers/scsi/be2iscsi/be_main.c
@@ -48,7 +48,6 @@ static unsigned int be_iopoll_budget = 1
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
 
-MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
 MODULE_VERSION(BUILD_STR);
 MODULE_AUTHOR("Emulex Corporation");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
samples-seccomp-improve-label-helper-fix.patch
linux-next.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

