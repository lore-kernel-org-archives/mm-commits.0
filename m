From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-add-mport-char-device-driver-fix.patch
 removed from -mm tree
Date: Tue, 22 Mar 2016 13:56:22 -0700
Message-ID: <56f1b176.K7+I9aJG6cZ7ht8K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcCVU4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a-jacquiot@ti.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio-add-mport-char-device-driver-fix
has been removed from the -mm tree.  Its filename was
     rapidio-add-mport-char-device-driver-fix.patch

This patch was dropped because it was folded into rapidio-add-mport-char-device-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rapidio-add-mport-char-device-driver-fix

fix printk warning on i386:

drivers/rapidio/devices/rio_mport_cdev.c: In function 'mport_mm_open':
include/linux/dynamic_debug.h:64:16: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2220,7 +2220,7 @@ static void mport_mm_open(struct vm_area
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
-rmcd_debug(MMAP, "0x%llx", map->phys_addr);
+rmcd_debug(MMAP, "0x%pad", &map->phys_addr);
 	kref_get(&map->ref);
 }
 
@@ -2228,7 +2228,7 @@ static void mport_mm_close(struct vm_are
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
-rmcd_debug(MMAP, "0x%llx", map->phys_addr);
+rmcd_debug(MMAP, "0x%pad", &map->phys_addr);
 	mutex_lock(&map->md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
 	mutex_unlock(&map->md->buf_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

rapidio-add-mport-char-device-driver.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch

