Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F8119F40B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085351; cv=none; b=qkmztvRVRCqdNbpcg546gTI1r+yhE1bAgSANddzX+Yoo3hnNo/BTfC8JuM61y1sdCry1PS2NLyiTKSci3MVe7dUw7u8S772tzrllDOFOhiOxG5Iw5RYoRL9tpl8CcaO4DfmKWUqumuoHIMJOnNeRYP9qauFWv8XrraZFxlOk6gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085351; c=relaxed/simple;
	bh=B6LcgU9w7RU+VcLrK4nfgxtCQ/+eaEl3f5cNJ4JP8eU=;
	h=Date:To:From:Subject:Message-Id; b=ahWG8f01QuCkl6juWnZ5VeQsB5Ra4uMJrDyewklMwe6jyjFgLgUootlXEKe7dCcofGw0WU1A3n2fd2Kqdy94TKd/KcxLKtM8wzYTJmI/f/SV91LxqRrOT5Wws5PYcMCKlOCtL0N1O/6FdLUeN27bws6MChx0EKVEyAQJ3Gd9PcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXVkjNp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXVkjNp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C47DC4CEF0;
	Sun, 28 Sep 2025 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085351;
	bh=B6LcgU9w7RU+VcLrK4nfgxtCQ/+eaEl3f5cNJ4JP8eU=;
	h=Date:To:From:Subject:From;
	b=qXVkjNp28oeiqyHuqOWOrQDMdmqXnRW3+/CUKogQDqZ6r3O1ORYWxgmn4omzFnA0V
	 f6a8TJnfe2WRPW3rcrex0Ys2UyFduXphrKuMvVcnVWYzxU4K4VC3JcmrmVDVxOBIj7
	 sUKAAecpqscKkPfMGREivRhpbAxZZmE9MhtGFaFo=
Date: Sun, 28 Sep 2025 11:49:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch removed from -mm tree
Message-Id: <20250928184911.2C47DC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch

This patch was dropped because it was folded into mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix
Date: Mon, 22 Sep 2025 00:28:34 +0000

fix use-after-free crash

Link: https://lkml.kernel.org/r/20250922002834.vz6ntj36e75ehkyp@master
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Debugged-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix
+++ a/mm/khugepaged.c
@@ -2508,8 +2508,7 @@ breakouterloop_mmap_lock:
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			slot = list_next_entry(slot, mm_node);
-			khugepaged_scan.mm_slot = slot;
+			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-use-start_addr-addr-for-better-reading.patch

