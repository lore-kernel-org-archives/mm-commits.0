From: akpm@linux-foundation.org
Subject: +
 vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch added to -mm tree
Date: Tue, 27 May 2014 15:01:54 -0700
Message-ID: <53850b52.aBjYOJumHEdvw/oc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaE0WBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 18:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com

Subject: + vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch added to -mm tree
To: hughd@google.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 15:01:54 -0700


The patch titled
     Subject:  vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o om-control-fix.patch
has been added to the -mm tree.  Its filename is
     vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject:  vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o om-control-fix.patch

mem_cgroup_swappiness() oopses immediately when booted with
cgroup_disable=memory.  Fix that in the obvious inelegant way for now -
though I hope we are moving towards a world in which almost all of the
mem_cgroup_disabled() tests will vanish, with a root_mem_cgroup which can
handle the basics even when disabled.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch
+++ a/mm/memcontrol.c
@@ -1548,7 +1548,7 @@ static unsigned long mem_cgroup_margin(s
 int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	/* root ? */
-	if (!memcg->css.parent)
+	if (mem_cgroup_disabled() || !memcg->css.parent)
 		return vm_swappiness;
 
 	return memcg->swappiness;
_

Patches currently in -mm which might be from hughd@google.com are

mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch
mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
fs-bufferc-remove-block_write_full_page_endio.patch
fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch
fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
brd-add-support-for-rw_page.patch
brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
mm-process_vm_access-move-config-option-into-init-kconfig.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

