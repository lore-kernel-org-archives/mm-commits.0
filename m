From: akpm@linux-foundation.org
Subject: + readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:06 -0700
Message-ID: <200904102339.n3ANd6wR021102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824AbZDJXls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     readahead: move max_sane_readahead() calls into force_page_cache_readahead()
has been added to the -mm tree.  Its filename is
     readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1389,8 +1389,7 @@ do_readahead(struct address_space *mappi
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

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch

