From: akpm@linux-foundation.org
Subject: + tty_register_driver-only-allocate-tty-instances-when-defined.patch added to -mm tree
Date: Fri, 04 May 2007 13:15:15 -0700
Message-ID: <200705042015.l44KFFrN013156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031393AbXEDUPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 16:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     tty_register_driver: only allocate tty instances when defined
has been added to the -mm tree.  Its filename is
     tty_register_driver-only-allocate-tty-instances-when-defined.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty_register_driver: only allocate tty instances when defined
From: Andy Whitcroft <apw@shadowen.org>

If device->num is zero we attempt to kmalloc() zero bytes.  When SLUB is
enabled this returns a null pointer and take that as an allocation failure
and fail the device register.  Check for no devices and avoid the
allocation.

[akpm: opportunistic kzalloc() conversion]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/tty_io.c~tty_register_driver-only-allocate-tty-instances-when-defined drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_register_driver-only-allocate-tty-instances-when-defined
+++ a/drivers/char/tty_io.c
@@ -3720,11 +3720,10 @@ int tty_register_driver(struct tty_drive
 	if (driver->flags & TTY_DRIVER_INSTALLED)
 		return 0;
 
-	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
-		p = kmalloc(driver->num * 3 * sizeof(void *), GFP_KERNEL);
+	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
+		p = kzalloc(driver->num * 3 * sizeof(void *), GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
-		memset(p, 0, driver->num * 3 * sizeof(void *));
 	}
 
 	if (!driver->major) {
_

Patches currently in -mm which might be from apw@shadowen.org are

add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
slab-numa-kmem_cache-diet.patch
tty_register_driver-only-allocate-tty-instances-when-defined.patch
pci-device-ensure-sysdata-initialised-v2.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
i386-mmzone-use-__attribute_unused__.patch
