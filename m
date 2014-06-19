From: akpm@linux-foundation.org
Subject: + x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
 added to -mm tree
Date: Thu, 19 Jun 2014 14:26:00 -0700
Message-ID: <53a35568.Clgjt7JlTyGZ9WXR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaFSV0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 17:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, toshi.kani@hp.com, tglx@linutronix.de, tangchen@cn.fujitsu.com, mingo@redhat.com, hpa@zytor.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com


The patch titled
     Subject: x86,mem-hotplug: modify PGD entry when removing memory
has been added to the -mm tree.  Its filename is
     x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: x86,mem-hotplug: modify PGD entry when removing memory

When hot-adding/removing memory, sync_global_pgds() is called for
synchronizing PGD to PGD entries of all processes MM.  But when
hot-removing memory, sync_global_pgds() does not work correctly.

At first, sync_global_pgds() checks whether target PGD is none or not. 
And if PGD is none, the PGD is skipped.  But when hot-removing memory, PGD
may be none since PGD may be cleared by free_pud_table().  So when
sync_global_pgds() is called after hot-removing memory, sync_global_pgds()
should not skip PGD even if the PGD is none.  And sync_global_pgds() must
clear PGD entries of all processes MM.

Currently sync_global_pgds() does not clear PGD entries of all processes
MM when hot-removing memory.  So when hot adding memory which is same
memory range as removed memory after hot-removing memory, following call
traces are shown:

kernel BUG at arch/x86/mm/init_64.c:206!
...
 [<ffffffff815e0c80>] kernel_physical_mapping_init+0x1b2/0x1d2
 [<ffffffff815ced94>] init_memory_mapping+0x1d4/0x380
 [<ffffffff8104aebd>] arch_add_memory+0x3d/0xd0
 [<ffffffff815d03d9>] add_memory+0xb9/0x1b0
 [<ffffffff81352415>] acpi_memory_device_add+0x1af/0x28e
 [<ffffffff81325dc4>] acpi_bus_device_attach+0x8c/0xf0
 [<ffffffff813413b9>] acpi_ns_walk_namespace+0xc8/0x17f
 [<ffffffff81325d38>] ? acpi_bus_type_and_status+0xb7/0xb7
 [<ffffffff81325d38>] ? acpi_bus_type_and_status+0xb7/0xb7
 [<ffffffff813418ed>] acpi_walk_namespace+0x95/0xc5
 [<ffffffff81326b4c>] acpi_bus_scan+0x9a/0xc2
 [<ffffffff81326bff>] acpi_scan_bus_device_check+0x8b/0x12e
 [<ffffffff81326cb5>] acpi_scan_device_check+0x13/0x15
 [<ffffffff81320122>] acpi_os_execute_deferred+0x25/0x32
 [<ffffffff8107e02b>] process_one_work+0x17b/0x460
 [<ffffffff8107edfb>] worker_thread+0x11b/0x400
 [<ffffffff8107ece0>] ? rescuer_thread+0x400/0x400
 [<ffffffff81085aef>] kthread+0xcf/0xe0
 [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff815fc76c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81085a20>] ? kthread_create_on_node+0x140/0x140

This patch clears PGD entries of all processes MM when sync_global_pgds()
is called after hot-removing memory

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h |    3 ++-
 arch/x86/mm/fault.c               |    2 +-
 arch/x86/mm/init_64.c             |   27 +++++++++++++++++++--------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/pgtable_64.h~x86mem-hotplug-modify-pgd-entry-when-removing-memory arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86mem-hotplug-modify-pgd-entry-when-removing-memory
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -115,7 +115,8 @@ static inline void native_pgd_clear(pgd_
 	native_set_pgd(pgd, native_make_pgd(0));
 }
 
-extern void sync_global_pgds(unsigned long start, unsigned long end);
+extern void sync_global_pgds(unsigned long start, unsigned long end,
+			     int removed);
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff -puN arch/x86/mm/fault.c~x86mem-hotplug-modify-pgd-entry-when-removing-memory arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86mem-hotplug-modify-pgd-entry-when-removing-memory
+++ a/arch/x86/mm/fault.c
@@ -350,7 +350,7 @@ out:
 
 void vmalloc_sync_all(void)
 {
-	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END);
+	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END, 0);
 }
 
 /*
diff -puN arch/x86/mm/init_64.c~x86mem-hotplug-modify-pgd-entry-when-removing-memory arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86mem-hotplug-modify-pgd-entry-when-removing-memory
+++ a/arch/x86/mm/init_64.c
@@ -178,7 +178,7 @@ __setup("noexec32=", nonx32_setup);
  * When memory was added/removed make sure all the processes MM have
  * suitable PGD entries in the local PGD level page.
  */
-void sync_global_pgds(unsigned long start, unsigned long end)
+void sync_global_pgds(unsigned long start, unsigned long end, int removed)
 {
 	unsigned long address;
 
@@ -186,7 +186,12 @@ void sync_global_pgds(unsigned long star
 		const pgd_t *pgd_ref = pgd_offset_k(address);
 		struct page *page;
 
-		if (pgd_none(*pgd_ref))
+		/*
+		 * When it is called after memory hot remove, pgd_none()
+		 * returns true. In this case (removed == 1), we must clear
+		 * the PGD entries in the local PGD level page.
+		 */
+		if (pgd_none(*pgd_ref) && !removed)
 			continue;
 
 		spin_lock(&pgd_lock);
@@ -199,12 +204,18 @@ void sync_global_pgds(unsigned long star
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);
 
-			if (pgd_none(*pgd))
-				set_pgd(pgd, *pgd_ref);
-			else
+			if (!pgd_none(*pgd_ref) && !pgd_none(*pgd))
 				BUG_ON(pgd_page_vaddr(*pgd)
 				       != pgd_page_vaddr(*pgd_ref));
 
+			if (removed) {
+				if (pgd_none(*pgd_ref) && !pgd_none(*pgd))
+					pgd_clear(pgd);
+			} else {
+				if (pgd_none(*pgd))
+					set_pgd(pgd, *pgd_ref);
+			}
+
 			spin_unlock(pgt_lock);
 		}
 		spin_unlock(&pgd_lock);
@@ -633,7 +644,7 @@ kernel_physical_mapping_init(unsigned lo
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(addr, end - 1);
+		sync_global_pgds(addr, end - 1, 0);
 
 	__flush_tlb_all();
 
@@ -994,7 +1005,7 @@ remove_pagetable(unsigned long start, un
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(start, end - 1);
+		sync_global_pgds(start, end - 1, 1);
 
 	flush_tlb_all();
 }
@@ -1341,7 +1352,7 @@ int __meminit vmemmap_populate(unsigned
 	else
 		err = vmemmap_populate_basepages(start, end, node);
 	if (!err)
-		sync_global_pgds(start, end - 1);
+		sync_global_pgds(start, end - 1, 0);
 	return err;
 }
 
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch

