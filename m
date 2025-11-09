Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B0D1CEAC2
	for <mm-commits@vger.kernel.org>; Sun,  9 Nov 2025 19:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762715420; cv=none; b=RbSugmGVrT9qpEP48Y2C+IUkX7ZNbmboD7VV6Y3+z509YZoN+xdShSkKhgMROhDLOry3h3F+3Uu+516gISlkmhRzdSpegNMjZIYJ64IeDa+VfjFffwlbSFpyRiosxUuxc/j1Ezrbbnz2RKveLNyTRQwJygK9LeYh9DLPSma382s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762715420; c=relaxed/simple;
	bh=S/qeWiocGkXVKoeu/4XIQuxaOIKjna5MxCcGtUAP4Jc=;
	h=Date:To:From:Subject:Message-Id; b=ImI9dlMWeRsajXFQZRMj93azMflmmOCJFxb/9ipupuJslllkrSa5/PSAspI3UDzFqdur+8VN8vwjYsKOSkdVIH0SRXBwYcCWOxuuVWyd6S55tvleqksk5aloQafl94ePXJli0Q2cOOobo0xjP9lj7cF9Nw2Ejx7O3gp8U2OYYwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DYH6wrH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYH6wrH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A8FC4CEF7;
	Sun,  9 Nov 2025 19:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762715419;
	bh=S/qeWiocGkXVKoeu/4XIQuxaOIKjna5MxCcGtUAP4Jc=;
	h=Date:To:From:Subject:From;
	b=DYH6wrH5mlq2qHNpDXdYz6ze1NEL122gW5PmtzHnDhdOrE2dKm68LrqH4TSjdaN7F
	 QJT/LH1vG/pkbv/hM/8NEuobmVr9zAMH/Io2mo4snHSBETUP603UWCai6qRoZG1tsT
	 b+k0U7SjfOZuBkcDQO+KfgN1uqR7rkd0ZdXTmvzM=
Date: Sun, 09 Nov 2025 11:10:19 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,david@kernel.org,broonie@kernel.org,b-padhi@ti.com,aishwarya.tcv@arm.com,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix.patch removed from -mm tree
Message-Id: <20251109191019.98A8FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix.patch

This patch was dropped because it was folded into mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix
Date: Mon, 3 Nov 2025 14:30:12 +0000

Handle the arch mte_zero_clear_page_tags() code issuing MTE
instructions irrespective of whether the hardware supports it.

Link: https://lkml.kernel.org/r/aQi8dA_QpXM8XqrE@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lkml.kernel.org/r/aQiu-hU3x5V5drHF@finisterre.sirena.org.uk
Tested-by: Beleswar Padhi <b-padhi@ti.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/mm/fault.c~mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio-fix
+++ a/arch/arm64/mm/fault.c
@@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_f
 
 void tag_clear_highpage(struct page *page)
 {
+	/*
+	 * Check if MTE is supported and fall back to clear_highpage().
+	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
+	 * post_alloc_hook() will invoke tag_clear_highpage().
+	 */
+	if (!system_supports_mte()) {
+		clear_highpage(page);
+		return;
+	}
+
 	/* Newly allocated page, shouldn't have been tagged yet */
 	WARN_ON_ONCE(!try_page_mte_tagging(page));
 	mte_zero_clear_page_tags(page_address(page));
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-huge_memory-initialise-the-tags-of-the-huge-zero-folio.patch

