Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794883763;
	b=GxRFwlhErgW8hANZF+O/XjUBUcDP7uDffTOHnlMB33s76w84nr67b9A1MdbLdRIYdbl7
	 hH8fCY7kwm6rcbM7O0txQsNbeR4ZnNh0lt+zlZx4uwArC4cUN1dMIYgRcvBnBPcjFxwiC
	 KjXsCqyenSENN5xvfsF/NJ9gZdZR3aQm6t80ErXTTlt4TqjtjMrtVO3+02qcoUOJ9gbkb
	 4Rxo0BU9mODoJBRkVen9iRh50XFMOAXd6QFg9BfJY71C4uU53Tk0jnpyYtoIaN04I4SK0
	 sM8ga4we0ROLUglPHJuACZwbj8PY6ebUYayBZBnZABhAH0HRVRbUPdfwhxEdq5hwhSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794883763;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=sPIXzNGJW1yjxRREZXD3C+0RQaEf1d0X/ZaG9IAYYF4=;
	b=A9k3HjoL69HYU7iFgFtZiGis3dxX5piIGyGlv4JRu8H23y2FtjrgXFHqpmDsnZ1Q3yBx
	 2EXXxhWb9xp0CnEsPLfaEXiT8wc9RgvVBeR9LwXEZrCJlDd3iP08SSsgVsfYaoGEsSLOC
	 R5LcJt6S5rOQI3zVtFtbWVpmggUODUR1r9MRm5kt7mjFYSr+ywuYC4rd5DAIpgPhakxKY
	 /7Yu+9ptlrM3nO8nXtR+iCaH0tQ24Wu8H2+FAKk4/fLwhEh8DFcCfehT4NhuH1x8Ip61T
	 GA4ULev6yzpN1a7CeHmfs5TKEgyCgjHgzgescrAJgxNLnmC7tX3SVFPspuWnpN0b5gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GJR3HUk2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EBD606A329
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GJR3HUk2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4F81F000C4;
	Tue, 17 Nov 2026 02:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794883762;
	bh=sPIXzNGJW1yjxRREZXD3C+0RQaEf1d0X/ZaG9IAYYF4=;
	h=Date:To:From:Subject;
	b=GJR3HUk27FbItT1Z2KPrYbccNhKMdKJJb63uEYKKaYG3wVyyQyppo3c3XfNt9dAjp
	 XVBOYKPsoocH0Gq0Y+CItvBgLN/W0SVK6Ou+CAndN0BxI8AhnZ6JOMMXfJyULFbmjy
	 QO9ef4j+J1eZzK40ap/1jzFtpkcwap1T1+ftQPcc=
Date: Mon, 16 Nov 2026 18:49:22 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shivankg@amd.com,shao.mingyin@zte.com.cn,rppt@kernel.org,mhocko@suse.com,
	luizcap@redhat.com,luiz.capitulino@linux.dev,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-fix-retry-detection-and-handling-in-snapshot_page.patch added to mm-new branch
Message-Id: <20261117024922.BF4F81F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/util: fix retry detection and handling in snapshot_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-util-fix-retry-detection-and-handling-in-snapshot_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-fix-retry-detection-and-handling-in-snapshot_page.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/util: fix retry detection and handling in snapshot_page()
Date: Mon, 16 Nov 2026 15:12:13 +0100

snapshot_page() detects races with concurrent folio split+construction by
checking whether the given page still falls into the folio. Unfortunately,
we have an off-by-one error in there, and we should be checking for
"ps->idx >= nr_pages", because idx 0 is valid.

For example, we might currently report a tail page at idx 1 as faithful,
although the snapshotted folio is now a small folio.

However, there is one complication: As we don't hold a folio reference,
folio_nr_pages() can return 0 on races (or when called from page freeing
code). Handle that by just setting it to 1 in that case, so we don't
wrongly report a head page as "page does not match folio".

In addition, we should reset ps->flags when retrying, by just resetting
it to PAGE_SNAPSHOT_FAITHFUL. Otherwise, PAGE_SNAPSHOT_PG_BUDDY and
PAGE_SNAPSHOT_PG_IDLE from a failed attempt could stick around.

These races are fairly rare, so this is not really critical, we simply
report something slightly wrong. No need to CC stable.

Link: https://lore.kernel.org/20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org
Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Closes: https://lore.kernel.org/r/20261115004657890Pz8ERDf5nCtE-B6M7KFzu@zte.com.cn
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>

 mm/util.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/util.c~mm-util-fix-retry-detection-and-handling-in-snapshot_page
+++ a/mm/util.c
@@ -1406,9 +1406,9 @@ void snapshot_page(struct page_snapshot
 	int loops = 5;
 
 	ps->pfn = page_to_pfn(page);
-	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 
 again:
+	ps->flags = PAGE_SNAPSHOT_FAITHFUL;
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
 	info = ps->page_snapshot.compound_info;
@@ -1437,14 +1437,15 @@ again:
 
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
-		nr_pages = folio_nr_pages(&ps->folio_snapshot);
+		/* On races, or when freeing pages, we can read 0. */
+		nr_pages = folio_nr_pages(&ps->folio_snapshot) ?: 1;
 		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
 	}
 
-	if (ps->idx > nr_pages) {
+	if (ps->idx >= nr_pages) {
 		if (loops-- > 0)
 			goto again;
 		clear_compound_head(&ps->page_snapshot);
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-util-fix-retry-detection-and-handling-in-snapshot_page.patch
hugetlbfs-fix-integer-overflow-in-fallocate.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-fix-mremap-racing-with-page-migration.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch

