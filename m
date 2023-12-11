Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0A53B6
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QjJzzzGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5391CC433C7;
	Mon, 11 Dec 2023 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256126;
	bh=wvETNNf90a8E3iDVZHbfOe4cj8Ni38tRNvf+p2zseo4=;
	h=Date:To:From:Subject:From;
	b=QjJzzzGmMt5/uhmtj9mO7mZoE84Kid2bj/LYRmNKdwNZKsTTze4PpxHG7AlFyn98s
	 rXy23JRzWDZ6263wslSAL2j3Rr6E4RhKay895Z5V05FmUvKV3PaqMB6uQAEjkmNDRi
	 K3Ftjf8f34CJRl4H/3j5ZGtSQKTCpis6gh8oSZWA=
Date: Sun, 10 Dec 2023 16:55:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,mgorman@suse.de,hch@lst.de,david@redhat.com,dan.j.williams@intel.com,aneesh.kumar@linux.vnet.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch removed from -mm tree
Message-Id: <20231211005526.5391CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix follow_devmap_p[mu]d() on page==NULL handling
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: fix follow_devmap_p[mu]d() on page==NULL handling
Date: Thu, 23 Nov 2023 13:02:22 -0500

This is a bug found not by any report but only by code observations.

When GUP sees a devpmd/devpud and if page==NULL is returned, it means a
fault is probably required.  Here falling through when page==NULL can
cause unexpected behavior.

Fix both cases by catching the page==NULL cases with no_page_table().

Link: https://lkml.kernel.org/r/20231123180222.1048297-1-peterx@redhat.com
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Fixes: 080dbb618b4b ("mm/follow_page_mask: split follow_page_mask to smaller functions.")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-fix-follow_devmap_pd-on-page==null-handling
+++ a/mm/gup.c
@@ -710,6 +710,7 @@ static struct page *follow_pmd_mask(stru
 		spin_unlock(ptl);
 		if (page)
 			return page;
+		return no_page_table(vma, flags);
 	}
 	if (likely(!pmd_trans_huge(pmdval)))
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
@@ -758,6 +759,7 @@ static struct page *follow_pud_mask(stru
 		spin_unlock(ptl);
 		if (page)
 			return page;
+		return no_page_table(vma, flags);
 	}
 	if (unlikely(pud_bad(*pud)))
 		return no_page_table(vma, flags);
_

Patches currently in -mm which might be from peterx@redhat.com are


