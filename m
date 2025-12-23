Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2001E5B68;
	Tue, 23 Dec 2025 02:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766456460; cv=none; b=L1JQkyXbgRPuP9r2bj2GQPfKNdHHfH8SmDl0ORwuJN0qLMk0E1ZS+oG2AFVnsMFCs3ZGQY7hqL15Cw3S9ARDkYDOD4mhU+TTjbO5zkvN5dhrpgJ1BBX/zmjd6lKulGEG1ddNHbKNie2SxycJb6evEP5oY5z6fld4gxKjHJG0tS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766456460; c=relaxed/simple;
	bh=HxYTNp4b3EgnqJHp3BntACMblvmD9mJxKzq/dTKbw98=;
	h=Date:To:From:Subject:Message-Id; b=bnFc8Ct2brn3Ws5SaNNLDHkM1znbJrQF9azjIzY2x/yUW3Ldonv26vkJip3OBIuUAXomaUaMsvlPbUO772lAayTc0fE+hLuIPogNIDa45Lg29G/7miCLAZHyUUKgFRTw13XSDkcU3DoS3Xur42CUhAII9532Sgsw5TYtEcg9NEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XygIov2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XygIov2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117AFC4CEF1;
	Tue, 23 Dec 2025 02:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766456460;
	bh=HxYTNp4b3EgnqJHp3BntACMblvmD9mJxKzq/dTKbw98=;
	h=Date:To:From:Subject:From;
	b=XygIov2SfZpI7Y+FZzs1lkFvHXji5DJaj4YFuvRXIvftROizkusr5EaLHlzYHEAJc
	 c/xRJl6rwKT97Fs/hmbKUunSx5aTOlef/bEwYfdUOQwKxcwrXUY2UGG/bJoEEzT2vB
	 NLpl/7fq+7MMCX/wqHEAtfYCEOtKVLTAJNDZTegM=
Date: Mon, 22 Dec 2025 18:20:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,william.roche@oracle.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rientjes@google.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@oracle.com,jiaqiyan@google.com,david@kernel.org,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch added to mm-hotfixes-unstable branch
Message-Id: <20251223022100.117AFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Mon, 22 Dec 2025 18:21:11 -0700

When a newly poisoned subpage ends up in an already poisoned hugetlb
folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats is
not.  Fix the inconsistency by designating action_result() to update them
both.

While at it, define __get_huge_page_for_hwpoison() return values in terms
of symbol names for better readibility.  Also rename
folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
function does more than the conventional bit setting and the fact three
possible return values are expected.

Link: https://lkml.kernel.org/r/20251223012113.370674-1-jane.chu@oracle.com
Fixes: 18f41fa616ee ("mm: memory-failure: bump memory failure stats to pglist_data")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: William Roche <william.roche@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   56 ++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison
+++ a/mm/memory-failure.c
@@ -1883,12 +1883,18 @@ static unsigned long __folio_free_raw_hw
 	return count;
 }
 
-static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
+#define	MF_HUGETLB_ALREADY_POISONED	3  /* already poisoned */
+#define	MF_HUGETLB_ACC_EXISTING_POISON	4  /* accessed existing poisoned page */
+/*
+ * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
+ * to keep track of the poisoned pages.
+ */
+static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
+	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_ALREADY_POISONED : 0;
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
@@ -1896,20 +1902,18 @@ static int folio_set_hugetlb_hwpoison(st
 	 * so skip to add additional raw error info.
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
-		return -EHWPOISON;
+		return MF_HUGETLB_ALREADY_POISONED;
+
 	head = raw_hwp_list_head(folio);
 	llist_for_each_entry(p, head->first, node) {
 		if (p->page == page)
-			return -EHWPOISON;
+			return MF_HUGETLB_ACC_EXISTING_POISON;
 	}
 
 	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
 	if (raw_hwp) {
 		raw_hwp->page = page;
 		llist_add(&raw_hwp->node, head);
-		/* the first error event will be counted in action_result(). */
-		if (ret)
-			num_poisoned_pages_inc(page_to_pfn(page));
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -1955,32 +1959,30 @@ void folio_clear_hugetlb_hwpoison(struct
 	folio_free_raw_hwp(folio, true);
 }
 
+#define	MF_HUGETLB_FREED			0	/* freed hugepage */
+#define	MF_HUGETLB_IN_USED			1	/* in-use hugepage */
+#define	MF_NOT_HUGETLB				2	/* not a hugepage */
+
 /*
  * Called from hugetlb code with hugetlb_lock held.
- *
- * Return values:
- *   0             - free hugepage
- *   1             - in-use hugepage
- *   2             - not a hugepage
- *   -EBUSY        - the hugepage is busy (try to retry)
- *   -EHWPOISON    - the hugepage is already hwpoisoned
  */
 int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
 	struct folio *folio = page_folio(page);
-	int ret = 2;	/* fallback to normal page handling */
+	int ret = MF_NOT_HUGETLB;
 	bool count_increased = false;
+	int rc;
 
 	if (!folio_test_hugetlb(folio))
 		goto out;
 
 	if (flags & MF_COUNT_INCREASED) {
-		ret = 1;
+		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
 	} else if (folio_test_hugetlb_freed(folio)) {
-		ret = 0;
+		ret = MF_HUGETLB_FREED;
 	} else if (folio_test_hugetlb_migratable(folio)) {
 		ret = folio_try_get(folio);
 		if (ret)
@@ -1991,8 +1993,9 @@ int __get_huge_page_for_hwpoison(unsigne
 			goto out;
 	}
 
-	if (folio_set_hugetlb_hwpoison(folio, page)) {
-		ret = -EHWPOISON;
+	rc = hugetlb_update_hwpoison(folio, page);
+	if (rc >= MF_HUGETLB_ALREADY_POISONED) {
+		ret = rc;
 		goto out;
 	}
 
@@ -2029,22 +2032,29 @@ static int try_memory_failure_hugetlb(un
 	*hugetlb = 1;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
-	if (res == 2) { /* fallback to normal page handling */
+	switch (res) {
+	case MF_NOT_HUGETLB:	/* fallback to normal page handling */
 		*hugetlb = 0;
 		return 0;
-	} else if (res == -EHWPOISON) {
+	case MF_HUGETLB_ALREADY_POISONED:
+	case MF_HUGETLB_ACC_EXISTING_POISON:
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
 		}
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		if (res == MF_HUGETLB_ALREADY_POISONED)
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		else
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
 		return res;
-	} else if (res == -EBUSY) {
+	case -EBUSY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
 		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+	default:
+		break;
 	}
 
 	folio = page_folio(p);
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-fix-missing-mf_stats-count-in-hugetlb-poison.patch
mm-memory-failure-teach-kill_accessing_process-to-accept-hugetlb-tail-page-pfn.patch

