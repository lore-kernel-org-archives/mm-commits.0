Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C3A1DE4E1;
	Sat, 15 Nov 2025 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763232759; cv=none; b=rV9+R5wtWA6CfYyujWKqNpI7uwRw+jo5e/ihq9PnRSZ3mi/QuvtRLz1XR2Zo720N31ujPDo0nCWcTbfVWwFIIyCjuhN4/JNgOOU1uGcaSEtr/b2Y9pEeXTKxmxRrBWfe3szICldLdD84LRKRG9/JkoS0w4DrdVH7zMhiEz4ad4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763232759; c=relaxed/simple;
	bh=I9pxkfQX3+DeoXG7PanWwYNAJbUZRZjxlTIZvs7fpAw=;
	h=Date:To:From:Subject:Message-Id; b=Ptm6SbFj+Al/645Kc9Egwlzd6KNzhPT96XJIqdROUVL2fu69Ix3oN6BPUvyrVO6kKto6bY49Dvf4ZqTlgDu9hx9LjKjPP2oefyCE7/QJWcsdlEPkY0ciuWD5/+0OgdtT87q/twO+16XFY746eqBmRduc0c7RuIkcZrU5jyswQn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbjduFSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbjduFSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F4CC4CEF5;
	Sat, 15 Nov 2025 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763232759;
	bh=I9pxkfQX3+DeoXG7PanWwYNAJbUZRZjxlTIZvs7fpAw=;
	h=Date:To:From:Subject:From;
	b=qbjduFStqirykEOcKVz8/T99yd2dH9uu0P9MBuGki6kGFve+87QT0zeM1jHZYOU02
	 9wmImxeZDxuuUfuv2KiT54pT6Xp4HUn0bOlsv8BIc/rVGshpgrYH9AMT54WnIperPJ
	 UM1KuNiumaxwQeUrILxkXB2Kz/8TmlqvRslatdLw=
Date: Sat, 15 Nov 2025 10:52:38 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch removed from -mm tree
Message-Id: <20251115185239.45F4CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix folio split check for anon folios in swapcache
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix folio split check for anon folios in swapcache
Date: Wed, 5 Nov 2025 11:29:10 -0500

Both uniform and non uniform split check missed the check to prevent
splitting anon folios in swapcache to non-zero order.

Splitting anon folios in swapcache to non-zero order can cause data
corruption since swapcache only support PMD order and order-0 entries. 
This can happen when one use split_huge_pages under debugfs to split
anon folios in swapcache.

In-tree callers do not perform such an illegal operation.  Only debugfs
interface could trigger it.  I will put adding a test case on my TODO
list.

Fix the check.

Link: https://lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio-split-check-for-anon-folios-in-swapcache
+++ a/mm/huge_memory.c
@@ -3522,7 +3522,8 @@ bool non_uniform_split_supported(struct
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    !mapping_large_folio_support(folio->mapping)) {
 		/*
@@ -3553,7 +3554,8 @@ bool uniform_split_supported(struct foli
 	if (folio_test_anon(folio)) {
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
-		return new_order != 1;
+		if (new_order == 1)
+			return false;
 	} else  if (new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch
migrate-optimise-alloc_migration_target-fix.patch

