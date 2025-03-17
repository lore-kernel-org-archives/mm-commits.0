Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEBD215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188361; cv=none; b=SjxH60/WthdlwmwmKPdSmdNumDMYbXsAmjgBoJt1M07rnEQVpco5M2ZiF/XYOzA8/apveir3du8k0qRXJs0YGdnxoeLbYgJ77wTPEloX9FEAeFfjb/tCEglXFYEkRcNTaAttZtB57cHFKmxJgyw8Xji9prjkCByjpUcA1x8uPMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188361; c=relaxed/simple;
	bh=7Mtwa63nLkYiX9d+ADldS28WoI4dtJwk9yfPyP3syzo=;
	h=Date:To:From:Subject:Message-Id; b=vFETClibIdc0xE8ulfHygjhOjvcQEJG10YZ/mJPbT0xm/4S11HfTtlAtoPOV4faN3xE62ruEEfFyb8gt+f9HVIYkmCGviefJHE2asQk/FcCS92eW9Od0PA8jYIs3Es+SnMZx5DRodHuh9MQB5xLgEkAe223YbKl2f02SrSBnieY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyWUfjI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyWUfjI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F833C4CEEC;
	Mon, 17 Mar 2025 05:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188361;
	bh=7Mtwa63nLkYiX9d+ADldS28WoI4dtJwk9yfPyP3syzo=;
	h=Date:To:From:Subject:From;
	b=gyWUfjI0JZ65pNmVGfhNDVI/7LjX9/moNgnzOR5hChSUva6pFMcqLme6o0+B8/0wQ
	 Zk+z0QUz0M01hS9XBA8kW37nfUb2IldWFEyhwdi18FOYDQpPi8zABwpHdkWBXOk9bh
	 ayQqm47VstR7u7Q/fqrlspSrxep9zOR1bEoTPpKo=
Date: Sun, 16 Mar 2025 22:12:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-cma_declare_contiguous_multi.patch removed from -mm tree
Message-Id: <20250317051241.7F833C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, hugetlb: use cma_declare_contiguous_multi
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-cma_declare_contiguous_multi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm, hugetlb: use cma_declare_contiguous_multi
Date: Fri, 28 Feb 2025 18:29:05 +0000

hugetlb_cma is fine with using multiple CMA ranges, as long as it can get
its gigantic pages allocated from them.  So, use
cma_declare_contiguous_multi to allow for multiple ranges, increasing the
chances of getting what we want on systems with gaps in physical memory.

Link: https://lkml.kernel.org/r/20250228182928.2645936-5-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-cma_declare_contiguous_multi
+++ a/mm/hugetlb.c
@@ -7750,9 +7750,8 @@ void __init hugetlb_cma_reserve(int orde
 		 * may be returned to CMA allocator in the case of
 		 * huge page demotion.
 		 */
-		res = cma_declare_contiguous_nid(0, size, 0,
-					PAGE_SIZE << order,
-					HUGETLB_PAGE_ORDER, false, name,
+		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
+					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
_

Patches currently in -mm which might be from fvdl@google.com are


