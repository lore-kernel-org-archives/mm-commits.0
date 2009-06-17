From: akpm@linux-foundation.org
Subject: [merged] readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:32 -0700
Message-ID: <200906171832.n5HIWWk1031123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357AbZFQScl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: move max_sane_readahead() calls into force_page_cache_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: move max_sane_readahead() calls into force_page_cache_readahead()
From: Wu Fengguang <fengguang.wu@intel.com>

Impact: code simplification.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c   |    2 +-
 mm/filemap.c   |    3 +--
 mm/madvise.c   |    3 +--
 mm/readahead.c |    1 +
 4 files changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/fadvise.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead mm/fadvise.c
--- a/mm/fadvise.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead
+++ a/mm/fadvise.c
@@ -101,7 +101,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		
 		ret = force_page_cache_readahead(mapping, file,
 				start_index,
-				max_sane_readahead(nrpages));
+				nrpages);
 		if (ret > 0)
 			ret = 0;
 		break;
diff -puN mm/filemap.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead mm/filemap.c
--- a/mm/filemap.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead
+++ a/mm/filemap.c
@@ -1390,8 +1390,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index,
-					max_sane_readahead(nr));
+	force_page_cache_readahead(mapping, filp, index, nr);
 	return 0;
 }
 
diff -puN mm/madvise.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead mm/madvise.c
--- a/mm/madvise.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead
+++ a/mm/madvise.c
@@ -123,8 +123,7 @@ static long madvise_willneed(struct vm_a
 		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-	force_page_cache_readahead(file->f_mapping,
-			file, start, max_sane_readahead(end - start));
+	force_page_cache_readahead(file->f_mapping, file, start, end - start);
 	return 0;
 }
 
diff -puN mm/readahead.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead
+++ a/mm/readahead.c
@@ -210,6 +210,7 @@ int force_page_cache_readahead(struct ad
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
+	nr_to_read = max_sane_readahead(nr_to_read);
 	while (nr_to_read) {
 		int err;
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

