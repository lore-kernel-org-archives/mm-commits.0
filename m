Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C493515DF
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788225280; cv=none; b=OkN+qvxCYMJog7FjwAbtjU97roW9EGHD7Rnt8RUE9McRNiIg7UUrQxJFPMJN0CB2uQLlsmjuKyWFhpM/4ZeIPpvBD2xweqWf7EGXSZMXgjTH5pGL0A2VjAK+IvMzbLLJ9Kz2xkXCP8MziOfSx7SjIffPowHhrXBDpRMiuRJPEIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788225280; c=relaxed/simple;
	bh=zqvxOgiTr3F5SHooTCGKL2UYfiV1aFQDoD6a6lL5XsE=;
	h=Date:To:From:Subject:Message-Id; b=V0xmpmbwdw449VdXLgmlKH7BsxQeT/hce9SD0/L8B1DVO7s2RXQDZlmd1ZseI1mppCXprPPad2ifc00luOGT5mCru1MnbfgOw3TP3glmnhg2Zobp4zLfLxUQrxkpn7wwnTlIbVdST5axjnbjb9iTz4SkxcMTIai2FKJHXq6iDoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R9owvFAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R9owvFAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85BC1F00A3D;
	Tue,  1 Sep 2026 01:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788225278;
	bh=K3grduaGRtIVVTaVyPjEkY0H61aThuQ5whKTpmEwIvM=;
	h=Date:To:From:Subject;
	b=R9owvFApUxa/XH9Kn+rG19xtc/pdhCkvuxg7FY+gydvshzm9qUBnKE/tB+ciQ0uDK
	 NH5KGqikZj9GjTzMUMiXaN6BXeSrIdA8kLKk6dTwD9vPrNx3B0cJIWMiSmpjih/v8c
	 AVl+hT+y7k0l+ytspjAfkFV0tmqCoUJOELmMKQ0E=
Date: Mon, 31 Aug 2026 18:14:37 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch added to mm-new branch
Message-Id: <20260901011437.D85BC1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: cap demotion at currently available free pages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Assisted-by: Codex:gpt-5.6-sol
Cc: David Hildenbrand <david@kernel.org>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c       |   22 +++++++++++++++++++++-
 mm/hugetlb_sysfs.c |   10 +++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-cap-demotion-at-currently-available-free-pages
+++ a/mm/hugetlb.c
@@ -4014,6 +4014,26 @@ long demote_pool_huge_page(struct hstate
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
@@ -4028,7 +4048,7 @@ long demote_pool_huge_page(struct hstate
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

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch

