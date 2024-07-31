Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3741045BE3
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 19:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722455115; cv=none; b=DUncmZ+I5zWwbaS6mKXJxpkaMIVECINUhDG47rBV/T/eh45RBAZTByLk3+um4vD5p6e1kQ9lROxrgvv8u1Lt+ZqRVAM2SQDi8M///gRLNtVZzT+XpCArFkiNVDZw6+3kaROu54AltEPhrTh8f3w+xhmCBrkd35gRH/zjoiHs0EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722455115; c=relaxed/simple;
	bh=yllA3XDFN8aicdQcuQQXpkaep4MgYQqdTVONolH9bZM=;
	h=Date:To:From:Subject:Message-Id; b=eYeQkbNjg58YcusPU/aj13BA9h2e12TK5AifMLAy/VMSK+0IU55lOKa4GvDw5Fuhlqa2cTex6VstND8it5HbJKPjOAAne3H+Y5IT6pUXBonRYjth4RZjVZ2RJDMyPxlv6GQLedbCwdCtEBoiJl85Mkpef1b3dOSm5iwR4NK8wy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCoA8+YD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCoA8+YD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BA4C116B1;
	Wed, 31 Jul 2024 19:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722455114;
	bh=yllA3XDFN8aicdQcuQQXpkaep4MgYQqdTVONolH9bZM=;
	h=Date:To:From:Subject:From;
	b=OCoA8+YDhvR+KzUrbWulg1HtnBcy5A905WsY6U3vpLf1jCH6besYbDCnY9m7G87gq
	 mSQd4I/u6yRznvhWOsH5Ovdc1pZwFXzttUOoDYAt57DYoXX0C+9PcCRxI4tslPNwqY
	 iJOAcs1/7Vjn3ab0CwPNOwkF0WOSxd3ibYdSH3Ps=
Date: Wed, 31 Jul 2024 12:45:14 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch added to mm-unstable branch
Message-Id: <20240731194514.A0BA4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clarify folio_likely_mapped_shared() documentation for KSM folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch

This patch will later appear in the mm-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm: clarify folio_likely_mapped_shared() documentation for KSM folios
Date: Wed, 31 Jul 2024 18:07:58 +0200

For KSM folios, the function actually does what it is supposed to do: even
having multiple mappings inside the same MM is considered "sharing", as
there is no real relationship between these KSM page mappings -- in
contrast to mapping the same file range twice and having the same
pagecache page mapped twice.

Link: https://lkml.kernel.org/r/20240731160758.808925-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios
+++ a/include/linux/mm.h
@@ -2132,14 +2132,19 @@ static inline size_t folio_size(const st
  * MM ("mapped shared"), or if the folio is only mapped into a single MM
  * ("mapped exclusively").
  *
+ * For KSM folios, this function also returns "mapped shared" when a folio is
+ * mapped multiple times into the same MM, because the individual page mappings
+ * are independent.
+ *
  * As precise information is not easily available for all folios, this function
  * estimates the number of MMs ("sharers") that are currently mapping a folio
  * using the number of times the first page of the folio is currently mapped
  * into page tables.
  *
- * For small anonymous folios (except KSM folios) and anonymous hugetlb folios,
- * the return value will be exactly correct, because they can only be mapped
- * at most once into an MM, and they cannot be partially mapped.
+ * For small anonymous folios and anonymous hugetlb folios, the return
+ * value will be exactly correct: non-KSM folios can only be mapped at most once
+ * into an MM, and they cannot be partially mapped. KSM folios are
+ * considered shared even if mapped multiple times into the same MM.
  *
  * For other folios, the result can be fuzzy:
  *    #. For partially-mappable large folios (THP), the return value can wrongly
@@ -2148,9 +2153,6 @@ static inline size_t folio_size(const st
  *    #. For pagecache folios (including hugetlb), the return value can wrongly
  *       indicate "mapped shared" (false positive) when two VMAs in the same MM
  *       cover the same file range.
- *    #. For (small) KSM folios, the return value can wrongly indicate "mapped
- *       shared" (false positive), when the folio is mapped multiple times into
- *       the same MM.
  *
  * Further, this function only considers current page table mappings that
  * are tracked using the folio mapcount(s).
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch

