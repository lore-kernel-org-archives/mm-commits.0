Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBBE60DD6
	for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2024 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710354953; cv=none; b=FSu2raIotCEzpxnGGvksTYAJVWnAM+IMAnp+pqfH1EhvAappA6RVFbjjsDzo5aZdhrUH+zuVRv+trpY9Cg5R7P1JonOtgQVtWmseCnRdP9RJDNv1ihVrkapNYdVowjTWQcE/LzQ1T8qizLH8Qkv/fuadvROQ0bpqAO3n2TFzqgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710354953; c=relaxed/simple;
	bh=5CXqaSGH3H2H9d7PxZ1NYZGuLGYxPduufBMIGnTKWG4=;
	h=Date:To:From:Subject:Message-Id; b=UwrFfN3KpjQ1rIh7NjrqALtX1p4u8yo1KNQWbZNePF14JDtrvSb9A31JLNCSHo6QEqxmuRD3wj1UbVWuPhnn4V90Yss10jSSrVPrc5VSVLLRjNeLXTWaV486c5iBydRceHQzqbrQOONBIK7FOTNtAvGVvAWG6byrAFPaMWUSoMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QUfYXdV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QUfYXdV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8AAC433C7;
	Wed, 13 Mar 2024 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710354953;
	bh=5CXqaSGH3H2H9d7PxZ1NYZGuLGYxPduufBMIGnTKWG4=;
	h=Date:To:From:Subject:From;
	b=QUfYXdV7c0Z2/g9ctXwKDhF42MWMabBRvqTh7dc8sHi0EBVz3JfX8HqoXTOs9mPsR
	 rxuW31+JqxSX0sPriDM9m2Oupdk103wbNGwLWZvqmfFhJoS+V5GI4bOzwKdE7e6eon
	 uoyqbtq64yviVLe1p6VHbLV36fifstM6kpNVrsC8=
Date: Wed, 13 Mar 2024 11:35:51 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shy828301@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,aneesh.kumar@linux.ibm.com,zhangpeng362@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch added to mm-unstable branch
Message-Id: <20240313183552.EC8AAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: replace pte_offset_map() with pte_offset_map_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: filemap: replace pte_offset_map() with pte_offset_map_nolock()
Date: Wed, 13 Mar 2024 09:29:13 +0800

The vmf->ptl in filemap_fault_recheck_pte_none() is still set from
handle_pte_fault().  But at the same time, we did a pte_unmap(vmf->pte). 
After a pte_unmap(vmf->pte) unmap and rcu_read_unlock(), the page table
may be racily changed and vmf->ptl maybe fails to protect the actual page
table.  Fix this by replacing pte_offset_map() with
pte_offset_map_nolock().

Link: https://lkml.kernel.org/r/20240313012913.2395414-1-zhangpeng362@huawei.com
Fixes: 58f327f2ce80 ("filemap: avoid unnecessary major faults in filemap_fault()")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-replace-pte_offset_map-with-pte_offset_map_nolock
+++ a/mm/filemap.c
@@ -3207,7 +3207,8 @@ static vm_fault_t filemap_fault_recheck_
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
 		return 0;
 
-	ptep = pte_offset_map(vmf->pmd, vmf->address);
+	ptep = pte_offset_map_nolock(vma->vm_mm, vmf->pmd, vmf->address,
+				     &vmf->ptl);
 	if (unlikely(!ptep))
 		return VM_FAULT_NOPAGE;
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch

