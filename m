From: akpm@linux-foundation.org
Subject: + memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch added to -mm tree
Date: Mon, 07 Feb 2011 23:07:49 -0800
Message-ID: <201102080707.p1877nwb020218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108Ab1BHHIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 02:08:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, randy.dunlap@oracle.com


The patch titled
     memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix
has been added to the -mm tree.  Its filename is
     memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch

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
Subject: memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix
From: Johannes Weiner <hannes@cmpxchg.org>

include/linux/page_cgroup.h:144: warning: left shift count >= width of type
include/linux/page_cgroup.h:145: warning: left shift count >= width of type
include/linux/page_cgroup.h:150: warning: right shift count >= width of type

Since the non-flags field for pc array ids in pc->flags is offset from the
end of the word, we end up with a shift count of BITS_PER_LONG in case the
field width is zero.

This results in a compiler warning as we shift in both directions a long
int by BITS_PER_LONG.

There is no real harm -- the mask is zero -- but fix up the compiler
warning by also making the shift count zero for a non-existant field.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix
+++ a/include/linux/page_cgroup.h
@@ -123,31 +123,36 @@ static inline void move_unlock_page_cgro
 }
 
 #ifdef CONFIG_SPARSEMEM
-#define PCG_ARRAYID_SHIFT	SECTIONS_SHIFT
+#define PCG_ARRAYID_WIDTH	SECTIONS_SHIFT
 #else
-#define PCG_ARRAYID_SHIFT	NODES_SHIFT
+#define PCG_ARRAYID_WIDTH	NODES_SHIFT
 #endif
 
-#if (PCG_ARRAYID_SHIFT > BITS_PER_LONG - NR_PCG_FLAGS)
+#if (PCG_ARRAYID_WIDTH > BITS_PER_LONG - NR_PCG_FLAGS)
 #error Not enough space left in pc->flags to store page_cgroup array IDs
 #endif
 
 /* pc->flags: ARRAY-ID | FLAGS */
 
-#define PCG_ARRAYID_MASK	((1UL << PCG_ARRAYID_SHIFT) - 1)
+#define PCG_ARRAYID_MASK	((1UL << PCG_ARRAYID_WIDTH) - 1)
 
-#define PCG_ARRAYID_OFFSET	(sizeof(unsigned long) * 8 - PCG_ARRAYID_SHIFT)
+#define PCG_ARRAYID_OFFSET	(BITS_PER_LONG - PCG_ARRAYID_WIDTH)
+/*
+ * Zero the shift count for non-existant fields, to prevent compiler
+ * warnings and ensure references are optimized away.
+ */
+#define PCG_ARRAYID_SHIFT	(PCG_ARRAYID_OFFSET * (PCG_ARRAYID_WIDTH != 0))
 
 static inline void set_page_cgroup_array_id(struct page_cgroup *pc,
 					    unsigned long id)
 {
-	pc->flags &= ~(PCG_ARRAYID_MASK << PCG_ARRAYID_OFFSET);
-	pc->flags |= (id & PCG_ARRAYID_MASK) << PCG_ARRAYID_OFFSET;
+	pc->flags &= ~(PCG_ARRAYID_MASK << PCG_ARRAYID_SHIFT);
+	pc->flags |= (id & PCG_ARRAYID_MASK) << PCG_ARRAYID_SHIFT;
 }
 
 static inline unsigned long page_cgroup_array_id(struct page_cgroup *pc)
 {
-	return (pc->flags >> PCG_ARRAYID_OFFSET) & PCG_ARRAYID_MASK;
+	return (pc->flags >> PCG_ARRAYID_SHIFT) & PCG_ARRAYID_MASK;
 }
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

