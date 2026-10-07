Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2130CD81
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334308; cv=none; b=qLWBj0ECOCKRBO4RrwiwHTfZpryhbVAX2n2vYgFFY7kY2Ptiks4kpjdtQBJ1khQZRATM48PVp7FU+hA4ehz+ZF8b8txP+0kLwDGpivUwGFzg7VFfOVThtyCTpoJUE4phOPdXp0tlUbKmJbSSN7/xp15I8hQcMcevd24sO8w/IDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334308; c=relaxed/simple;
	bh=zkoqB6Ep6cT7vEWhv2ReyGl2CfDizRUpRPxPUjQ+Hhg=;
	h=Date:To:From:Subject:Message-Id; b=X1ukskc/eSdKWucnQ6iQf4c9NHjYkLiMas0bCEpQ/NGqgRk4p0N3Cynq/kTu8VNnRxXDz7CUeetwxbgYfzF+sfw2YmltIvb/dfyiOzcP4tde+yf7cdWXaiHTwVpkKxPsntTOJijHuOP+P0SRVFzTlSQCmDoFihZww/Hyq6VJ+Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sjriflrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sjriflrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8171F0089B;
	Wed,  7 Oct 2026 00:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334307;
	bh=FsmQE9CDqWERyu1+9n5ACXjv9dEeXd7heQ51xY01rAE=;
	h=Date:To:From:Subject;
	b=SjriflrfEteHNuWm+HoSGobPVCPzG8B98I339phHY855w7fMkYj+bW4Ejm6OZgxwn
	 pUVBybrvgzU5B3fckgGvZs6gK2iOfdnDjluwOEu4NKnMCuCZC8zS9WGHrMku2TOXGl
	 b6gistaBSWSTSwxjX2a0kWqxN8LsQP+eoC942z/o=
Date: Tue, 06 Oct 2026 17:51:47 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch removed from -mm tree
Message-Id: <20261007005147.9E8171F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: cap demotion at currently available free pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: cap demotion at currently available free pages
Date: Mon, 31 Aug 2026 21:35:19 +0800

Demotion must not remove free huge pages that back existing reservations. 
The sysfs path checks whether any page is available, but passes the entire
request to demote_pool_huge_page().  For example, with two free pages and
one reservation, a request for two pages removes both and leaves the
reservation without a backing page.

Cap the sysfs request by both global availability and the selected node's
free pages.  Recheck global availability in demote_pool_huge_page() before
each node batch because that function drops hugetlb_lock while restoring
vmemmap and reservations can change before the next batch.

Testing:
Tested on an x86_64 QEMU guest booted with:

  hugepagesz=1G hugepages=2

Reserve one 1 GiB huge page with an untouched hugetlbfs mapping:

  nr=2 surplus=0 free=2 resv=1

Request demotion of two pages. Before this fix, both free pages are
demoted:

  nr=0 surplus=0 free=0 resv=1

Touching the reserved mapping then fails with SIGBUS. After this fix, the
request is capped at the single available page:

  nr=1 surplus=0 free=1 resv=1

Touching the reserved mapping succeeds. After the process exits, the
counters are:

  nr=1 surplus=0 free=1 resv=0

Link: https://lore.kernel.org/20260831133519.2505020-3-xialonglong2025@163.com
Fixes: c0f398c3b2cf ("mm/hugetlb_vmemmap: batch HVO work when demoting")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Codex:gpt-5.6-sol
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yu Zhao <yuzhao@google.com>
---

 mm/hugetlb.c       |   22 +++++++++++++++++++++-
 mm/hugetlb_sysfs.c |   10 +++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-cap-demotion-at-currently-available-free-pages
+++ a/mm/hugetlb.c
@@ -4015,6 +4015,26 @@ long demote_pool_huge_page(struct hstate
 		LIST_HEAD(list);
 		LIST_HEAD(surplus_list);
 		struct folio *folio, *next;
+		unsigned long nr_available, nr_target;
+
+		/*
+		 * Re-check available each node batch: the previous
+		 * batch released hugetlb_lock for vmemmap restore/split,
+		 * and a new reservation could have been added in that
+		 * window, shrinking the budget.  available is global
+		 * (resv is not per-node), so 0 means no node can
+		 * contribute -- stop the whole scan.
+		 */
+		nr_available = available_huge_pages(src);
+		if (!nr_available)
+			break;
+
+		/*
+		 * Cap this batch at the current budget; expressed as a
+		 * cumulative stop point because nr_demoted is running.
+		 */
+		nr_target = nr_demoted + min_t(unsigned long,
+				nr_to_demote - nr_demoted, nr_available);
 
 		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
 			bool adjust_surplus;
@@ -4029,7 +4049,7 @@ long demote_pool_huge_page(struct hstate
 			if (!adjust_surplus)
 				nr_persistent++;
 
-			if (++nr_demoted == nr_to_demote)
+			if (++nr_demoted == nr_target)
 				break;
 		}
 
--- a/mm/hugetlb_sysfs.c~mm-hugetlb-cap-demotion-at-currently-available-free-pages
+++ a/mm/hugetlb_sysfs.c
@@ -211,15 +211,15 @@ static ssize_t demote_store(struct kobje
 		 * Check for available pages to demote each time thorough the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
 		 */
+		nr_available = h->free_huge_pages - h->resv_huge_pages;
 		if (nid != NUMA_NO_NODE)
-			nr_available = h->free_huge_pages_node[nid];
-		else
-			nr_available = h->free_huge_pages;
-		nr_available -= h->resv_huge_pages;
+			nr_available = min(nr_available,
+					   h->free_huge_pages_node[nid]);
 		if (!nr_available)
 			break;
 
-		rc = demote_pool_huge_page(h, n_mask, nr_demote);
+		rc = demote_pool_huge_page(h, n_mask,
+					   min(nr_demote, nr_available));
 		if (rc < 0) {
 			err = rc;
 			break;
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-zswap-publish-the-initial-pool-with-list_add_rcu.patch
mm-zswap-enable-zswap_ever_enabled-in-zswap_pool_create.patch

