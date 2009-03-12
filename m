From: akpm@linux-foundation.org
Subject: + nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch added to -mm tree
Date: Wed, 11 Mar 2009 17:13:03 -0700
Message-ID: <200903120013.n2C0D4wc020944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbZCLAP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 20:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, dhowells@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     nommu: ramfs: don't leak pages when adding to page cache fails
has been added to the -mm tree.  Its filename is
     nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch

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
Subject: nommu: ramfs: don't leak pages when adding to page cache fails
From: Johannes Weiner <hannes@cmpxchg.org>

When a ramfs nommu mapping is expanded, contiguous pages are allocated
and added to the pagecache.  The caller's reference is then passed on
by moving whole pagevecs to the file lru list.

If the page cache adding fails, make sure that the error path also
moves the pagevec contents which might still contain up to PAGEVEC_SIZE
successfully added pages, of which we would leak references otherwise.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Enrik Berkhan <Enrik.Berkhan@ge.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ramfs/file-nommu.c~nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails
+++ a/fs/ramfs/file-nommu.c
@@ -128,6 +128,7 @@ int ramfs_nommu_expand_for_mapping(struc
 	return -EFBIG;
 
  add_error:
+	pagevec_lru_add_file(&lru_pvec);
 	page_cache_release(pages + loop);
 	for (loop++; loop < npages; loop++)
 		__free_page(pages + loop);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch
nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded-fix.patch
nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

