From: akpm@linux-foundation.org
Subject: + mm-hwpoison-introduce-idenfity_page_state.patch added to -mm
 tree
Date: Thu, 01 Jun 2017 15:38:13 -0700
Message-ID: <59309755.huc80+w4FMhZUKFt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdFAWiO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 18:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: introduce idenfity_page_state
has been added to the -mm tree.  Its filename is
     mm-hwpoison-introduce-idenfity_page_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-introduce-idenfity_page_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-introduce-idenfity_page_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hwpoison: introduce idenfity_page_state

Factoring duplicate code into a function.

Link: http://lkml.kernel.org/r/1496305019-5493-10-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   57 ++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 32 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-introduce-idenfity_page_state mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-introduce-idenfity_page_state
+++ a/mm/memory-failure.c
@@ -1025,9 +1025,31 @@ static bool hwpoison_user_mappings(struc
 	return unmap_success;
 }
 
-static int memory_failure_hugetlb(unsigned long pfn, int trapno, int flags)
+static int identify_page_state(unsigned long pfn, struct page *p,
+				unsigned long page_flags)
 {
 	struct page_state *ps;
+
+	/*
+	 * The first check uses the current page flags which may not have any
+	 * relevant information. The second check with the saved page flags is
+	 * carried out only if the first check can't determine the page status.
+	 */
+	for (ps = error_states;; ps++)
+		if ((p->flags & ps->mask) == ps->res)
+			break;
+
+	page_flags |= (p->flags & (1UL << PG_dirty));
+
+	if (!ps->mask)
+		for (ps = error_states;; ps++)
+			if ((page_flags & ps->mask) == ps->res)
+				break;
+	return page_action(ps, p, pfn);
+}
+
+static int memory_failure_hugetlb(unsigned long pfn, int trapno, int flags)
+{
 	struct page *p = pfn_to_page(pfn);
 	struct page *head = compound_head(p);
 	int res;
@@ -1077,19 +1099,7 @@ static int memory_failure_hugetlb(unsign
 		goto out;
 	}
 
-	res = -EBUSY;
-
-	for (ps = error_states;; ps++)
-		if ((p->flags & ps->mask) == ps->res)
-			break;
-
-	page_flags |= (p->flags & (1UL << PG_dirty));
-
-	if (!ps->mask)
-		for (ps = error_states;; ps++)
-			if ((page_flags & ps->mask) == ps->res)
-				break;
-	res = page_action(ps, p, pfn);
+	res = identify_page_state(pfn, p, page_flags);
 out:
 	unlock_page(head);
 	return res;
@@ -1115,7 +1125,6 @@ out:
  */
 int memory_failure(unsigned long pfn, int trapno, int flags)
 {
-	struct page_state *ps;
 	struct page *p;
 	struct page *hpage;
 	struct page *orig_head;
@@ -1273,23 +1282,7 @@ int memory_failure(unsigned long pfn, in
 	}
 
 identify_page_state:
-	res = -EBUSY;
-	/*
-	 * The first check uses the current page flags which may not have any
-	 * relevant information. The second check with the saved page flagss is
-	 * carried out only if the first check can't determine the page status.
-	 */
-	for (ps = error_states;; ps++)
-		if ((p->flags & ps->mask) == ps->res)
-			break;
-
-	page_flags |= (p->flags & (1UL << PG_dirty));
