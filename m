Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E1E2BD5B4
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801500; cv=none; b=JbxYuAPYD395Ws07gRb33y/bzAjM2r/NI2OpRiwu2dDmsGHBkM22hqe9bO0bEzN26Hx+bItl5641WVs/dCNOFR/3XajKA92ymPz55XnUKNFpqK1ehWezkqZ/qbQonjX0wQEb6lfDI85Z1lbEZWA1etKa4GCbgtFGxjtoLCTzpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801500; c=relaxed/simple;
	bh=ni+/yGaonTaxvZ9X/sOU2Ptow4BYWS0/l8KuGv7YZ6w=;
	h=Date:To:From:Subject:Message-Id; b=jJZNAJk9b9xXLCbIspzt5d1VUi4Gcrxxn3Pni/xpA9xOIrMbwPir/jbf76Hl2IdjCzFSmQvBBlLUVgQCwOwjEHuowbuRzQ2nISP6vyZTIzpQEZJJpbiFKHqxdqtvqoysvMJrj8LTFhCDNhP57AfJpG7kzEqffKEYj1TmSXI4wow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=150jj96I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="150jj96I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE06C4CEEB;
	Sat, 13 Sep 2025 22:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801500;
	bh=ni+/yGaonTaxvZ9X/sOU2Ptow4BYWS0/l8KuGv7YZ6w=;
	h=Date:To:From:Subject:From;
	b=150jj96ImsqdIyMFAsPRUIm3vAhE8IqU66H0ePeX2v3g9TTzG19gSw+qaY8IegX9e
	 nEPS6nxOG3of22++yTIkU2YA2013LalSO22y6LNAXwrC1xu+UAhT33NV2KGNmiaQpE
	 aCCzW/FlNxZ0CALd3mzRe0sbxEEqXGncPV2wnYKQ=
Date: Sat, 13 Sep 2025 15:11:39 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch removed from -mm tree
Message-Id: <20250913221140.2BE06C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: always inline __folio_rmap_sanity_checks()
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch

This patch was dropped because it was folded into mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/rmap: always inline __folio_rmap_sanity_checks()
Date: Thu, 14 Aug 2025 13:05:22 -0700

Commit 5e901e249ad1 ("mm/rmap: convert "enum rmap_level" to "enum
pgtable_level"") changed VM_WARN_ON_ONCE, a run time warning, into
BUILD_BUG, a compile time error. After this adjustment, certain builds
with older versions of clang (such as arm64 allmodconfig) started
failing to build with:

  In file included from mm/rmap.c:63:
  In file included from include/linux/ksm.h:14:
  include/linux/rmap.h:440:3: error: call to __compiletime_assert_890 declared with 'error' attribute: BUILD_BUG failed
                  BUILD_BUG();
                  ^
  ...
  <scratch space>:21:1: note: expanded from here
  __compiletime_assert_890
  ^

While __folio_rmap_sanity_checks() is marked 'inline', the compiler may
not always honor it, such as when sanitizers or other instrumentation is
enabled.  If __folio_rmap_sanity_checks() is not inlined, there is no
way the compiler can eliminate the default cause.

Mark __folio_rmap_sanity_checks() as __always_inline to allow the
BUILD_BUG() to work consistently, which clears up the error.

Link: https://lkml.kernel.org/r/20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix
+++ a/include/linux/rmap.h
@@ -394,7 +394,7 @@ typedef int __bitwise rmap_t;
 /* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
-static inline void __folio_rmap_sanity_checks(const struct folio *folio,
+static __always_inline void __folio_rmap_sanity_checks(const struct folio *folio,
 		const struct page *page, int nr_pages, enum pgtable_level level)
 {
 	/* hugetlb folios are handled separately. */
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch

