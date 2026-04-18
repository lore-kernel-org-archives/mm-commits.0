Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185A03264FD
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499109; cv=none; b=aU+/ARQ4vh0jGVdpYCqrTnFUS46f1SLjI3Yk6oImcH2Xp3uKu5K+CEt+w3FYc0S0kYJuSExG1cvtn64F4McrgKS5zLF4XgoffliXWS7hh8h45f7K/bEZf2BZUMGerma3rTniwnGDJjrVPRg0iOENqac2wffzrJYuBzXaytgtFKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499109; c=relaxed/simple;
	bh=46RjvCSw1BDRBFLsSyPc4+XEXBd9jyJIwG6FpSOfHlM=;
	h=Date:To:From:Subject:Message-Id; b=bLzbIarRCPs8/Eif7DT5FkOfywiF1GhTLx6LWBqkerKSYHkO3bYa6STyczx9ktMB48XoN2T9F3/LfFVtgFcRE2KWW+jO2EQHNJB/0gUJsCMB6mUP/arf4Rtc1IK7f44ZEowNJT0AkgOfOru00eDWodE8agSkukfrF0q2sKozK48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tyeprp0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tyeprp0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1444BC19424;
	Sat, 18 Apr 2026 07:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499109;
	bh=46RjvCSw1BDRBFLsSyPc4+XEXBd9jyJIwG6FpSOfHlM=;
	h=Date:To:From:Subject:From;
	b=tyeprp0+OLg/oQwndkgs4XwApt24CpUTvHq5gDY2hM7v0EGYzCHC7UgVLg927sWpV
	 0KElSpItaAhcH1uDxBie9WebC0S+k0I9i7h6/+eQJpgoDCxc6z44Id1dVM8xrsuuJN
	 Fd2tCqLInp8nvDzUJS2HVeDjyALo/gABrgeLpMtw=
Date: Sat, 18 Apr 2026 00:58:23 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ptesarik@suse.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-fix-comment-for-section-map-alignment.patch removed from -mm tree
Message-Id: <20260418075828.1444BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: fix comment for section map alignment
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-comment-for-section-map-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: fix comment for section map alignment
Date: Thu, 2 Apr 2026 18:23:20 +0800

The comment in mmzone.h currently details exhaustive per-architecture
bit-width lists and explains alignment using min(PAGE_SHIFT,
PFN_SECTION_SHIFT).  Such details risk falling out of date over time and
may inadvertently be left un-updated.

We always expect a single section to cover full pages.  Therefore, we can
safely assume that PFN_SECTION_SHIFT is large enough to accommodate
SECTION_MAP_LAST_BIT.  We use BUILD_BUG_ON() to ensure this.

Update the comment to accurately reflect this consensus, making it clear
that we rely on a single section covering full pages.

Link: https://lore.kernel.org/20260402102320.3617578-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Tesarik <ptesarik@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-comment-for-section-map-alignment
+++ a/include/linux/mmzone.h
@@ -2068,21 +2068,16 @@ static inline struct mem_section *__nr_t
 extern size_t mem_section_usage_size(void);
 
 /*
- * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  The pointer is calculated
- * as mem_map - section_nr_to_pfn(pnum).  The result is
- * aligned to the minimum alignment of the two values:
- *   1. All mem_map arrays are page-aligned.
- *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
- *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
- *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
- *      worst combination is powerpc with 256k pages,
- *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available on all architectures.
- * However, we can exceed 6 bits on some other architectures except
- * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
- * with the worst case of 64K pages on arm64) if we make sure the
- * exceeded bit is not applicable to powerpc.
+ * We use the lower bits of the mem_map pointer to store a little bit of
+ * information. The pointer is calculated as mem_map - section_nr_to_pfn().
+ * The result is aligned to the minimum alignment of the two values:
+ *
+ * 1. All mem_map arrays are page-aligned.
+ * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits.
+ *
+ * We always expect a single section to cover full pages. Therefore,
+ * we can safely assume that PFN_SECTION_SHIFT is large enough to
+ * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
 	SECTION_MARKED_PRESENT_BIT,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


