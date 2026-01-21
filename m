Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C8E3101A5
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960053; cv=none; b=JJO9ghB+jLbDUKCjczr7ISHc6nR7O7ZKfMwV6bHhT0whbD+iTDezxkwKKLwKuqP+6evOGhnoUNyNuVdg2bnzLX3P1H/HpFsrVIuof9X/rZGisBUjg+9q7/In8jCNcPiHl/97kqI3CYJEOUwecF1YqMTAlP2DOdT+5dDrFgq4h+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960053; c=relaxed/simple;
	bh=7T7bLJCVkoDcT/2gXbPdX63CvT0NqRPfxlvrgcBiwBc=;
	h=Date:To:From:Subject:Message-Id; b=uqDW148F8A5O/Y7f7NtwwnA1wACHgzk6uzyOJjGuucP6BDaamJfx8GeyoVdQnNxzXqy1fCUH2C2Vn9qFUH3qWEktVra/EWUbl1Cg6UW+niNT9QIO5yBgEDNPC8Xbuvl6C6g57+0NQmlF7Ll2/bGeXCxgIj1FT1BwrkoLa0ukuaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y1QYxInm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y1QYxInm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37C3C16AAE;
	Wed, 21 Jan 2026 01:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960051;
	bh=7T7bLJCVkoDcT/2gXbPdX63CvT0NqRPfxlvrgcBiwBc=;
	h=Date:To:From:Subject:From;
	b=Y1QYxInmFyiOzB4ZUBVDA64mloqTEMaNyfIOdNleQELbb1CjbhgLMD/4ywrxtyHA6
	 uf+vV5PK+gJjz5wmAPqdWLFHeSXegfc0Vrvtf2wYlg956CqAERxX7z4ck+xnqqXniX
	 86BDPwfvJriGYrzuYEvk4FPlM4FDz7pfZOqzo30g=
Date: Tue, 20 Jan 2026 17:47:31 -0800
To: mm-commits@vger.kernel.org,kevin.brodsky@arm.com,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-basic-tests-for-lazy_mmu-fix-fix.patch removed from -mm tree
Message-Id: <20260121014731.B37C3C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-add-basic-tests-for-lazy_mmu-fix-fix.patch

This patch was dropped because it was folded into mm-add-basic-tests-for-lazy_mmu-fix.patch

------------------------------------------------------
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix
Date: Wed, 17 Dec 2025 21:16:14 +0530

use EXPORT_SYMBOL_IF_KUNIT()

Link: https://lkml.kernel.org/r/87a4zhkt6h.ritesh.list@gmail.com
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/hash_tlb.c |    6 +++---
 mm/tests/lazy_mmu_mode_kunit.c      |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix-fix
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -25,12 +25,12 @@
 #include <asm/tlb.h>
 #include <asm/bug.h>
 #include <asm/pte-walk.h>
-
+#include <kunit/visibility.h>
 
 #include <trace/events/thp.h>
 
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
-EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
+EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch);
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
@@ -155,7 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
 		flush_hash_range(i, local);
 	batch->index = 0;
 }
-EXPORT_SYMBOL_GPL(__flush_tlb_pending);
+EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending);
 
 void hash__tlb_flush(struct mmu_gather *tlb)
 {
--- a/mm/tests/lazy_mmu_mode_kunit.c~mm-add-basic-tests-for-lazy_mmu-fix-fix
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -69,3 +69,4 @@ kunit_test_suite(lazy_mmu_mode_test_suit
 
 MODULE_DESCRIPTION("Tests for the lazy MMU mode");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
_

Patches currently in -mm which might be from ritesh.list@gmail.com are

mm-add-basic-tests-for-lazy_mmu-fix.patch

