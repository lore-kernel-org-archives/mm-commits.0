From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:59 -0700
Message-ID: <5591ace3.1w8QKUP0tQaxWR1y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbbF2UjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, anton@tuxera.com, david@fromorbit.com, hannes@cmpxchg.org, mgorman@suse.de, neilb@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not ignore mapping_gfp_mask in page cache allocation paths
has been removed from the -mm tree.  Its filename was
     mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
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
 mm/filemap.c   |    7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

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
+					GFP_KERNEL & mapping_gfp_mask(mapping));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
diff -puN mm/filemap.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths mm/filemap.c
--- a/mm/filemap.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths
+++ a/mm/filemap.c
@@ -1664,8 +1664,8 @@ no_cached_page:
 			error = -ENOMEM;
 			goto out;
 		}
-		error = add_to_page_cache_lru(page, mapping,
-						index, GFP_KERNEL);
+		error = add_to_page_cache_lru(page, mapping, index,
+					GFP_KERNEL & mapping_gfp_mask(mapping));
 		if (error) {
 			page_cache_release(page);
 			if (error == -EEXIST) {
@@ -1766,7 +1766,8 @@ static int page_cache_read(struct file *
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

origin.patch
mm-meminit-inline-some-helper-functions-fix2.patch
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
linux-next.patch

