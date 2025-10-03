Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E65F258EF0
	for <mm-commits@vger.kernel.org>; Fri,  3 Oct 2025 23:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759535000; cv=none; b=llnj/TywA8uwNyptRUyZpnxMpWuFCbLmadTqkcGWHEFmZHtQgu7TrMcnrbGmCb+MFan/I2jCKEOa8P+pFHJZViX/YtuyUDWyPmBGhaEBc+eL8KIP/QMMD+T4ssv532wywChWweVe9BtjzNFrMFFKRAUAvolBsREW+tkW6mv/G4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759535000; c=relaxed/simple;
	bh=sUakpsI9w87UVgLnshVcV4skjX6wEnJUjUyOGHeE+5g=;
	h=Date:To:From:Subject:Message-Id; b=tQduylFKcB6SCRkW30WVWy4ugy7jz+tOpyIAALoT13MkY9K/rIQuJ833LLhGKgqnmCdFXeqpaYWeiDYUPc6vWoWkJzbfnna2MLfub88BRUEAav5Ve7TtLqEz9TVW5J9wk1GdL9eopgBJXZ3ibdzV9YB5bcva0423jOGTVq/K9L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HN00q+L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HN00q+L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BDFC4CEF5;
	Fri,  3 Oct 2025 23:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759535000;
	bh=sUakpsI9w87UVgLnshVcV4skjX6wEnJUjUyOGHeE+5g=;
	h=Date:To:From:Subject:From;
	b=HN00q+L38naCjZDy62cZQAdafyfhmYgpLEovdWnC3+5X9M3ZQHiVz8QQf/23Hs0Ya
	 uKnz9hoifCtReQ7Z8XkWyrz14pjEW/HTeJ8KTcwm5nX52P0tkPNTGTb4pXNDMPgFMd
	 fC1LN14J5vR59p+W+x4pU4a/W9xH9/VFpfnv3RZM=
Date: Fri, 03 Oct 2025 16:43:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,raghavendra.kt@amd.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,kas@kernel.org,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-kmem_cache.patch removed from -mm tree
Message-Id: <20251003234320.48BDFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: use KMEM_CACHE()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-kmem_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: use KMEM_CACHE()
Date: Wed, 1 Oct 2025 09:19:00 +0000

We got some late review commits during review of commit b4c9ffb54b32
("mm/khugepaged: remove definition of struct khugepaged_mm_slot").  No
need to keep the old cache name "khugepaged_mm_slot", let's simply use
KMEM_CACHE().

Link: https://lkml.kernel.org/r/20251001091900.20041-3-richard.weiyang@gmail.com
Fixes: b4c9ffb54b32 ("mm/khugepaged: remove definition of struct khugepaged_mm_slot")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-kmem_cache
+++ a/mm/khugepaged.c
@@ -376,10 +376,7 @@ int hugepage_madvise(struct vm_area_stru
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
-					  sizeof(struct mm_slot),
-					  __alignof__(struct mm_slot),
-					  0, NULL);
+	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


