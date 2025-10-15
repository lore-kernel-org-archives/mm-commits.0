Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9146744C63
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760486596; cv=none; b=fyIpzp2bZTWa4G26gKm3+c7d0z1QVp3xyq2e0Gik0JfYoR+xVR1h1/bJ5vQqIGbin/9WYf+1iwSeH2I8TLkxg5i5a6am4WjHIf2w42BUyNlGUe/FMXq43RbMB5YptiPL6y/YxJ1nHqMVdcsBBMHDTC93r4B4AiH0qDn42XGrGkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760486596; c=relaxed/simple;
	bh=d8XNH/Dp0sznku8DRnkWPWl6LlYez06MFs2eP7vzgkk=;
	h=Date:To:From:Subject:Message-Id; b=RZGYTHt++Ap5Xlol8JHKzW6nb8KxYq0DDKbtLjDGpPTcgbQ7Hdm6UQw3CafoD3nF4o0m53Wjs68wWpzQxKQBgnjKJjdLez+70Aarkrn4ppoIfc42Jg9TNEgTw8zu6H1e9LoeMgkEoTUyq6qRd0meWujykE+zJR9Sdp3BaQNUW0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=neopJ72H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="neopJ72H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F100DC4CEE7;
	Wed, 15 Oct 2025 00:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760486596;
	bh=d8XNH/Dp0sznku8DRnkWPWl6LlYez06MFs2eP7vzgkk=;
	h=Date:To:From:Subject:From;
	b=neopJ72HVPYYt/q++Y5OHDAMls+Megc5aTQ99ur6yy1vNVLj6iTM/BtHshBIvzl9a
	 zz3/Le3X023NQ6MXKYDBPKq5ELkMnYnrOS53zwrpmDsOB8P7Bd+DaVtTZWQMEE4PoR
	 bG3b1PMe8ctu9zrmGE25GNhCn3OKc2F/R4nY+ObE=
Date: Tue, 14 Oct 2025 17:03:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch added to mm-new branch
Message-Id: <20251015000315.F100DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: Optimize old_order derivation during folio splitting
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: Optimize old_order derivation during folio splitting
Date: Tue, 14 Oct 2025 13:46:05 +0000

Folio splitting requires both the folio's original order (@old_order) and
the new target order (@split_order).

In the current implementation, @old_order is repeatedly retrieved using
folio_order().

However, for every iteration after the first, the folio being split is the
result of the previous split, meaning its order is already known to be
equal to the previous iteration's @split_order.

This commit optimizes the logic:

  * Instead of calling folio_order(), we now set @old_order directly to
    the value of @split_order from the previous iteration.

  * The initial @split_order (which was previously handled by a separate
    @start_order variable) is now directly used, and the redundant
    @start_order variable is removed.

This change avoids unnecessary function calls and simplifies the loop
setup.

Link: https://lkml.kernel.org/r/20251014134606.22543-5-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-optimize-old_order-derivation-during-folio-splitting
+++ a/mm/huge_memory.c
@@ -3528,8 +3528,7 @@ static int __split_unmapped_folio(struct
 		struct address_space *mapping, bool uniform_split)
 {
 	bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
+	int old_order = folio_order(folio);
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3538,10 +3537,9 @@ static int __split_unmapped_folio(struct
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
 	 */
-	for (split_order = start_order;
+	for (split_order = uniform_split ? new_order : old_order - 1;
 	     split_order >= new_order;
 	     split_order--) {
-		int old_order = folio_order(folio);
 		int new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
@@ -3576,6 +3574,7 @@ static int __split_unmapped_folio(struct
 			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
 		}
 		folio = page_folio(split_at);
+		old_order = split_order;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-cache-folio-attribute-in-__split_unmapped_folio.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-remove-redundant-split_order-=-new_order-check-in-uniform_split.patch

