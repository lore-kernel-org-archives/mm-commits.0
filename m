From: akpm@linux-foundation.org
Subject: +
 mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
 added to -mm tree
Date: Tue, 02 Jun 2015 13:18:35 -0700
Message-ID: <556e0f9b.mQ5Pc3eBkVMGqA/H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbFBUSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 16:18:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, anton@tuxera.com, david@fromorbit.com, hannes@cmpxchg.org, mgorman@suse.de, neilb@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not ignore mapping_gfp_mask in page cache allocation paths
has been added to the -mm tree.  Its filename is
     mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: do not ignore mapping_gfp_mask in page cache allocation paths

page_cache_read, do_generic_file_read, __generic_file_splice_read and
__ntfs_grab_cache_pages currently ignore mapping_gfp_mask when calling
add_to_page_cache_lru which might cause recursion into fs down in the
direct reclaim path if the mapping really relies on GFP_NOFS semantic.

This doesn't seem to be the case now because page_cache_read (page fault
path) doesn't seem to suffer from the reclaim recursion issues and
do_generic_file_read and __generic_file_splice_read also shouldn't be
called under fs locks which would deadlock in the reclaim path.  Anyway it
is better to obey mapping gfp mask and prevent from later breakage.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |    3 ++-
 fs/splice.c    |    2 +-
 mm/filemap.c   |    6 ++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/ntfs/file.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths fs/ntfs/file.c
--- a/fs/ntfs/file.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths
+++ a/fs/ntfs/file.c
@@ -525,7 +525,8 @@ static inline int __ntfs_grab_cache_page
 				}
 			}
 			err = add_to_page_cache_lru(*cached_page, mapping,
-					index, GFP_KERNEL);
+					index,
+					GFP_KERNEL & mapping_gfp_mask(mapping));
 			if (unlikely(err)) {
 				if (err == -EEXIST)
 					continue;
diff -puN fs/splice.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths fs/splice.c
--- a/fs/splice.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths
+++ a/fs/splice.c
@@ -359,7 +359,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-						GFP_KERNEL);
+						GFP_KERNEL & mapping_gfp_mask(mapping));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
diff -puN mm/filemap.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths mm/filemap.c
--- a/mm/filemap.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths
+++ a/mm/filemap.c
@@ -1665,7 +1665,8 @@ no_cached_page:
 			goto out;
 		}
 		error = add_to_page_cache_lru(page, mapping,
-						index, GFP_KERNEL);
+						index,
+						GFP_KERNEL & mapping_gfp_mask(mapping));
 		if (error) {
 			page_cache_release(page);
 			if (error == -EEXIST) {
@@ -1766,7 +1767,8 @@ static int page_cache_read(struct file *
 		if (!page)
 			return -ENOMEM;
 
-		ret = add_to_page_cache_lru(page, mapping, offset, GFP_KERNEL);
+		ret = add_to_page_cache_lru(page, mapping, offset,
+				GFP_KERNEL & mapping_gfp_mask(mapping));
 		if (ret == 0)
 			ret = mapping->a_ops->readpage(file, page);
 		else if (ret == -EEXIST)
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-do-not-call-reclaim-if-__gfp_wait.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-only-define-hashdist-variable-when-needed.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior.patch
oom-print-points-as-unsigned-int.patch
oom-always-panic-on-oom-when-panic_on_oom-is-configured.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch
linux-next.patch

