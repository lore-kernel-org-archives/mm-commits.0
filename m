From: akpm@linux-foundation.org
Subject: [merged] firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init.patch removed from -mm tree
Date: Mon, 22 Oct 2012 12:13:33 -0700
Message-ID: <20121022191333.B2059100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:36760 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2JVTNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:13:34 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so377388vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:13:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, bwalle@suse.de, glommer@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware/memmap: avoid type conflicts with the generic memmap_init()
has been removed from the -mm tree.  Its filename was
     firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: firmware/memmap: avoid type conflicts with the generic memmap_init()

This will fix build error:

drivers/firmware/memmap.c:240:19: error: conflicting types for 'memmap_init'
arch/ia64/include/asm/pgtable.h:565:17: note: previous declaration of 'memmap_init' was here

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init
+++ a/drivers/firmware/memmap.c
@@ -237,7 +237,7 @@ static ssize_t memmap_attr_show(struct k
  * firmware_map_add() or firmware_map_add_early() afterwards, the entries
  * are not added to sysfs.
  */
-static int __init memmap_init(void)
+static int __init firmware_memmap_init(void)
 {
 	struct firmware_map_entry *entry;
 
@@ -246,5 +246,5 @@ static int __init memmap_init(void)
 
 	return 0;
 }
-late_initcall(memmap_init);
+late_initcall(firmware_memmap_init);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
h8300-select-generic-atomic64_t-support.patch
writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

