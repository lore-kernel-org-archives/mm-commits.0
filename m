From: akpm@linux-foundation.org
Subject: + mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split.patch added to -mm tree
Date: Tue, 08 Jan 2013 13:56:05 -0800
Message-ID: <20130108215605.D6F82100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:43312 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3AHV4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 16:56:07 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so138778vba.0
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 13:56:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.beregalov@gmail.com, aarcange@redhat.com, alex_y_xu@yahoo.ca, zliu@redhat.com


The patch titled
     Subject: mm: thp: acquire the anon_vma rwsem for write during split
has been added to the -mm tree.  Its filename is
     mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: thp: acquire the anon_vma rwsem for write during split

Zhouping Liu reported the following against 3.8-rc1 when running a mmap
testcase from LTP.

[  588.143072] mapcount 0 page_mapcount 3
[  588.147471] ------------[ cut here ]------------
[  588.152856] kernel BUG at mm/huge_memory.c:1798!
[  588.158125] invalid opcode: 0000 [#1] SMP
[  588.162882] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables bnep bluetooth rfkill iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter
+ip_tables be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio libcxgbi ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi vfat fat
+dm_mirror dm_region_hash dm_log dm_mod cdc_ether iTCO_wdt i7core_edac coretemp usbnet iTCO_vendor_support mii crc32c_intel edac_core lpc_ich shpchp ioatdma mfd_core i2c_i801 pcspkr serio_raw bnx2 microcode dca
+vhost_net tun macvtap macvlan kvm_intel kvm uinput mgag200 sr_mod cdrom i2c_algo_bit sd_mod drm_kms_helper crc_t10dif ata_generic pata_acpi ttm ata_piix drm libata i2c_core megaraid_sas

[  588.246517] CPU 1
[  588.248636] Pid: 23217, comm: mmap10 Not tainted 3.8.0-rc1mainline+ #17 IBM IBM System x3400 M3 Server -[7379I08]-/69Y4356
[  588.262171] RIP: 0010:[<ffffffff8118fac7>]  [<ffffffff8118fac7>] __split_huge_page+0x677/0x6d0
[  588.272067] RSP: 0000:ffff88017a03fc08  EFLAGS: 00010293
[  588.278235] RAX: 0000000000000003 RBX: ffff88027a6c22e0 RCX: 00000000000034d2
[  588.286394] RDX: 000000000000748b RSI: 0000000000000046 RDI: 0000000000000246
[  588.294216] RBP: ffff88017a03fcb8 R08: ffffffff819d2440 R09: 000000000000054a
[  588.302441] R10: 0000000000aaaaaa R11: 00000000ffffffff R12: 0000000000000000
[  588.310495] R13: 00007f4f11a00000 R14: ffff880179e96e00 R15: ffffea0005c08000
[  588.318640] FS:  00007f4f11f4a740(0000) GS:ffff88017bc20000(0000) knlGS:0000000000000000
[  588.327894] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  588.334569] CR2: 00000037e9ebb404 CR3: 000000017a436000 CR4: 00000000000007e0
[  588.342718] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  588.350861] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  588.359134] Process mmap10 (pid: 23217, threadinfo ffff88017a03e000, task ffff880172dd32e0)
[  588.368667] Stack:
[  588.370960]  ffff88017a540ec8 ffff88017a03fc20 ffffffff816017b5 ffff88017a03fc88
[  588.379566]  ffffffff812fa014 0000000000000000 ffff880279ebd5c0 00000000f4f11a4c
[  588.388150]  00000007f4f11f49 00000007f4f11a00 ffff88017a540ef0 ffff88017a540ee8
[  588.396711] Call Trace:
[  588.455106]  [<ffffffff816017b5>] ? rwsem_down_read_failed+0x15/0x17
[  588.518106]  [<ffffffff812fa014>] ? call_rwsem_down_read_failed+0x14/0x30
[  588.580897]  [<ffffffff815ffc04>] ? down_read+0x24/0x2b
[  588.642630]  [<ffffffff8118fb88>] split_huge_page+0x68/0xb0
[  588.703814]  [<ffffffff81190ed4>] __split_huge_page_pmd+0x134/0x330
[  588.766064]  [<ffffffff8104b997>] ? pte_alloc_one+0x37/0x50
[  588.826460]  [<ffffffff81191121>] split_huge_page_pmd_mm+0x51/0x60
[  588.887746]  [<ffffffff8119116b>] split_huge_page_address+0x3b/0x50
[  588.948673]  [<ffffffff8119121c>] __vma_adjust_trans_huge+0x9c/0xf0
[  589.008660]  [<ffffffff811650f4>] vma_adjust+0x684/0x750
[  589.066328]  [<ffffffff811653ba>] __split_vma.isra.28+0x1fa/0x220
[  589.123497]  [<ffffffff810135d1>] ? __switch_to+0x181/0x4a0
[  589.180704]  [<ffffffff811661a9>] do_munmap+0xf9/0x420
[  589.237461]  [<ffffffff8160026c>] ? __schedule+0x3cc/0x7b0
[  589.294520]  [<ffffffff8116651e>] vm_munmap+0x4e/0x70
[  589.350784]  [<ffffffff8116741b>] sys_munmap+0x2b/0x40
[  589.406971]  [<ffffffff8160a159>] system_call_fastpath+0x16/0x1b

Alexander Beregalov and Alex Xu reported similar bugs and Hillf Danton
identified that commit 5a505085 (mm/rmap: Convert the struct anon_vma::mutex
to an rwsem) and commit 4fc3f1d6 (mm/rmap, migration: Make rmap_walk_anon()
and try_to_unmap_anon() more scalable) were likely the problem. Reverting
these commits was reported to solve the problem for Alexander.

Despite the reason for these commits, NUMA balancing is not the direct
source of the problem. split_huge_page() expects the anon_vma lock to be
exclusive to serialise the whole split operation. Ordinarily it is expected
that the anon_vma lock would only be required when updating the avcs but
THP also uses the anon_vma rwsem for collapse and split operations where
the page lock or compound lock cannot be used (as the page is changing
from base to THP or vice versa) and the page table locks are
insufficient.

This patch takes the anon_vma lock for write to serialise against parallel
split_huge_page as THP expected before the conversion to rwsem.

Reported-and-tested-by: Zhouping Liu <zliu@redhat.com>
Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Reported-by: Alex Xu <alex_y_xu@yahoo.ca>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split
+++ a/mm/huge_memory.c
@@ -1819,9 +1819,19 @@ int split_huge_page(struct page *page)
 
 	BUG_ON(is_huge_zero_pfn(page_to_pfn(page)));
 	BUG_ON(!PageAnon(page));
-	anon_vma = page_lock_anon_vma_read(page);
+
+	/*
+	 * The caller does not necessarily hold an mmap_sem that would prevent
+	 * the anon_vma disappearing so we first we take a reference to it
+	 * and then lock the anon_vma for write. This is similar to
+	 * page_lock_anon_vma_read except the write lock is taken to serialise
+	 * against parallel split or collapse operations.
+	 */
+	anon_vma = page_get_anon_vma(page);
 	if (!anon_vma)
 		goto out;
+	anon_vma_lock_write(anon_vma);
+
 	ret = 0;
 	if (!PageCompound(page))
 		goto out_unlock;
@@ -1832,7 +1842,8 @@ int split_huge_page(struct page *page)
 
 	BUG_ON(PageCompound(page));
 out_unlock:
-	page_unlock_anon_vma_read(anon_vma);
+	anon_vma_unlock(anon_vma);
+	put_anon_vma(anon_vma);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-migrate-check-page_count-of-thp-before-migrating.patch
mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch
mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch
mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-swap-out-anonymous-page-regardless-of-laptop_mode.patch
mm-memmap_init_zone-performance-improvement.patch

