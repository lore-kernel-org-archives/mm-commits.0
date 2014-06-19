From: akpm@linux-foundation.org
Subject: +
 x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch added to -mm tree
Date: Thu, 19 Jun 2014 14:25:58 -0700
Message-ID: <53a35566.Upb1hX9yW8iempCY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaFSVZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 17:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, toshi.kani@hp.com, tglx@linutronix.de, tangchen@cn.fujitsu.com, mingo@redhat.com, hpa@zytor.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com


The patch titled
     Subject: x86,mem-hotplug: pass sync_global_pgds() a correct argument in remove_pagetable()
has been added to the -mm tree.  Its filename is
     x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch

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
Subject: x86,mem-hotplug: pass sync_global_pgds() a correct argument in remove_pagetable()

When hot-adding memory after hot-removing memory, following call traces
are shown:

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

The patch-sets fix the issue.


This patch (of 2):

remove_pagetable() gets start argument and passes the argument to
sync_global_pgds().  In this case, the argument must not be modified.  If
the argument is modified and passed to sync_global_pgds(),
sync_global_pgds() does not correctly synchronize PGD to PGD entries of
all processes MM since synchronized range of memory [start, end] is wrong.

Unfortunately the start argument is modified in remove_pagetable().  So
this patch fixes the issue.

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

 arch/x86/mm/init_64.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable
+++ a/arch/x86/mm/init_64.c
@@ -975,19 +975,20 @@ static void __meminit
 remove_pagetable(unsigned long start, unsigned long end, bool direct)
 {
 	unsigned long next;
+	unsigned long addr;
 	pgd_t *pgd;
 	pud_t *pud;
 	bool pgd_changed = false;
 
-	for (; start < end; start = next) {
-		next = pgd_addr_end(start, end);
+	for (addr = start; addr < end; addr = next) {
+		next = pgd_addr_end(addr, end);
 
-		pgd = pgd_offset_k(start);
+		pgd = pgd_offset_k(addr);
 		if (!pgd_present(*pgd))
 			continue;
 
 		pud = (pud_t *)pgd_page_vaddr(*pgd);
-		remove_pud_table(pud, start, next, direct);
+		remove_pud_table(pud, addr, next, direct);
 		if (free_pud_table(pud, pgd))
 			pgd_changed = true;
 	}
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch

