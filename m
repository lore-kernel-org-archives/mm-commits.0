From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:07 -0700
Message-ID: <55f08e23./KxJaozD06i3eI2W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbbIITxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix race between soft_offline_page and unpoison_memory
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: fix race between soft_offline_page and unpoison_memory

Wanpeng Li reported a race between soft_offline_page() and
unpoison_memory(), which causes the following kernel panic:

  [   61.572584] BUG: Bad page state in process bash  pfn:97000
  [   61.578106] page:ffffea00025c0000 count:0 mapcount:1 mapping:          (null) index:0x7f4fdbe00
  [   61.586803] flags: 0x1fffff80080048(uptodate|active|swapbacked)
  [   61.592809] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
  [   61.599250] bad because of flags:
  [   61.602567] flags: 0x40(active)
  [   61.605746] Modules linked in: snd_hda_codec_hdmi i915 rpcsec_gss_krb5 nfsv4 dns_resolver bnep rfcomm nfsd bluetooth auth_rpcgss nfs_acl nfs rfkill lockd grace sunrpc i2c_algo_bit drm_kms_helper snd_hda_codec_realtek snd_hda_codec_generic drm snd_hda_intel fscache snd_hda_codec x86_pkg_temp_thermal coretemp kvm_intel snd_hda_core snd_hwdep kvm snd_pcm snd_seq_dummy snd_seq_oss crct10dif_pclmul snd_seq_midi crc32_pclmul snd_seq_midi_event ghash_clmulni_intel snd_rawmidi aesni_intel lrw gf128mul snd_seq glue_helper ablk_helper snd_seq_device cryptd fuse snd_timer dcdbas serio_raw mei_me parport_pc snd mei ppdev i2c_core video lp soundcore parport lpc_ich shpchp mfd_core ext4 mbcache jbd2 sd_mod e1000e ahci ptp libahci crc32c_intel libata pps_core
  [   61.605827] CPU: 3 PID: 2211 Comm: bash Not tainted 4.2.0-rc5-mm1+ #45
  [   61.605829] Hardware name: Dell Inc. OptiPlex 7020/0F5C5X, BIOS A03 01/08/2015
  [   61.605832]  ffffffff818b3be8 ffff8800da373ad8 ffffffff8165ceb4 0000000001313ce1
  [   61.605837]  ffffea00025c0000 ffff8800da373b08 ffffffff8117bdd6 ffff88021edd4b00
  [   61.605842]  0000000000000001 001fffff80080048 0000000000000000 ffff8800da373b88
  [   61.605847] Call Trace:
  [   61.605858]  [<ffffffff8165ceb4>] dump_stack+0x48/0x5c
  [   61.605865]  [<ffffffff8117bdd6>] bad_page+0xe6/0x140
  [   61.605870]  [<ffffffff8117dfc9>] free_pages_prepare+0x2f9/0x320
  [   61.605876]  [<ffffffff811e817d>] ? uncharge_list+0xdd/0x100
  [   61.605882]  [<ffffffff8117ff20>] free_hot_cold_page+0x40/0x170
  [   61.605888]  [<ffffffff81185dd0>] __put_single_page+0x20/0x30
  [   61.605892]  [<ffffffff81186675>] put_page+0x25/0x40
  [   61.605897]  [<ffffffff811dc276>] unmap_and_move+0x1a6/0x1f0
  [   61.605908]  [<ffffffff811dc3c0>] migrate_pages+0x100/0x1d0
  [   61.605914]  [<ffffffff811eb710>] ? kill_procs+0x100/0x100
  [   61.605918]  [<ffffffff811764af>] ? unlock_page+0x6f/0x90
  [   61.605923]  [<ffffffff811ecf37>] __soft_offline_page+0x127/0x2a0
  [   61.605928]  [<ffffffff811ed156>] soft_offline_page+0xa6/0x200

This race is explained like below:

  CPU0                    CPU1

  soft_offline_page
  __soft_offline_page
  TestSetPageHWPoison
                        unpoison_memory
                        PageHWPoison check (true)
                        TestClearPageHWPoison
                        put_page    -> release refcount held by get_hwpoison_page in unpoison_memory
                        put_page    -> release refcount held by isolate_lru_page in __soft_offline_page
  migrate_pages

The second put_page() releases refcount held by isolate_lru_page() which
will lead to unmap_and_move() releases the last refcount of page and w/
mapcount still 1 since try_to_unmap() is not called if there is only one
user map the page.  Anyway, the page refcount and mapcount will still mess
if the page is mapped by multiple users.

This race was introduced by commit 4491f71260 ("mm/memory-failure: set
PageHWPoison before migrate_pages()"), which focuses on preventing the
reuse of successfully migrated page.  Before this commit we prevent the
reuse by changing the migratetype to MIGRATE_ISOLATE during soft
offlining, which has the following problems, so simply reverting the
commit is not a best option:

  1) it doesn't eliminate the reuse completely, because
     set_migratetype_isolate() can fail to set MIGRATE_ISOLATE to the
     target page if the pageblock of the page contains one or more
     unmovable pages (i.e.  has_unmovable_pages() returns true).

  2) the original code changes migratetype to MIGRATE_ISOLATE
     forcibly, and sets it to MIGRATE_MOVABLE forcibly after soft offline,
     regardless of the original migratetype state, which could impact
     other subsystems like memory hotplug or compaction.

This patch moves PageSetHWPoison just after put_page() in
unmap_and_move(), which closes up the reported race window and minimizes
another race window b/w SetPageHWPoison and reallocation (which causes the
reuse of soft-offlined page.) The latter race window still exists but it's
acceptable, because it's rare and effectively the same as ordinary
"containment failure" case even if it happens, so keep the window open is
acceptable.

Fixes: 4491f71260 ("mm/memory-failure: set PageHWPoison before migrate_pages()")
Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Wanpeng Li <wanpeng.li@hotmail.com>
Tested-by: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   14 ++++++++++++++
 mm/memory-failure.c     |    4 ----
 mm/migrate.c            |    9 +++++----
 3 files changed, 19 insertions(+), 8 deletions(-)

diff -puN include/linux/swapops.h~mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory include/linux/swapops.h
--- a/include/linux/swapops.h~mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory
+++ a/include/linux/swapops.h
@@ -181,6 +181,11 @@ static inline int is_hwpoison_entry(swp_
 	return swp_type(entry) == SWP_HWPOISON;
 }
 
+static inline bool test_set_page_hwpoison(struct page *page)
+{
+	return TestSetPageHWPoison(page);
+}
+
 static inline void num_poisoned_pages_inc(void)
 {
 	atomic_long_inc(&num_poisoned_pages);
@@ -211,6 +216,15 @@ static inline int is_hwpoison_entry(swp_
 {
 	return 0;
 }
+
+static inline bool test_set_page_hwpoison(struct page *page)
+{
+	return false;
+}
+
+static inline void num_poisoned_pages_inc(void)
+{
+}
 #endif
 
 #if defined(CONFIG_MEMORY_FAILURE) || defined(CONFIG_MIGRATION)
diff -puN mm/memory-failure.c~mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory
+++ a/mm/memory-failure.c
@@ -1681,8 +1681,6 @@ static int __soft_offline_page(struct pa
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
 					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
-		if (!TestSetPageHWPoison(page))
-			num_poisoned_pages_dec();
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
@@ -1697,8 +1695,6 @@ static int __soft_offline_page(struct pa
 				pfn, ret, page->flags);
 			if (ret > 0)
 				ret = -EIO;
-			if (TestClearPageHWPoison(page))
-				num_poisoned_pages_dec();
 		}
 	} else {
 		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
diff -puN mm/migrate.c~mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory mm/migrate.c
--- a/mm/migrate.c~mm-hwpoison-fix-race-between-soft_offline_page-and-unpoison_memory
+++ a/mm/migrate.c
@@ -880,8 +880,7 @@ static int __unmap_and_move(struct page
 	/* Establish migration ptes or remove ptes */
 	if (page_mapped(page)) {
 		try_to_unmap(page,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
-			TTU_IGNORE_HWPOISON);
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 		page_was_mapped = 1;
 	}
 
@@ -952,9 +951,11 @@ out:
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
 		/* Soft-offlined page shouldn't go through lru cache list */
-		if (reason == MR_MEMORY_FAILURE)
+		if (reason == MR_MEMORY_FAILURE) {
 			put_page(page);
-		else
+			if (!test_set_page_hwpoison(page))
+				num_poisoned_pages_inc();
+		} else
 			putback_lru_page(page);
 	}
 
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are


