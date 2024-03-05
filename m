Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAF5EEC6
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600539; cv=none; b=egQt1mQGZzPooig39mNCBl6Eiu3fvuvKTD1tALNQffDOxwpPcfUM974rJnJ6qOLo0BZcxPht781Pjh2jZfU6pEjOd5TkOeWvrY7nU9/YMbLj2ZxYN20pR8x7STjcWzRv1hDw6zKZ5O1LjIxnxC6vt1EmQuLdwP+AE6HwSHOXqyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600539; c=relaxed/simple;
	bh=mC0LbVxl6Q9iebXqdARoirI4RjzKZcGBS+adC7PLMCo=;
	h=Date:To:From:Subject:Message-Id; b=dsx80ELBx/0bZbMZMTgTD1sAsXgOZpJSUUB7IUyoRQw44eyjR+vnlxnNYoU3FQRPNmE8i5/NfByq9NZWdrmfFAbPqpmOjSKMzfW9l16xN1gTwkn/yhjAq04esDRmt30ZpLBvsU/9LYK2afiZsupspg5Y+SLp1SO9MHDMon/TCGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bu1zQxcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bu1zQxcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615C3C433F1;
	Tue,  5 Mar 2024 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600539;
	bh=mC0LbVxl6Q9iebXqdARoirI4RjzKZcGBS+adC7PLMCo=;
	h=Date:To:From:Subject:From;
	b=bu1zQxclEQT5QzR//OzToqnlOLoYxdAC9u2Eh30/PUKCoH7Gx3adWaXS3RsANtjbO
	 DYkUGFE3M46IARSUw4yom8tMrgsRuQWfuUBzPbe65TH3x3xFcJJ3mmKnAG+2UVECgV
	 2R7LmZSD2Kn/sOO5HbqLzq9P4msZEXHZDjCthw40=
Date: Mon, 04 Mar 2024 17:02:18 -0800
To: mm-commits@vger.kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,david@redhat.com,catalin.marinas@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch removed from -mm tree
Message-Id: <20240305010219.615C3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: improve comment in contpte_ptep_get_lockless()
has been removed from the -mm tree.  Its filename was
     arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: improve comment in contpte_ptep_get_lockless()
Date: Mon, 26 Feb 2024 12:03:21 +0000

Make clear the atmicity/consistency requirements of the API and how we
achieve them.

Link: https://lore.kernel.org/linux-mm/Zc-Tqqfksho3BHmU@arm.com/
Link: https://lkml.kernel.org/r/20240226120321.1055731-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/arm64/mm/contpte.c~arm64-mm-improve-comment-in-contpte_ptep_get_lockless
+++ a/arch/arm64/mm/contpte.c
@@ -183,16 +183,20 @@ EXPORT_SYMBOL_GPL(contpte_ptep_get);
 pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 {
 	/*
-	 * Gather access/dirty bits, which may be populated in any of the ptes
-	 * of the contig range. We may not be holding the PTL, so any contiguous
-	 * range may be unfolded/modified/refolded under our feet. Therefore we
-	 * ensure we read a _consistent_ contpte range by checking that all ptes
-	 * in the range are valid and have CONT_PTE set, that all pfns are
-	 * contiguous and that all pgprots are the same (ignoring access/dirty).
-	 * If we find a pte that is not consistent, then we must be racing with
-	 * an update so start again. If the target pte does not have CONT_PTE
-	 * set then that is considered consistent on its own because it is not
-	 * part of a contpte range.
+	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
+	 * so that it is self-consistent, without the PTL held, so we may be
+	 * racing with other threads modifying the pte. Usually a READ_ONCE()
+	 * would suffice, but for the contpte case, we also need to gather the
+	 * access and dirty bits from across all ptes in the contiguous block,
+	 * and we can't read all of those neighbouring ptes atomically, so any
+	 * contiguous range may be unfolded/modified/refolded under our feet.
+	 * Therefore we ensure we read a _consistent_ contpte range by checking
+	 * that all ptes in the range are valid and have CONT_PTE set, that all
+	 * pfns are contiguous and that all pgprots are the same (ignoring
+	 * access/dirty). If we find a pte that is not consistent, then we must
+	 * be racing with an update so start again. If the target pte does not
+	 * have CONT_PTE set then that is considered consistent on its own
+	 * because it is not part of a contpte range.
 	 */
 
 	pgprot_t orig_prot;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


