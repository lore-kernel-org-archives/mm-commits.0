Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043BF342C88
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023636; cv=none; b=l/vuVW9oCxH9QvYRQdMU2d6o+oJfuzRwq6YFVA05/ocenkcGgUQgsdiEgsLSAnJtAbXZ/ZWpPNJorHiEm0Zozqrmjw3mwzBgZUd3QEWh6lPo+GMiY6UybdZLOxbbUmzZ8S93ZGDfkza089thZGs+CrI90fXRASfLpgYrFSTQVIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023636; c=relaxed/simple;
	bh=F0BHylOa0O6bhyighsuC3BH8DCBT1tBfHkM9ysE8/Sw=;
	h=Date:To:From:Subject:Message-Id; b=V2KO3u1xzqLNF7uiM6aJmV6zv8YYnzua3CJnSYxabnaGBG/K/wc46UMSc3gspt8QysL/YrIBit4VyRLw1stxc1QgLjFRj0t9ERz3G4XPPUOSkfeV7/uRM0zABso2S+ro4ku/GMqyFyxwlOngTPzkzZlirbawfYllV7QdWEnglII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SXFJK15A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SXFJK15A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7A6C4CEF1;
	Mon, 24 Nov 2025 22:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023635;
	bh=F0BHylOa0O6bhyighsuC3BH8DCBT1tBfHkM9ysE8/Sw=;
	h=Date:To:From:Subject:From;
	b=SXFJK15AO1mUEIy1SOPON16Ah1VLBLrlc/Qq+dmVN1cJupV/jJMwZAPNDzv4TkwBF
	 66mhxhMIKB+opXXmSJqGPQ9VsPZea8Cjc7hBjztYzgChcz02rtzwieuBdi65n1qQGv
	 GhrtnT0ReJdpVwrWUKv2e+cLeMlBeqcwz9zfCstY=
Date: Mon, 24 Nov 2025 14:33:54 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch removed from -mm tree
Message-Id: <20251124223355.9D7A6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: kernel-doc fixup
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch

This patch was dropped because it was folded into mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: kernel-doc fixup
Date: Fri, 31 Oct 2025 19:50:55 -0400

Link: https://lkml.kernel.org/r/BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix
+++ a/mm/huge_memory.c
@@ -3512,7 +3512,7 @@ static void __split_folio_to_order(struc
  *    uniform_split is true.
  * 2. buddy allocator like (non-uniform) split: the given @folio is split into
  *    half and one of the half (containing the given page) is split into half
- *    until the given @page's order becomes @new_order. This is done when
+ *    until the given @folio's order becomes @new_order. This is done when
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
@@ -3521,14 +3521,14 @@ static void __split_folio_to_order(struc
  *    along with stats update.
  * 2. non-uniform split: folio_order - @new_order calls to
  *    __split_folio_to_order() are expected to be made in a for loop to split
- *    the @folio to one lower order at a time. The folio containing @page is
- *    split in each iteration. @xas is split into half in each iteration and
+ *    the @folio to one lower order at a time. The folio containing @split_at
+ *    is split in each iteration. @xas is split into half in each iteration and
  *    can fail. A failed @xas split leaves split folios as is without merging
  *    them back.
  *
  * After splitting, the caller's folio reference will be transferred to the
- * folio containing @page. The caller needs to unlock and/or free after-split
- * folios if necessary.
+ * folio containing @split_at. The caller needs to unlock and/or free
+ * after-split folios if necessary.
  *
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch
mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

