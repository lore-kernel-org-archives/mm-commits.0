Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA8C36BCC2;
	Fri, 29 May 2026 03:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026671; cv=none; b=UkDYmSBHmY1oajhcOvtAYUN6Re44VbSgXODWu1X6Qm755sukhYOOJTr08s1bOvNCWipP1OCFas7ZI0u+rIKWZvOFZ+m/mJrIT/3VXZo9pc54CkPMArZH5kK4tpTlS82Z8r+maPXka/R4x/5Qt+GypEdpafItxV0oTYDOb/Gm1FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026671; c=relaxed/simple;
	bh=9kwYLVMiE3VRiTJCJ/XnuM/QzzZPldTDZZoTgrREAio=;
	h=Date:To:From:Subject:Message-Id; b=tYBQ7Q228KX9sX0iwW96JZkdrGZxnu45uaoKaXXSgs6ZhI709Zo+KMXxKSz+FrWYSi7IcnSMlumCmfjoBZDdKPQuJE59o5RkOmtrWtWC86tRmx+eNGpAujOs2EbjpSfpghsDfTMw/3ghqrhv2CjVwJ4D9cyy+7i0miiZ3gxIXwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nxs2ooIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nxs2ooIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD93A1F00A3A;
	Fri, 29 May 2026 03:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026670;
	bh=SFds/WIxxNJDUgnIchIwXwdj/+vQFDONw2zaKeIMcXI=;
	h=Date:To:From:Subject;
	b=Nxs2ooIfLJ/lOOXMZ4nxTbOvMsDLsQyZNe7nv5jPW44HN48OFR07zI6q/K3rGeeaa
	 EKKb6a7vOHQX3t+HpxZNDnjvAhenT8WXyIu5IF4VS4VscJ3KoIOfcPlhDC5Wv6ikDW
	 NMUK4RZNQBdhUIgnDCyAkDSCjVU3Qo+N49/RcYLI=
Date: Thu, 28 May 2026 20:51:09 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@kernel.org,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,david@kernel.org,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison.patch removed from -mm tree
Message-Id: <20260529035109.DD93A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wupeng Ma <mawupeng1@huawei.com>
Subject: mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison
Date: Fri, 22 May 2026 09:03:05 +0800

Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page can
trigger a recursive spinlock self-deadlock (AA deadlock) on hugetlb_lock
when racing with a concurrent unmap:

  thread#0                              thread#1
  --------                              --------
  madvise(folio, MADV_HWPOISON)
    -> poisons the folio successfully
  madvise(folio, MADV_HWPOISON)         unmap(folio)
    try_memory_failure_hugetlb
      get_huge_page_for_hwpoison
        spin_lock_irq(&hugetlb_lock)    <- held
        __get_huge_page_for_hwpoison
          hugetlb_update_hwpoison()
            -> MF_HUGETLB_FOLIO_PRE_POISONED
          goto out:
            folio_put()
              refcount: 1 -> 0
              free_huge_folio()
                spin_lock_irqsave(&hugetlb_lock)
                  -> AA DEADLOCK!

The out: path in __get_huge_page_for_hwpoison() calls folio_put() to drop
the GUP reference while the hugetlb_lock is still held by the hugetlb.c
wrapper get_huge_page_for_hwpoison().  If concurrent unmap has released
the page table mapping reference, folio_put() drops the folio refcount to
zero, triggering free_huge_folio() which attempts to re-acquire the
non-recursive hugetlb_lock.

Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
folio_put() at the out: label so the folio is always released outside the
lock.

[akpm@linux-foundation.org: fix race, rename label per Miaohe]
  Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
  Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
Link: https://lore.kernel.org/20260522010305.4099834-1-mawupeng1@huawei.com
Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 --------
 include/linux/mm.h      |    8 --------
 mm/hugetlb.c            |   11 -----------
 mm/memory-failure.c     |   19 ++++++++++---------
 4 files changed, 10 insertions(+), 36 deletions(-)

--- a/include/linux/hugetlb.h~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison
+++ a/include/linux/hugetlb.h
@@ -153,8 +153,6 @@ long hugetlb_unreserve_pages(struct inod
 						long freed);
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared);
 void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
@@ -420,12 +418,6 @@ static inline int get_hwpoison_hugetlb_f
 {
 	return 0;
 }
-
-static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
-{
-	return 0;
-}
 
 static inline void folio_putback_hugetlb(struct folio *folio)
 {
--- a/include/linux/mm.h~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison
+++ a/include/linux/mm.h
@@ -4975,8 +4975,6 @@ extern int soft_offline_page(unsigned lo
  */
 extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
-extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
@@ -4984,12 +4982,6 @@ static inline void memory_failure_queue(
 {
 }
 
-static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
-{
-	return 0;
-}
-
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
--- a/mm/hugetlb.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison
+++ a/mm/hugetlb.c
@@ -7161,17 +7161,6 @@ int get_hwpoison_hugetlb_folio(struct fo
 	return ret;
 }
 
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared)
-{
-	int ret;
-
-	spin_lock_irq(&hugetlb_lock);
-	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
-	spin_unlock_irq(&hugetlb_lock);
-	return ret;
-}
-
 /**
  * folio_putback_hugetlb - unisolate a hugetlb folio
  * @folio: the isolated hugetlb folio
--- a/mm/memory-failure.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison
+++ a/mm/memory-failure.c
@@ -1966,20 +1966,19 @@ void folio_clear_hugetlb_hwpoison(struct
 	folio_free_raw_hwp(folio, true);
 }
 
-/*
- * Called from hugetlb code with hugetlb_lock held.
- */
-int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio;
 	bool count_increased = false;
 	int ret, rc;
 
+	spin_lock_irq(&hugetlb_lock);
+	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
-		goto out;
+		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
@@ -1995,13 +1994,13 @@ int __get_huge_page_for_hwpoison(unsigne
 	} else {
 		ret = MF_HUGETLB_RETRY;
 		if (!(flags & MF_NO_RETRY))
-			goto out;
+			goto out_unlock;
 	}
 
 	rc = hugetlb_update_hwpoison(folio, page);
 	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
 		ret = rc;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -2013,8 +2012,10 @@ int __get_huge_page_for_hwpoison(unsigne
 		*migratable_cleared = true;
 	}
 
+	spin_unlock_irq(&hugetlb_lock);
 	return ret;
-out:
+out_unlock:
+	spin_unlock_irq(&hugetlb_lock);
 	if (count_increased)
 		folio_put(folio);
 	return ret;
_

Patches currently in -mm which might be from mawupeng1@huawei.com are


