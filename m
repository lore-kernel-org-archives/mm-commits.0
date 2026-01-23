Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7AC19C553
	for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769182277; cv=none; b=sDNgJZgA8NB3vTkszJcpg9bqYjpx6gXdHQADxmUO1EpmPHT/cUZ3bvZgAoTG3evPn0ump7iYzBaj31vFwbd6NsT221RkE8D4Ku3x44BuwHY6twcCkaRupOw1VDDGihNIUyBxM5Jf8z0qYqIGK8t/AImkRqDYPYS7KhcVr9AjQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769182277; c=relaxed/simple;
	bh=Ni5hpBHguiLn97XS5C9+m86K9Cn2gG94DcanBwWRLes=;
	h=Date:To:From:Subject:Message-Id; b=g73zq/EVSQ8xNzfB/uM9c9seduLZd0lp9ffebbEPZ0d7/IMm0W0w4dp/zlKVJYy74va27Eh3s/4X6thS59IAYN1QV3wn4IVzVn/LvYI1nWfhpJ0mwNaEhmSnqbX8E+xLqo+b6MRvdETQTyE0SOVZmK00SQM8WxwH6vLw0ofCj+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zbabnv6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zbabnv6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C3EC4CEF1;
	Fri, 23 Jan 2026 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769182276;
	bh=Ni5hpBHguiLn97XS5C9+m86K9Cn2gG94DcanBwWRLes=;
	h=Date:To:From:Subject:From;
	b=Zbabnv6ngfoRioZq2s5/NzjaUdH3RXcxDeIZb5aXdHxReJgCUnEhSTA+rH+Mxs2kU
	 EMwuIK92I0WJTGZUZJX+1Nh9KXVOOpm9AzXADs8WG2GTcGrlpSSjWaWv32Ttq8vXmU
	 jvPZTtngIPFiR9Oy/adyETJgEL6oC6SWjAITmMcU=
Date: Fri, 23 Jan 2026 07:31:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-khugepaged-count-small-vmas-towards-scan-limit.patch removed from -mm tree
Message-Id: <20260123153116.44C3EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: count small VMAs towards scan limit
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-count-small-vmas-towards-scan-limit.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: count small VMAs towards scan limit
Date: Sun, 18 Jan 2026 19:22:55 +0000

The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
amount of work performed and consists of three components:
1. Transitioning to a new mm (+1).
2. Skipping an unsuitable VMA (+1).
3. Scanning a PMD-sized range (+HPAGE_PMD_NR).

Consider a 1MB VMA sitting between two 2MB alignment boundaries:

     vma1       vma2   vma3
    +----------+------+----------+
    |2M        |1M    |2M        |
    +----------+------+----------+
               ^      ^
               start  end
               ^
          hstart,hend

In this case, for vma2:
  hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
  hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment

Currently, since `hend <= hstart`, VMAs that are too small or unaligned to
contain a hugepage are skipped without incrementing 'progress'.  A process
containing a large number of such small VMAs will unfairly consume more
CPU cycles before yielding compared to a process with fewer, larger, or
aligned VMAs.

Fix this by incrementing progress when the `hend <= hstart` condition
is met.

Additionally, change 'progress' type to `unsigned int` to match both the
'pages' type and the function return value.

Link: https://lkml.kernel.org/r/20260118192253.9263-8-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-count-small-vmas-towards-scan-limit
+++ a/mm/khugepaged.c
@@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_s
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int progress = 0;
+	unsigned int progress = 0;
 
 	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -2447,7 +2447,8 @@ static unsigned int khugepaged_scan_mm_s
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend) {
+		if (khugepaged_scan.address > hend || hend <= hstart) {
+			/* VMA already scanned or too small/unaligned for hugepage. */
 			progress++;
 			continue;
 		}
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

