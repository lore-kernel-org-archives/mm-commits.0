Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832243;
	b=qjIyKqlOg3Co93YeQt3kopEx7p8v/hnmgERmOW7YUcJMM0+DXmcvpkONkWtwbPr8gRlP
	 AglmWpodiwNHgrdP2c8KSN2s/a89CH79tCDQAqcoy7Z1oZ5RvHqFaX1TfuOMyU4TSwxKZ
	 +C1g5jCLUixIsWp9rfU6jOrDPLIW2ImzivQ4GrxccY68IQNm+CFuMo70NAiSbi/3m74/q
	 z9XmRs8r8pORVzbMeOuz0RRmSYLIMfhGgxdwHSqQdkEoVRfCLK3q2jiAYJoAS881feJ0D
	 FHPI0s8x+NBvDecq4A3Zu8yT1R76PMH8bo1oRMnyJdTgIYJidg2+BtSCOjiyfttUZiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832243;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=C7cAm1Lw6ANPQZaqPPZBrYmTu2y2HMuQFhXKFMLw2tk=;
	b=d+UmAYjmHFDQZaheFvRaajK2oNnLQZshbHJ0wqEqfDb5GgEqdu1ZGFfZQQc9XXd0czky
	 Eug5x3yKWP9g9YI62OzdcAguYfvzkaDz5UIt4EzhI8pd7efXPlz1S6ui2FxZI9QS40LH1
	 uyRLEhxz5iJ2sqbp6m3yC8XnLotRtHfvr+p1NIv69I+ZgFHEhUKBbQfxAw0rz+xeOxbGS
	 Hlc+7k9z13bYcb3IOpEvomc3tsNd5CqpEOrPrO8kyz0cX/nxWDet8fTGdrqDIbwFNjNAA
	 eCi2UzEARclOfpgcxzBaEvoR9/MfnH15Si6xvNSegfCwVcqsVdJ+PUWVEodPtHzQBOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ohnqDKq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A9E606A321;
	Sat, 24 Oct 2026 08:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ohnqDKq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD3C1F01825;
	Sat, 24 Oct 2026 08:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832242;
	bh=C7cAm1Lw6ANPQZaqPPZBrYmTu2y2HMuQFhXKFMLw2tk=;
	h=Date:To:From:Subject;
	b=ohnqDKq4zx/yLIRp/kYacLm3FRJxuYw0qd9ZFlbFJHvu0+7MimeHk7gGOfD1wIHuf
	 I0duRaYWcaYHyxvbIW/Rhi7QECGk0C6iOLcx84gwboxyv4ycJcMv6KbDGqDdP8s3TP
	 rJBu92id/s7MImHB9QPIA2rUixuqqFLWG6gBt7a8=
Date: Sat, 24 Oct 2026 01:57:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch removed from -mm tree
Message-Id: <20261024085722.ABD3C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Thu, 15 Oct 2026 18:07:09 +0200

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte
+++ a/mm/hugetlb.c
@@ -6520,11 +6520,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

