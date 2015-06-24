From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:48:55 -0700
Message-ID: <558b41e7.Iuvz0l6NT7sZuQjk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbFXXs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes

WARNING: line over 80 characters
#53: FILE: fs/splice.c:362:
+						GFP_KERNEL & mapping_gfp_mask(mapping));

WARNING: line over 80 characters
#66: FILE: mm/filemap.c:1669:
+						GFP_KERNEL & mapping_gfp_mask(mapping));

total: 0 errors, 2 warnings, 35 lines checked

./patches/mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c  |    2 +-
 mm/filemap.c |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/splice.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes fs/splice.c
--- a/fs/splice.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes
+++ a/fs/splice.c
@@ -359,7 +359,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-						GFP_KERNEL & mapping_gfp_mask(mapping));
+					GFP_KERNEL & mapping_gfp_mask(mapping));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
diff -puN mm/filemap.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes mm/filemap.c
--- a/mm/filemap.c~mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes
+++ a/mm/filemap.c
@@ -1664,9 +1664,8 @@ no_cached_page:
 			error = -ENOMEM;
 			goto out;
 		}
-		error = add_to_page_cache_lru(page, mapping,
-						index,
-						GFP_KERNEL & mapping_gfp_mask(mapping));
+		error = add_to_page_cache_lru(page, mapping, index,
+					GFP_KERNEL & mapping_gfp_mask(mapping));
 		if (error) {
 			page_cache_release(page);
 			if (error == -EEXIST) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths.patch

