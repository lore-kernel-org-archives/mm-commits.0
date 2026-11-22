Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795378175;
	b=mSlsDdQmK89mGw8KvT4XIFa+SgTRH5Zzcz76vJGIltcT8PJjUTnpHeZePF+nWFXkeAIi
	 NDP8O7sEBEiGZWYQaIBITKxBA+J8B/g1kGTplTdbYMGN4A1j+Yu/epqK0uzhvAJHoNxg/
	 JGa9ArJ/LN30ZcUFxfFX7DlEQxjgktv8QFmziVABsEhlj48D45apBos4+qkKiWHFFjEHw
	 6xKNmu+x4qAzjbLwva7bKC+IOkLkjY6r89BcmhhxkkYtZDXRotszXKkdEofkgmgWrPJoZ
	 fuQearaNaZUYxMFgbwENYpN8UNe5U2RkauGiC5Im54IPEkhT09Uo8PPsJW/Nn2cCh6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795378175;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=zEHqd69/UC40KId7pTznysj27vr2rcio0JNQNMxgZqU=;
	b=c+QaYE0ppIgh9bWYCUVZyV/u9I8c7klLkyscvjfRlokCP33mi3BOGqlJs3XiPTeFVo8F
	 1bFmyzipZOs8mCC2TvH/SoCL7pHCFazfy/pvbcn1aHdDmpHvwWxP7xt0nirjLo8LL7E2W
	 6huEV81+ziP1G6n9lGB18fIqFK9wJhi+yrrXgtqLWKeHuesy1kGPC62RHHsDyvq7crxg5
	 SoSYlQYgmZnD7s4A4IJOjcDWpW3TmJkxpNik2+THs6q+k7Bhie9JhfiCMVb4WHHaiOm/X
	 5o/KxIvwlo0uky611rbilnsDgTtflRoapJR6jf0FM/GOolqFtGbxvDY+CjKG+z+8Q5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lg7PVyHj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5923606A31A
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 20:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lg7PVyHj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E721F000C6;
	Sun, 22 Nov 2026 20:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795378174;
	bh=zEHqd69/UC40KId7pTznysj27vr2rcio0JNQNMxgZqU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=lg7PVyHjHAvuQoeQWAXNpa7a3YNm+J9fVfuheFwbCCEJkAxqqHfBY3OkYr0vkjtft
	 nci71wN3ign508nhYzoPp9y/a5evgPaYMAbosCunACGvWiwz+WVVpTDXFm15K98oUN
	 wOEFI/5+Kyfwg8isFB0ZMnDr9bz7GikWBN3WuCc0=
Date: Sun, 22 Nov 2026 12:09:34 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <45997a78-95bd-4e50-b433-f64237f9ec1a@kernel.org>
References: <45997a78-95bd-4e50-b433-f64237f9ec1a@kernel.org>
Subject: + mm-hugetlb-account-temporary-folios-separately-fix.patch added to mm-unstable branch
Message-Id: <20261122200934.C4E721F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-hugetlb-account-temporary-folios-separately-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-account-temporary-folios-separately-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-account-temporary-folios-separately-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm-hugetlb-account-temporary-folios-separately-fix
Date: Sun, 22 Nov 2026 19:21:43 +0100

In combination with

	mm/hugetlb: preserve persistent flags when returning folios to the pool

This results in an issue during boot.

This fix is required.

Link: https://patch.msgid.link/45997a78-95bd-4e50-b433-f64237f9ec1a@kernel.org
Signed-off-by: "David Hildenbrand (Arm)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-account-temporary-folios-separately-fix
+++ a/mm/hugetlb.c
@@ -1792,8 +1792,8 @@ void free_huge_folio(struct folio *folio
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
-		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
+		folio_clear_hugetlb_temporary(folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else if (h->surplus_huge_pages_node[nid]) {
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
hugetlbfs-fix-integer-overflow-in-fallocate.patch
mm-hugetlb-fix-mremap-racing-with-page-migration.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch

