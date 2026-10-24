Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832252;
	b=XN+LyyimAUIa0NTwkrO5G8xc8yAKbh70kHJQIo4eEcE954bCgVGJxw1piNnHIA2WdrNZ
	 5V+Cn35YuhXOfdH+GIke9ZT4aNmRLw5AyROkZs+5fSjdF9Fs+KzSvlpAk7viyzYf8CFSQ
	 opqBVnooVv5rdp7gXXtBO7KL7ZWX6dIYLsUyrZztGu6gxQHnTqGiaYJR8QpP6dk+ukOOX
	 +Hg5yJE9KmjC0nlivCzuY7uU91JhA57dVOSM+ZrEj46Za1zelMfBgSfHedO+OrvuldYJm
	 lyS1mdB674Ryf+jO+7ovfvjG+/SxgLMuPfcWi0toUeNahfpGHecVLXoKz58opsnAu2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832252;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=N4P1wRsPk6z03CGu1uFIKWHcd8WO6NAOx2OypwL4Z1A=;
	b=2uHxWws61zQ/imxQiBURfAC4HclbUhsEbaJ+xr34QGZKyA3DVmuHGmDrbfV9HHmRlsoe
	 XSc9MQGi9hHaD4LrRYGJIMBaHE7biKVR9qi/qeEbSvvhH22dlVOszDv2mP5YhYedf5Ofc
	 3nnqkkteLLpQvmi4Ea9U6GZwnQRUzc/zxqKxI7NFeSCpAifJnsPa5vCsUsqJ4mWzrU5B5
	 02DQv6we+/Tqt6tBrEUkWspHR/fe0a120pCF8NfMraN7rSq9gthrnlr1agD8eDrJpTe13
	 Un7ZaxPryC/+GnuM0ff2YGbwHIWJM0JnZLWOOk2zLxAeZerKS8MdFG4pSgvSsT51Kgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="fXVa2Q4/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB40606A324;
	Sat, 24 Oct 2026 08:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fXVa2Q4/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC801F01825;
	Sat, 24 Oct 2026 08:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832251;
	bh=N4P1wRsPk6z03CGu1uFIKWHcd8WO6NAOx2OypwL4Z1A=;
	h=Date:To:From:Subject;
	b=fXVa2Q4/my5jd+yXF1i9t8x7PrSW3TxxKenRk7Dndj0exomMDPLUPpZsTqrET2Yxg
	 xtq5+ByWx2ZU82lI7Zwo10YWbQQPE1lOxY8A5zZlqSRx7Qp0UURtzHywOuGoP4VOPA
	 c1BPiivDbHoAPvuD7tDeEIoZPWMUyc4GvakD46+4=
Date: Sat, 24 Oct 2026 01:57:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch removed from -mm tree
Message-Id: <20261024085731.8AC801F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
Date: Thu, 15 Oct 2026 18:07:14 +0200

UFFD PTE bit handling is a bit like swiss cheese, in particular with
recently added RWP mode. Having uffd-wp markers outside uffd-wp VMAs
already confused this code in the past and resulted in uffd-pte bits
confusing other code later.

Let's play safe and just ignore these markers in hugetlb_no_page(), not
silently propagating the uffd-wp PTE bit.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-8-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
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

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas
+++ a/mm/hugetlb.c
@@ -5981,8 +5981,11 @@ static vm_fault_t hugetlb_no_page(struct
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
+	 *
+	 * TODO: fix all cases where uffd-wp markers remain in VMAs that are no
+	 * longer registered with uffd.
 	 */
-	if (unlikely(pte_is_uffd_wp_marker(vmf->orig_pte)))
+	if (unlikely(userfaultfd_wp(vma) && pte_is_uffd_wp_marker(vmf->orig_pte)))
 		new_pte = huge_pte_mkuffd(new_pte);
 	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

