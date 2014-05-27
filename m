From: akpm@linux-foundation.org
Subject: + fs-superc-avoid-counting-without-__gfp_fs.patch added to -mm
 tree
Date: Tue, 27 May 2014 14:24:28 -0700
Message-ID: <5385028c.eRRm/6e3XkPotvtU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaE0VY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 17:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuanhan.liu@linux.intel.com, viro@zeniv.linux.org.uk, tim.c.chen@linux.intel.com, riel@redhat.com, mgorman@suse.de, jack@suse.cz, hannes@cmpxchg.org, david@fromorbit.com, bob.liu@oracle.com, hughd@google.com

Subject: + fs-superc-avoid-counting-without-__gfp_fs.patch added to -mm tree
To: hughd@google.com,bob.liu@oracle.com,david@fromorbit.com,hannes@cmpxchg.org,jack@suse.cz,mgorman@suse.de,riel@redhat.com,tim.c.chen@linux.intel.com,viro@zeniv.linux.org.uk,yuanhan.liu@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 14:24:28 -0700


The patch titled
     Subject: fs/super.c: avoid counting without __GFP_FS
has been added to the -mm tree.  Its filename is
     fs-superc-avoid-counting-without-__gfp_fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-superc-avoid-counting-without-__gfp_fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-superc-avoid-counting-without-__gfp_fs.patch

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
Subject: fs/super.c: avoid counting without __GFP_FS

Don't waste time counting objects in super_cache_count() if no __GFP_FS:
super_cache_scan() would only back out with SHRINK_STOP in that case.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/super.c~fs-superc-avoid-counting-without-__gfp_fs fs/super.c
--- a/fs/super.c~fs-superc-avoid-counting-without-__gfp_fs
+++ a/fs/super.c
@@ -110,6 +110,12 @@ static unsigned long super_cache_count(s
 	struct super_block *sb;
 	long	total_objects = 0;
 
+	/*
+	 * None can be freed without __GFP_FS, so don't waste time counting.
+	 */
+	if (!(sc->gfp_mask & __GFP_FS))
+		return 0;
+
 	sb = container_of(shrink, struct super_block, s_shrink);
 
 	/*
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
fs-superc-avoid-counting-without-__gfp_fs.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

