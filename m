Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB41283FE4
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126311; cv=none; b=gQ9pUAHLcMUSHA8V0WCahyQiN+55dqAsjQnBVmLoRmLX0EWe3OOkAq9Y6gl7H7E2vNNZKIt9eeYOBX2Sxsfi3BOzeGGiW4VKg058B3+wwxBpQT8ZChCmPkgK/5rbeTTW3MkwAeDozLD3/i6RMMkbI+cRKV0wC/LKsmYgUs8owqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126311; c=relaxed/simple;
	bh=5sIbSHaP6RQXOtcWPnzlrQs1yz2HgIoKoktpq51YPvE=;
	h=Date:To:From:Subject:Message-Id; b=SkkdWFxfIbKW1LVregbqdDnZToPhUHRAz8oDGa3Y+dmwt5RqXZmSYFnhba8dj7y18YUYuAHKJCXqm1+v5CRrIAeWeXh5bnJLlu1JqzsKkIPBHdh00DQ5vrrlynmy4I6UhmS2co1lf6oojdLHYpR8FYFDqaAMoj8zNqTuIuJGGsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kon4DKWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kon4DKWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAD2C4CEE3;
	Thu, 10 Jul 2025 05:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126311;
	bh=5sIbSHaP6RQXOtcWPnzlrQs1yz2HgIoKoktpq51YPvE=;
	h=Date:To:From:Subject:From;
	b=kon4DKWlO1oInHsTUByt8lLKkf5wxFuuwAW3L8P5bI8zvKd26dqsDoxKY3TDOUhK0
	 hrk+HAu77IOq092eQ/7eb+mMW6+yFC8qvv1UP45kVonmbgKubXhmThQUvxP1Fi8llZ
	 szbMyHjtishTSutzAfxH5RH/bHON+jzf5g5RCv9Y=
Date: Wed, 09 Jul 2025 22:45:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch removed from -mm tree
Message-Id: <20250710054511.1DAD2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: fix the check for allowed huge orders in shmem
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: fix the check for allowed huge orders in shmem
Date: Fri, 13 Jun 2025 17:12:19 +0800

Shmem already supports mTHP, and shmem_allowable_huge_orders() will return
the huge orders allowed by shmem.  However, there is no check against the
'orders' parameter passed by __thp_vma_allowable_orders(), which can lead
to incorrect check results for __thp_vma_allowable_orders().

For example, when a user wants to check if shmem supports PMD-sized THP by
thp_vma_allowable_order(), if shmem only enables 64K mTHP, the current
logic would cause thp_vma_allowable_order() to return true, implying that
shmem allows PMD-sized THP allocation, which it actually does not.

I don't think this will cause a significant impact on users, and this will
only have some impact on the shmem THP collapse.  That is to say, even
though the shmem sysfs setting does not enable the PMD-sized THP, the
thp_vma_allowable_order() still indicates that shmem allows PMD-sized
collapse, meaning it might successfully collapse into THP, or it might not
(for example, thp_vma_suitable_order() check failed in the collapse
process).  However, this still does not align with the shmem sysfs
configuration, fix it.

Link: https://lkml.kernel.org/r/529affb3220153d0d5a542960b535cdfc33f51d7.1749804835.git.baolin.wang@linux.alibaba.com
Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem
+++ a/mm/huge_memory.c
@@ -166,7 +166,7 @@ unsigned long __thp_vma_allowable_orders
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file))
-		return shmem_allowable_huge_orders(file_inode(vma->vm_file),
+		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
 						   vma, vma->vm_pgoff, 0,
 						   !enforce_sysfs);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

