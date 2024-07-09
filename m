Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F2E7CF18;
	Tue,  9 Jul 2024 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720564912; cv=none; b=rCxvlh7Q5JCTWXk3wq+MbNT/J2N9o1/YEkfQfsW68inh485flaZi0oJd3CkkL65G7BOORq9yudfemuwyIBTXcpR5jqxKxdaV/XEdxVYTKvyJEbGpWjiJNb4B+5vSMUuvF0rZBFZ+gXE1gscfq6W2jrTzl8PtuWGbOU1Hq86toGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720564912; c=relaxed/simple;
	bh=3zwIKNh1J+nKd78hgy2qirJffO/DMUAFjCcriRHzMRQ=;
	h=Date:To:From:Subject:Message-Id; b=AMnV/mgVjYu7oB5gg5jT31iFnoMre7KRVPydX5zRhituUllTKfGJo9zs+SKGWCzKdtRflXVKL2mEDSEkS1ay3OgNbKVcuOixrvE8C9M2pG4kYiEoQD2phOvQLZ9SU3oMgRc8lPAJi4n5Ebx3F2KibwHQPQ0OnjcfPscY60upy34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8YvXs8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8YvXs8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC28EC32786;
	Tue,  9 Jul 2024 22:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720564912;
	bh=3zwIKNh1J+nKd78hgy2qirJffO/DMUAFjCcriRHzMRQ=;
	h=Date:To:From:Subject:From;
	b=M8YvXs8W508siFscTW9sT7TNoiSXJkQc5lvSh/PKtOfFy+Fj/D/o0a5NpiPbxYMmH
	 P+d3dw1tltrk3rDY43/5Uz04hW6eXcCY9SN8M/9A6Bddhp1O64COBsoXL2jUClkgQB
	 5ccQTYwO3W4RIM7YRQbV+Y+Yc52K29MGr5r/x/68=
Date: Tue, 09 Jul 2024 15:41:51 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,stable@vger.kernel.org,shy828301@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,aneesh.kumar@linux.ibm.com,zhangpeng362@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch removed from -mm tree
Message-Id: <20240709224151.EC28EC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: replace pte_offset_map() with pte_offset_map_nolock()
has been removed from the -mm tree.  Its filename was
     filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

As David said, the PTL pointer might be stale so if we continue to use
it infilemap_fault_recheck_pte_none(), it might trigger UAF.  Also, if
the PTL fails, the issue fixed by commit 58f327f2ce80 ("filemap: avoid
unnecessary major faults in filemap_fault()") might reappear.

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-replace-pte_offset_map-with-pte_offset_map_nolock
+++ a/mm/filemap.c
@@ -3231,7 +3231,8 @@ static vm_fault_t filemap_fault_recheck_
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
 		return 0;
 
-	ptep = pte_offset_map(vmf->pmd, vmf->address);
+	ptep = pte_offset_map_nolock(vma->vm_mm, vmf->pmd, vmf->address,
+				     &vmf->ptl);
 	if (unlikely(!ptep))
 		return VM_FAULT_NOPAGE;
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


