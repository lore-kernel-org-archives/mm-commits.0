Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8E3B4EB2
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068029; cv=none; b=JpNVpYOC/BkoePvMb7X5/t4wR+jwPnCMB0y4BbCBMxCExDjps04r1KmWUJ91xmIFzIs3A8gluU35N1SBun+zQ5Wt4/kCTdKjS9VoF/Az2JpbY4ehgpUk2M2qLF/zjcjg1n+s5NaNppkNmvCqxBt/ThinCFaILObBQ5hRQBgX+YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068029; c=relaxed/simple;
	bh=RHVTubxPhcYJV7+F46esOIqfcp73hDYzUAOKGRmmgk0=;
	h=Date:To:From:Subject:Message-Id; b=F4l231J2lTGiepmoM/3HmvOy5g8q+3qaFZz2eNaFbV6FT6v9lj5yDL+EgeM4wT9Kr1LBVhiIppUqFNG5uza/sS3PJU9EGzrAH7efyUAf+XtG4eEYWIUVtEhdK58YMzlmfRMIdoj14VIWvpt5+JqyNA8HVcuKFZ4JQCOcXgDSDyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dqV+Otw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dqV+Otw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052EC1F00ADB;
	Fri,  7 Aug 2026 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068018;
	bh=x93XnT5eCTx4tuf8M4evWDa81A5/1B7oen+EESXZi+0=;
	h=Date:To:From:Subject;
	b=dqV+Otw3FQdkGa2yjpTXIDvuaSdM763bkS+xRVDW7PSyCxxdinRmBdSg0RlJ7ZGE8
	 fez1OW6BIa4KYdhiUthmRPB0CTwBVkascKhWeYJq45kOo5RFrWES3kzakhynZGOoQV
	 6ram0EhcrHGKpap/v7JiHBD0LAD2fhBuy5o57Two=
Date: Thu, 06 Aug 2026 19:00:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error.patch removed from -mm tree
Message-Id: <20260807020018.052EC1F00ADB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: fix kobject cleanup in thpsize_create error
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongling Zeng <zenghongling@kylinos.cn>
Subject: mm: huge_memory: fix kobject cleanup in thpsize_create error
Date: Mon, 13 Jul 2026 13:41:54 +0800

When kobject_init_and_add() fails, the kobject API requires calling
kobject_put() to properly clean up the memory, not direct kfree().

According to the kobject API documentation, kobject_init_and_add() calls
kobject_init() internally.  If the subsequent kobject_add() fails, the
kobject has still been initialized and must be cleaned up via the
reference count mechanism (kobject_put), not direct kfree().

Direct kfree() leaves the kobject's internal state (including the
reference count and kset membership) uncleaned, which can cause:
 - Memory leaks of kobject internal structures
 - Potential use-after-free if there are pending references
 - Inconsistent state with the rest of the error handling code

This fix matches the pattern used elsewhere in the kernel and in the same
function (err_put label) which correctly uses kobject_put().

Link: https://lore.kernel.org/20260713054154.120915-1-zenghongling@kylinos.cn
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-kobject-cleanup-in-thpsize_create-error
+++ a/mm/huge_memory.c
@@ -818,10 +818,8 @@ static struct thpsize *thpsize_create(in
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
+	if (ret)
+		goto err_put;
 
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
_

Patches currently in -mm which might be from zenghongling@kylinos.cn are


