From: akpm@linux-foundation.org
Subject: + mm-speculative-page-references-hugh-fix3.patch added to -mm tree
Date: Wed, 11 Jun 2008 10:52:57 -0700
Message-ID: <200806111752.m5BHqvO5009769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758010AbYFKRxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 13:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, clameter@sgi.com


The patch titled
     mm-speculative-page-references-hugh-fix3
has been added to the -mm tree.  Its filename is
     mm-speculative-page-references-hugh-fix3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-speculative-page-references-hugh-fix3
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix the VM_BUG_ON assertion check to actually do what I want, noted by
Christoph.

Also, fix an error-path-leak type issue with frozen refcount not being
unfrozen.  Found by review.  In practice, this check is very rare to
hit because a page dirtier is likely to hold the refcount elevated for
much longer than it takes to check and non-racy-recheck.  So it doesn't
pose a big problem for users of -mm, but of course needs fixing.

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 mm/vmscan.c             |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-speculative-page-references-hugh-fix3 include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-speculative-page-references-hugh-fix3
+++ a/include/linux/pagemap.h
@@ -137,7 +137,7 @@ static inline int page_cache_get_specula
 		return 0;
 	}
 #endif
-	VM_BUG_ON(PageCompound(page) && (struct page *)page_private(page) != page);
+	VM_BUG_ON(PageTail(page));
 
 	return 1;
 }
diff -puN mm/vmscan.c~mm-speculative-page-references-hugh-fix3 mm/vmscan.c
--- a/mm/vmscan.c~mm-speculative-page-references-hugh-fix3
+++ a/mm/vmscan.c
@@ -428,8 +428,10 @@ static int __remove_mapping(struct addre
 	if (!page_freeze_refs(page, 2))
 		goto cannot_free;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
-	if (unlikely(PageDirty(page)))
+	if (unlikely(PageDirty(page))) {
+		page_unfreeze_refs(page, 2);
 		goto cannot_free;
+	}
 
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

git-unionfs.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
generic_file_aio_read-cleanups.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-hugh-fix3.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

