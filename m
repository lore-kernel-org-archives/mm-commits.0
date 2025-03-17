Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA91215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188363; cv=none; b=CPCDKnvuXW61YrPDD72v4l/ZJpnu1qvojYp2Vqpr3KrhCDeC0MQJuelo8Ev16U9MwDDdJqMLVH0jmIF4pQ6b8dS5OkAGJOwemeIUH6Dn2kI3cT6CfjrCNO/uggLT3l7GMLE/VqBty4/UVrD52TPdjHDIFu7o2VB0zX9XPVBYe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188363; c=relaxed/simple;
	bh=4ZFMQeqzwOjVyTvKqTQlQ0vHCe/5+k5AaqZiQVq2ZKU=;
	h=Date:To:From:Subject:Message-Id; b=D2Qn/3GqeJw3xAv1xoPO4ERQxWW+nn9U/ZsRhVyFG5p3zi484B8py+S2KzmyBDuTeggXyfbBkdlEKMVl8/l5cYILMt6nTon2KnARxYIBEJhZIkM0pU2qFIslxh31Iv1erufnhPu8UuGUeXCbjZMkYcmyKoGaHGn0i2wKzu5507Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/YveXg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/YveXg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10681C4CEEC;
	Mon, 17 Mar 2025 05:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188363;
	bh=4ZFMQeqzwOjVyTvKqTQlQ0vHCe/5+k5AaqZiQVq2ZKU=;
	h=Date:To:From:Subject:From;
	b=D/YveXg3rPiy71RviIKO8M2FvOvxrCgVGrqvTH6drCrpKYoGgZ1i1tbLOiUQ17db+
	 IDtFVo+CLYTU/8joq2nn4vMlEbqa7FEQPKWJzAI/K7Z3KW0REYp4p0x8M+7opRBwxx
	 qR0346zJo7PAAHA9kXNn1KGxTZM+md6i6ZfXab20=
Date: Sun, 16 Mar 2025 22:12:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-redundant-__clearpagereserved.patch removed from -mm tree
Message-Id: <20250317051243.10681C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove redundant __ClearPageReserved
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-redundant-__clearpagereserved.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: remove redundant __ClearPageReserved
Date: Fri, 28 Feb 2025 18:29:06 +0000

In hugetlb_folio_init_tail_vmemmap, the reserved flag is cleared for the
tail page just before it is zeroed out, which is redundant.  Remove the
__ClearPageReserved call.

Link: https://lkml.kernel.org/r/20250228182928.2645936-6-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-redundant-__clearpagereserved
+++ a/mm/hugetlb.c
@@ -3210,7 +3210,6 @@ static void __init hugetlb_folio_init_ta
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__ClearPageReserved(folio_page(folio, pfn - head_pfn));
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
 		ret = page_ref_freeze(page, 1);
_

Patches currently in -mm which might be from fvdl@google.com are


