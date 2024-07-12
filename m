Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F78127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824867; cv=none; b=HKNjPD+WW1zT/Mt6ag8PGD6azVgdDn3gOVZCxgPW7JsruSyXWEfPpgUne/arvKNLNjIRfXAUtevu7C+3DnrLXaOXkqK83St5AkPLyHmTMR/5qR7AwW7+ZE8vyi1UM9CKU/LZsZ4PXyrSUN/gFp2VmagqPOHCEWotdZNA3f6gWvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824867; c=relaxed/simple;
	bh=9pV1wiXE7bxA2ThzQe2haLSUHgHjZyO6ENOgMZUAfP8=;
	h=Date:To:From:Subject:Message-Id; b=bPR8SpkmVrsmXgFPnFY+uaq6GG9A3FZuFBg8sPc8MGEgy51+JPoNCS2I153ZTsWc7D2dnq6IB6+FxjV5YGyoddmM4uvXCp6jXA7ktJLBaEJDvgUTNdsTjD8NZYDpl9Af2Q3xGrptpBQYW3CWewTtoTid0Sk3YH/PRKJnKXeGWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nybQ6Unm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nybQ6Unm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC31AC32782;
	Fri, 12 Jul 2024 22:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824866;
	bh=9pV1wiXE7bxA2ThzQe2haLSUHgHjZyO6ENOgMZUAfP8=;
	h=Date:To:From:Subject:From;
	b=nybQ6Unmr75MDPZCgTi0/DY6NhVKrfPQUzghtjNN1g1bma9jpqmboUZuVYLxo/GjD
	 5FZykyipQW1P1kN/LQ04kXyTtE/l8JEV8EQbpEZGlSOT4Lu2sIrnt/6QeT64w7Luov
	 ir+FSKHWo+elCEMWy/3ahkWx/MpvVsgsrMuZX/7o=
Date: Fri, 12 Jul 2024 15:54:26 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch removed from -mm tree
Message-Id: <20240712225426.BC31AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: define __pte_leaf_size() to also take a PMD entry
has been removed from the -mm tree.  Its filename was
     mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: define __pte_leaf_size() to also take a PMD entry
Date: Tue, 2 Jul 2024 15:51:19 +0200

On powerpc 8xx, when a page is 8M size, the information is in the PMD
entry.  So allow architectures to provide __pte_leaf_size() instead of
pte_leaf_size() and provide the PMD entry to that function.

When __pte_leaf_size() is not defined, define it as a pte_leaf_size() so
that architectures not interested in the PMD arguments are not impacted.

Only define a default pte_leaf_size() when __pte_leaf_size() is not
defined to make sure nobody adds new calls to pte_leaf_size() in the core.

Link: https://lkml.kernel.org/r/c7c008f0a314bf8029ad7288fdc908db1ec7e449.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    3 +++
 kernel/events/core.c    |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-define-__pte_leaf_size-to-also-take-a-pmd-entry
+++ a/include/linux/pgtable.h
@@ -1907,9 +1907,12 @@ typedef unsigned int pgtbl_mod_mask;
 #ifndef pmd_leaf_size
 #define pmd_leaf_size(x) PMD_SIZE
 #endif
+#ifndef __pte_leaf_size
 #ifndef pte_leaf_size
 #define pte_leaf_size(x) PAGE_SIZE
 #endif
+#define __pte_leaf_size(x,y) pte_leaf_size(y)
+#endif
 
 /*
  * We always define pmd_pfn for all archs as it's used in lots of generic
--- a/kernel/events/core.c~mm-define-__pte_leaf_size-to-also-take-a-pmd-entry
+++ a/kernel/events/core.c
@@ -7609,7 +7609,7 @@ again:
 
 	pte = ptep_get_lockless(ptep);
 	if (pte_present(pte))
-		size = pte_leaf_size(pte);
+		size = __pte_leaf_size(pmd, pte);
 	pte_unmap(ptep);
 #endif /* CONFIG_HAVE_GUP_FAST */
 
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


