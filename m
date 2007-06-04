From: akpm@linux-foundation.org
Subject: + the-async_-options-shouldnt-be-user-visible.patch added to -mm tree
Date: Mon, 04 Jun 2007 14:36:42 -0700
Message-ID: <200706042136.l54LagKL019757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbXFDVg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 17:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dan.j.williams@intel.com


The patch titled
     the ASYNC_* options shouldn't be user visible
has been added to the -mm tree.  Its filename is
     the-async_-options-shouldnt-be-user-visible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: the ASYNC_* options shouldn't be user visible
From: Adrian Bunk <bunk@stusta.de>

The ASYNC_* options are for internal helper code and should therefore
not be user visible.

BTW: Please move the async_tx directory under drivers/ or lib/

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 async_tx/Kconfig |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff -puN async_tx/Kconfig~the-async_-options-shouldnt-be-user-visible async_tx/Kconfig
--- a/async_tx/Kconfig~the-async_-options-shouldnt-be-user-visible
+++ a/async_tx/Kconfig
@@ -1,27 +1,15 @@
-menuconfig ASYNC_CORE
-	tristate "Asynchronous Bulk Memory Transfers/Transforms"
-	default n
-	---help---
-	  This enables the async_tx interface layer for dma (offload) engines.
-	  Subsystems coded to this api will use offload engines for bulk memory
-	  operations (e.g. memcpy, memset, xor...).  When an offload engine is not
-	  available the interface will implicitly fall back to a software
-	  implementation of the operation.
-
-	  If unsure, say N
-
-if ASYNC_CORE
+config ASYNC_CORE
+	tristate
 
 config ASYNC_MEMCPY
-	default m
-	tristate "async_memcpy support"
+	tristate
+	select ASYNC_CORE
 
 config ASYNC_XOR
-	default m
-	tristate "async_xor support"
+	tristate
+	select ASYNC_CORE
 
 config ASYNC_MEMSET
-	default m
-	tristate "async_memset support"
+	tristate
+	select ASYNC_CORE
 
-endif
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
the-async_-options-shouldnt-be-user-visible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
