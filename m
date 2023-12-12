Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF3080028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pk3PTTI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08197C433C7;
	Tue, 12 Dec 2023 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407591;
	bh=q8sk1fLmM9BbOMeyCeeQmZmYDYgoL5p5W03aCAzfgK8=;
	h=Date:To:From:Subject:From;
	b=Pk3PTTI7RceW7RmPBFQywyck3J0A1nHqnzV2GK2vqs0p/hXaK/UIvy81K7CxSPNIY
	 e0giVcjUbDeUSou0sOQoUja8eL7KGCjmVL3mJkYkNP66eHlo/7adydOUqVHkofAnp5
	 p8FRb0l5FT3tvPCofB/zqxJxlzcGMpWZ0PhfTtaI=
Date: Tue, 12 Dec 2023 10:59:50 -0800
To: mm-commits@vger.kernel.org,mike.kravetz@oracle.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch removed from -mm tree
Message-Id: <20231212185951.08197C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: add check of CONFIG_MEMORY_HOTPLUG back
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: add check of CONFIG_MEMORY_HOTPLUG back
Date: Tue, 5 Dec 2023 11:05:30 +0800

The compiler will optimize the code as much as possible if we add the
check of CONFIG_MEMORY_HOTPLUG back.

Link: https://lkml.kernel.org/r/20231205030530.3802-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-add-check-of-config_memory_hotplug-back
+++ a/mm/hugetlb_vmemmap.c
@@ -119,7 +119,7 @@ static int vmemmap_pmd_entry(pmd_t *pmd,
 	 *   +--+ |                        |
 	 *        +------------------------+
 	 */
-	if (unlikely(!vmemmap_walk->nr_walked)) {
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG) && unlikely(!vmemmap_walk->nr_walked)) {
 		struct page *page = head ? head + pte_index(addr) :
 				    pte_page(ptep_get(pte_offset_kernel(pmd, addr)));
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


