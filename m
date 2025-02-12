Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3806A8493
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 00:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739318862; cv=none; b=tXOy05X2QMMnPyMnSFgmatBz0H87u1OmUBTgHQlSzN25Y3jy09LGRRufRCRunDhKg4kmRQ4MaKlpsonaVR0fw0X1WTLaxMUYOjAU524QzNoRygUoocKtpaH9lQDi8ZckdMY5SuxtkovIGpE3yQUKNdpTxbDNU74a0ja9ZjUTkRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739318862; c=relaxed/simple;
	bh=Gk+r9NOZtKPDctUcRNWMLHLoTO24z0YNd47GCH8INgE=;
	h=Date:To:From:Subject:Message-Id; b=nOgunLEcL1itVcs0f+Q3GDshHjA3ZskmHnBjA/LHwC2ENl+VFmUkiaOSs+mkJF7XFDwjrJ8WeCqxD4RoC+RdN61GB9cu51xW+rBDbCa4A1Hg8TBbiH/WHL7+dwkTW3Av1MUm0qKkzSk+yaUGAKUUeNLx7glWap4juX6f0JB8jFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HCNE5tkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HCNE5tkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC62C4CEDD;
	Wed, 12 Feb 2025 00:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739318860;
	bh=Gk+r9NOZtKPDctUcRNWMLHLoTO24z0YNd47GCH8INgE=;
	h=Date:To:From:Subject:From;
	b=HCNE5tkN1KPXO7walAVGupa7A5RtGudmH3FcAB4aifH/FNuOE7dJ285RGE6HqWQ+7
	 aMg4/mPfFdXke/a5GQtVfdJJnBBzlzpA7xk0zLm4jl9Rn6u635HukWOarq9OH3U0H7
	 JdxLCmUhjAkRuR8tF6F2sOlNg2Uodwh90rh4Q6N4=
Date: Tue, 11 Feb 2025 16:07:40 -0800
To: mm-commits@vger.kernel.org,yaozhenguo1@gmail.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,fvdl@google.com,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250212000740.9CC62C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: avoid fallback for specific node allocation of 1G pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: hugetlb: avoid fallback for specific node allocation of 1G pages
Date: Mon, 10 Feb 2025 22:48:56 -0500

When using the HugeTLB kernel command-line to allocate 1G pages from a
specific node, such as:

   default_hugepagesz=1G hugepages=1:1

If node 1 happens to not have enough memory for the requested number of 1G
pages, the allocation falls back to other nodes.  A quick way to reproduce
this is by creating a KVM guest with a memory-less node and trying to
allocate 1 1G page from it.  Instead of failing, the allocation will
fallback to other nodes.

This defeats the purpose of node specific allocation.  Also, specific node
allocation for 2M pages don't have this behavior: the allocation will just
fail for the pages it can't satisfy.

This issue happens because HugeTLB calls memblock_alloc_try_nid_raw() for
1G boot-time allocation as this function falls back to other nodes if the
allocation can't be satisfied.  Use memblock_alloc_exact_nid_raw()
instead, which ensures that the allocation will only be satisfied from the
specified node.

Link: https://lkml.kernel.org/r/20250211034856.629371-1-luizcap@redhat.com
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages
+++ a/mm/hugetlb.c
@@ -3145,7 +3145,7 @@ int __alloc_bootmem_huge_page(struct hst
 
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
-		m = memblock_alloc_try_nid_raw(huge_page_size(h), huge_page_size(h),
+		m = memblock_alloc_exact_nid_raw(huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 		if (!m)
 			return 0;
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages.patch

