Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832481;
	b=MQGOdVi058k9OtBMEYGrsULAbeovOkrWsKMiFm9G8prv8jIzriwbUs1WTj4n1BRSsG+f
	 02aZuJ0ruxvKpAACY5Mt5sG25KKVEf60dM8nr01n5Sdwt+XkuEhbH4ltwAszrT6GQnFCS
	 NHxaLOu30wjj1EWG1y6zLjiB4zV2UrbPR9m2JKujn8Jh+b1tMYBiRN7ZUv5XIZySJEhif
	 sWV29iWcnfDr9wkjHS/DkBSZLC23KVs/9PphPvPz7Mc8Tz6JQXQLC+vlja1/DtuVylbQY
	 500eknW6c6RqKDgn1yPutDkNFHkUnvtUoC/q/LS6GSb+DKv34cav/59hWOMod08VBMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832481;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/3LGqwtM9tichxV60uyZ5vKU6RBZlXEm8Item0J0sTc=;
	b=dyLyYCOLvmfvXI4cg6j+HsGK8S0BwCQ4t3GO8QhdUXJYweWcD4k/L5712hm+gFhnedqp
	 rBcfA3+rui5KZFc4s3uRiJS+SeRviAAqu6bFdhR9sltVhbecTakaLq9jXcu2yJ+UtuCIb
	 YgpwmzyjPJVj1uGbmU8+oIfabjplwRusdejxuBoIdSS5Mp+sbaWHeSlq8R9+928u8wvYc
	 hNu/gBd/ZU9+pdLXcKMIgZlGZYAFYGfvyoSKc2s4pRzVSJz8qvu1RFiVOx3tX+nlWjQP8
	 r78sG0I9i3ohVH1QxnA6NhqIcGejVHS+fuWLRpCf4NvFQp01Pu2zZPtsAXYEf+cl30w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ocPao7u3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C5A606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ocPao7u3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C56C1F01825;
	Sat, 24 Oct 2026 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832481;
	bh=/3LGqwtM9tichxV60uyZ5vKU6RBZlXEm8Item0J0sTc=;
	h=Date:To:From:Subject;
	b=ocPao7u3OGJSPJ6iD1Bbafk9Zx2Dds79zc4zIfUABBOZ7py0SpJq3LH9Y2In23oVP
	 TzQvRy5BQVL2oDSplLZHOiq2l2KwSfI79UujHdES9ODeYNCy51dnr9E/dBphJ2RIrW
	 TrSI5mrdyx0TrqAIUKPJTVBHFSooWBdrgamsckHw=
Date: Sat, 24 Oct 2026 02:01:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch removed from -mm tree
Message-Id: <20261024090121.5C56C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: count collapses where khugepaged makes them
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: count collapses where khugepaged makes them
Date: Wed, 14 Oct 2026 18:11:35 +0100

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Link: https://lore.kernel.org/20261014171145.3292736-3-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-count-collapses-where-khugepaged-makes-them
+++ a/mm/khugepaged.c
@@ -2841,10 +2841,8 @@ static enum scan_result collapse_single_
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2880,9 +2878,6 @@ retry:
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2959,6 +2954,8 @@ static void collapse_scan_mm_slot(unsign
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
_

Patches currently in -mm which might be from kas@kernel.org are


