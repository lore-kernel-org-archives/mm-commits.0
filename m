From: akpm@linux-foundation.org
Subject: [merged]
 dont-allocate-firmware_map_entry-of-same-memory-range.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:05:33 -0700
Message-ID: <53e3dc0d.ojmdxLbvA751uLjp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:51000 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:34 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1175889pdj.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/memmap.c: don't allocate firmware_map_entry of same memory range
has been removed from the -mm tree.  Its filename was
     dont-allocate-firmware_map_entry-of-same-memory-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: drivers/firmware/memmap.c: don't allocate firmware_map_entry of same memory range

When limiting memory by mem= and ACPI DSDT table has PNP0C80,
firmware_map_entrys of same memory range are allocated and memmap X
sysfses which have same memory range are created as follows:

 # cat /sys/firmware/memmap/0/*
 0x407ffffffff
 0x40000000000
 System RAM
 # cat /sys/firmware/memmap/33/*
 0x407ffffffff
 0x40000000000
 System RAM
 # cat /sys/firmware/memmap/35/*
 0x407ffffffff
 0x40000000000
 System RAM

In this case, when hot-removing memory, kernel panic occurs, showing
following call trace:

 BUG: unable to handle kernel paging request at 00000001003e000b
 IP: [<ffffffff81225c26>] sysfs_open_file+0x46/0x2b0
 PGD 203a89fe067 PUD 0
 Oops: 0000 [#1] SMP
 ...
 Call Trace:
  [<ffffffff811ad95f>] do_dentry_open+0x1ef/0x2a0
  [<ffffffff811bba32>] ? __inode_permission+0x52/0xc0
  [<ffffffff81225be0>] ? sysfs_schedule_callback+0x1c0/0x1c0
  [<ffffffff811ada41>] finish_open+0x31/0x40
  [<ffffffff811bf6ac>] do_last+0x57c/0x1220
  [<ffffffff8119529e>] ? kmem_cache_alloc_trace+0x1ce/0x1f0
  [<ffffffff811c0412>] path_openat+0xc2/0x4c0
  [<ffffffff81167e2c>] ? tlb_flush_mmu.part.53+0x4c/0x90
  [<ffffffff811c102b>] do_filp_open+0x4b/0xb0
  [<ffffffff811cd827>] ? __alloc_fd+0xa7/0x130
  [<ffffffff811aeed3>] do_sys_open+0xf3/0x1f0
  [<ffffffff811aefee>] SyS_open+0x1e/0x20
  [<ffffffff815f2199>] system_call_fastpath+0x16/0x1b

The problem occurs as follows:

When calling e820_reserve_resources(), firmware_map_entrys of all
e820 memory map are allocated. And all firmware_map_entrys is added
map_entries list as follows:

map_entries
 -> +--- entry A --------+ -> ...
    | start 0x407ffffffff|
    | end   0x40000000000|
    | type  System RAM   |
    +--------------------+

After that, if ACPI DSDT table has PNP0C80 and the memory range is
limited by mem=, the PNP0C80 is hot-added. Then firmware_map_entry of
PNP0C80 is allocated and added map_entries list as follows:

map_entries
 -> +--- entry A --------+ -> ... -> +--- entry B --------+
    | start 0x407ffffffff|           | start 0x407ffffffff|
    | end   0x40000000000|           | end   0x40000000000|
    | type  System RAM   |           | type  System RAM   |
    +--------------------+           +--------------------+

Then memmap 0 sysfs for entry B is created.

After that, firmware_memmap_init() creates memmap sysfses of all
firmware_map_entrys in map_entries list.  As a result, memmap 33 sysfs for
entry A and memmap 35 sysfs for entry B are created.  But kobject of entry
B has been used by memmap 0 sysfs.  So when creating memmap 35 sysfs, the
kobject is broken.

If hot-removing memory, memmap 0 sysfs is destroyed and kobject of memmap
0 sysfs is freed.  But the kobject can be accessed via memmap 35 sysfs. 
So when open memmap 35 sysfs, kernel panic occurs.

This patch checks whether there is firmware_map_entry of same memory range
in map_entries list and don't allocate firmware_map_entry of same memroy
range.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/firmware/memmap.c~dont-allocate-firmware_map_entry-of-same-memory-range drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~dont-allocate-firmware_map_entry-of-same-memory-range
+++ a/drivers/firmware/memmap.c
@@ -286,6 +286,10 @@ int __meminit firmware_map_add_hotplug(u
 {
 	struct firmware_map_entry *entry;
 
+	entry = firmware_map_find_entry(start, end - 1, type);
+	if (entry)
+		return 0;
+
 	entry = firmware_map_find_entry_bootmem(start, end - 1, type);
 	if (!entry) {
 		entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch

