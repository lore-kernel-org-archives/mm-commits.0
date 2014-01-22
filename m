From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:46 -0800
Message-ID: <52e0267a.72ZGpomq0OPOImMr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbaAVUNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: [merged] mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch removed from -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:46 -0800


The patch titled
     Subject: mm/memblock: debug: don't free reserved array if !ARCH_DISCARD_MEMBLOCK
has been removed from the -mm tree.  Its filename was
     mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: debug: don't free reserved array if !ARCH_DISCARD_MEMBLOCK

Now the Nobootmem allocator will always try to free memory allocated for
reserved memory regions (free_low_memory_core_early()) without taking into
to account current memblock debugging configuration
(CONFIG_ARCH_DISCARD_MEMBLOCK and CONFIG_DEBUG_FS state).  As result if:

 - CONFIG_DEBUG_FS defined
 - CONFIG_ARCH_DISCARD_MEMBLOCK not defined;
-  reserved memory regions array have been resized during boot

then:

- memory allocated for reserved memory regions array will be freed to
  buddy allocator;
- debug_fs entry "sys/kernel/debug/memblock/reserved" will show garbage
  instead of state of memory reservations. like:
   0: 0x98393bc0..0x9a393bbf
   1: 0xff120000..0xff11ffff
   2: 0x00000000..0xffffffff

Hence, do not free memory allocated for reserved memory regions if
defined(CONFIG_DEBUG_FS) && !defined(CONFIG_ARCH_DISCARD_MEMBLOCK).

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/memblock.c~mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock mm/memblock.c
--- a/mm/memblock.c~mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock
+++ a/mm/memblock.c
@@ -269,6 +269,19 @@ phys_addr_t __init_memblock get_allocate
 	if (memblock.reserved.regions == memblock_reserved_init_regions)
 		return 0;
 
+	/*
+	 * Don't allow nobootmem allocator to free reserved memory regions
+	 * array if
+	 *  - CONFIG_DEBUG_FS is enabled;
+	 *  - CONFIG_ARCH_DISCARD_MEMBLOCK is not enabled;
+	 *  - reserved memory regions array have been resized during boot.
+	 * Otherwise debug_fs entry "sys/kernel/debug/memblock/reserved"
+	 * will show garbage instead of state of memory reservations.
+	 */
+	if (IS_ENABLED(CONFIG_DEBUG_FS) &&
+	    !IS_ENABLED(CONFIG_ARCH_DISCARD_MEMBLOCK))
+		return 0;
+
 	*addr = __pa(memblock.reserved.regions);
 
 	return PAGE_ALIGN(sizeof(struct memblock_region) *
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

