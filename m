Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11C1EDA2F
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119243; cv=none; b=dIu1m6tE2xgD41vByZIRGRrl/tq7KUoCYcbP92Ujee34gHFlhN43W425HQVYa0pJnOAY1XO40Av0AwYIkA0mBzVM0eunjGx9aVCw4KaazDsovPGQUu2vx9IvYP7DAGXSkRfP+yi50ZZqKqQPG+uG/TvmyEHQsb2H0aVLqHVz+vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119243; c=relaxed/simple;
	bh=T+1YEuBA+HmrzBuzdCIjePjqjfwPKh5C7aZLed0yDMw=;
	h=Date:To:From:Subject:Message-Id; b=cXl++Uu26SI7B0aBvpUQSfm0ABi2ybYqgxzJVM3dlxcmBBgcs3kVQiv0OEXGRNuzAYFSZqsa4R/CLxKqmB699v5pe7S8BZ87FN0VtjSvmzK8B65yc2idTiEGI6iDSnbu+v7dZGqKEj1FEaL6lfCFXKhhqB+3492qIbwdvVRN3lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d0hE9nBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d0hE9nBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CC4C4CEED;
	Tue, 13 May 2025 06:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119243;
	bh=T+1YEuBA+HmrzBuzdCIjePjqjfwPKh5C7aZLed0yDMw=;
	h=Date:To:From:Subject:From;
	b=d0hE9nBkdhRmYNqGj65FynmbPZmWA7CIF74S6W9u0GrpdUmXTKCnyJU3d6b6y2jn0
	 7UK89dEZzWuVNDMZyHfKBlr7+wdueaWt4s85VH19OmLnZBBF3V/9Aa3yh2tjuFoLvz
	 ipF2beKDq8QwUPYjEGCFMB3dT/uopJKEw8Arpuao=
Date: Mon, 12 May 2025 23:54:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,anshuman.khandual@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch removed from -mm tree
Message-Id: <20250513065403.A3CC4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/io-mapping: precompute remap protection flags for clarity
has been removed from the -mm tree.  Its filename was
     mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/io-mapping: precompute remap protection flags for clarity
Date: Sun, 27 Apr 2025 18:04:40 +0800

Patch series "mm: small cleanups for io-mapping, debug_page_alloc and
numa".

This series includes three small cleanups to mm/:

- io-mapping: simplify remap protection flag calculation
- debug_page_alloc: improve error message by printing invalid input
- numa: remove unnecessary variable for clarity

No functional changes.


This patch (of 3):

In io_mapping_map_user(), precompute the page protection flags in a local
variable before calling remap_pfn_range_notrack().

No functional change.

Link: https://lkml.kernel.org/r/20250427100442.958352-1-ye.liu@linux.dev
Link: https://lkml.kernel.org/r/20250427100442.958352-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/io-mapping.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/io-mapping.c~mm-io-mapping-precompute-remap-protection-flags-for-clarity
+++ a/mm/io-mapping.c
@@ -21,9 +21,10 @@ int io_mapping_map_user(struct io_mappin
 	if (WARN_ON_ONCE((vma->vm_flags & expected_flags) != expected_flags))
 		return -EINVAL;
 
+	pgprot_t remap_prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
+				       (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK));
+
 	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
-	return remap_pfn_range_notrack(vma, addr, pfn, size,
-		__pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
-			 (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK)));
+	return remap_pfn_range_notrack(vma, addr, pfn, size, remap_prot);
 }
 EXPORT_SYMBOL_GPL(io_mapping_map_user);
_

Patches currently in -mm which might be from liuye@kylinos.cn are


