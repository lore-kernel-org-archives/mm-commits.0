Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C49F20012B
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686466; cv=none; b=ITOWamIJ33B5xmlwdtGy3qzwdvb5S6nPQk2ss5vPVMjEWMJJYgcGM3iPR9mEBrR0q5GnRF8qptYZeM5OSzRWHhSilbmeJ2lCXelfofNlHLMR3WH7AHlNceYeA6Tw3PlsaLUvxrPXvn23yk1SEGO5jjzXgAG53Y5zwt4KKFw0tnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686466; c=relaxed/simple;
	bh=Txa1oG5btjOOjl/HqhI8Y08WFqZN2yDvsRO2Lf1/gy4=;
	h=Date:To:From:Subject:Message-Id; b=B2uVquKql6hUGe89oNrnL8eL0WP5KJwufhGLsc/Jg+5FJTW2osgNjB8bAwS+XwKaR3uoBAAo/QBvX8ZOGSdpAEJ92skHe5ByOdcjbAxi+7/KB/eBTidonIhoH+9luq9pnp5F+dy7yKAs127KBz6LnMDAcLHHzJzysaU8swONLeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HvAbjhxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HvAbjhxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FA7C4CEED;
	Thu,  8 May 2025 06:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686466;
	bh=Txa1oG5btjOOjl/HqhI8Y08WFqZN2yDvsRO2Lf1/gy4=;
	h=Date:To:From:Subject:From;
	b=HvAbjhxtzdeZ5PZ0QKx8N2db1ma0/YmTT9gVGktDwMjyNMDIfg4egHkPJOB81P0tA
	 +sNO3t3sohY2QpVBvgaFjA9dWC//UFEXjpMg05yB4kpu09idsVQijQUrFyPIoIA6TF
	 eZqaqZ/uSbMY5hPEXg9uK4mqzoK5geoAmf98apNc=
Date: Wed, 07 May 2025 23:41:05 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,Jane.Chu@oracle.com,anshuman.khandual@arm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-copy-the-cma-flag-when-demoting.patch removed from -mm tree
Message-Id: <20250508064106.35FA7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: copy the CMA flag when demoting
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-copy-the-cma-flag-when-demoting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: copy the CMA flag when demoting
Date: Thu, 1 May 2025 04:43:24 +0000

Since commit d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA
areas"), a flag is used to mark hugetlb folios as allocated from CMA. 
This flag is also used to decide if it should be freed to CMA.

However, the flag isn't copied to the smaller folios when a hugetlb folio
is broken up for demotion, which would cause it to be freed incorrectly.

Fix this by copying the flag to the smaller order hugetlb pages created
from the original one.

Link: https://lkml.kernel.org/r/20250501044325.20365-1-fvdl@google.com
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jane Chu <Jane.Chu@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-copy-the-cma-flag-when-demoting
+++ a/mm/hugetlb.c
@@ -4034,10 +4034,13 @@ static long demote_free_hugetlb_folios(s
 
 	list_for_each_entry_safe(folio, next, src_list, lru) {
 		int i;
+		bool cma;
 
 		if (folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
 
+		cma = folio_test_hugetlb_cma(folio);
+
 		list_del(&folio->lru);
 
 		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
@@ -4053,6 +4056,9 @@ static long demote_free_hugetlb_folios(s
 
 			new_folio->mapping = NULL;
 			init_new_hugetlb_folio(dst, new_folio);
+			/* Copy the CMA flag so that it is freed correctly */
+			if (cma)
+				folio_set_hugetlb_cma(new_folio);
 			list_add(&new_folio->lru, &dst_list);
 		}
 	}
_

Patches currently in -mm which might be from fvdl@google.com are

mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

