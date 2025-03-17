Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227A221766A
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188389; cv=none; b=I/3/tJRfhDxsYCCA8X+4QWVReXJQz36+d8xvUgwa4bEFU02CyL2/4qwFUVKPtmP1QymFA4kysqO0rccPlYTOJFZeW+QkbTdPAvIrZNzQaXjQqEU1DQo7DpJG19pF5dNGzWMm3RCfrueGY3ZrqUU8MZ+arXhoQY2v6Uh6pclUA60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188389; c=relaxed/simple;
	bh=/2bsO1QmOUo8FnhoDhcHipAHEpQBJBG0RJv22GVUvBI=;
	h=Date:To:From:Subject:Message-Id; b=f1zTpRrsg+lvvC+1V8Ud5W+mwQxq7wTX87bjmub6Vs5WQ/BHtEu0hTRJ2wmr17tRpCktxo9LxDgzy5hlhSmB8vFk4Z1tjLdjSFNaHF9pLSDb22OYs31oq1e74U+BIQy8d66/mlDf3nr7PQb9vCMTrHV9GWCE1OIUm0dVUDmMAO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lfUgYreX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lfUgYreX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF83C4CEEC;
	Mon, 17 Mar 2025 05:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188389;
	bh=/2bsO1QmOUo8FnhoDhcHipAHEpQBJBG0RJv22GVUvBI=;
	h=Date:To:From:Subject:From;
	b=lfUgYreXMpuaQp1mctv0fH5MNKFgmBOaT8KaGVk+MpBs+IK8LCY6jeJ6kW8ICesbu
	 VJk/gX7Opedfpcmd5OROpeUZ6KGBwzisHl+rUYlnNSAG7gPahOUp9YNFyKSGWMAWKu
	 VROrCKhxhsmTz3ufcK6yYoYuSCkHXMPQMm7ISliY=
Date: Sun, 16 Mar 2025 22:13:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch removed from -mm tree
Message-Id: <20250317051308.EAF83C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: fix hugetlb_vmemmap_restore_folios definition
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb_vmemmap: fix hugetlb_vmemmap_restore_folios definition
Date: Fri, 28 Feb 2025 18:29:19 +0000

Make the hugetlb_vmemmap_restore_folios definition inline for the
!CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP case, so that including this file in
files other than hugetlb_vmemmap.c will work.

Link: https://lkml.kernel.org/r/20250228182928.2645936-19-fvdl@google.com
Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list of pages")
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

 mm/hugetlb_vmemmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition
+++ a/mm/hugetlb_vmemmap.h
@@ -50,7 +50,7 @@ static inline int hugetlb_vmemmap_restor
 	return 0;
 }
 
-static long hugetlb_vmemmap_restore_folios(const struct hstate *h,
+static inline long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
 					struct list_head *non_hvo_folios)
 {
_

Patches currently in -mm which might be from fvdl@google.com are


