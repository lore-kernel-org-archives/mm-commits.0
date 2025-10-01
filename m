Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A8F1946AA
	for <mm-commits@vger.kernel.org>; Wed,  1 Oct 2025 20:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759351794; cv=none; b=PdP9N24adYFNZJk8Cd9fAtvhlTaDqJvKvIJMWeibnaSMb9oTf0j2D6POr4IDRme9QASkGNsXOmUKZ/JnfsbzEm45hK/r5jT1WPlZlVocGxN1sUK+nsYiKLXvAD9LnmBWE2I9LF3iCERk9ZVGWCfy1jzqkzGMbYt6ee1SkEGTQSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759351794; c=relaxed/simple;
	bh=W1/0Ee41WIaBtYr0VPPq1t02PDZyQGdYCpCnP6/3rTU=;
	h=Date:To:From:Subject:Message-Id; b=EzTl8R7fkKKY6N7tpiQp7roEbSfnq5d1RUrmyMFocnsiNc98sTAhGaswceFoW/CVLjYOghYqpRWEVC3+UfRe2Yp7FJJZFmnA632Gh0xmyaUB1VumuOAdqJQigYL4ZX3T9JiNCTu67IxfhyFN87CM6hy6gybolEZ6oYnjYmg0OwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLWvfKjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLWvfKjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FA2C4CEF1;
	Wed,  1 Oct 2025 20:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759351793;
	bh=W1/0Ee41WIaBtYr0VPPq1t02PDZyQGdYCpCnP6/3rTU=;
	h=Date:To:From:Subject:From;
	b=MLWvfKjBkM2/FoaifMWj+EpzcFeo5ZhBq1ZZDGW/M4vhwYAglU8+nfnHclI0tsXhB
	 sS2a+XwcbnCmrsgoKBkvFbRVx1cmoQzFWaxhm9QCeap2NLC1SUufI689XKq4oyq3wc
	 vDmFbpfgl4y7GIsfRxWA8AIUHDjPFV+pSp8XLL44=
Date: Wed, 01 Oct 2025 13:49:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,raghavendra.kt@amd.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,kas@kernel.org,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-kmem_cache.patch added to mm-unstable branch
Message-Id: <20251001204953.84FA2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use KMEM_CACHE()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-use-kmem_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-kmem_cache.patch

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

mm-ksm-cleanup-mm_slot_entry-invocation.patch
mm-khugepaged-use-kmem_cache.patch

