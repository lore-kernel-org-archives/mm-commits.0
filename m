Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD9833F362
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992318; cv=none; b=iAeeFN1Nx1kDddvRPfVK/mgfwfDi4tXEv4bDbnrfoqM26QyvSNaFZKh2olKtWWJKXShbpZx15CW/58ubeKMe5moc2ghH83I2X1ZJqjiZNTCQ0uRpzoCxcqvIeOZ5fASdgwiiMSZG7BaWSyh3NmASuKFiQMOppabvbuSLRcqrEu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992318; c=relaxed/simple;
	bh=U8A740Ty4PAPCjT97R5thNKndUjorc9NP9F4JSYygHc=;
	h=Date:To:From:Subject:Message-Id; b=ZVOX0SD+Fb9dZLPgDejUpA+9gYVbcGo+/kYVD5SR8f4jFsq3KeAc4e/vjUV75raYDu/43kYTruzvO23VzG5ZSg7RjGYuMtBLrkZJnp1I1iE8OglffjQXL41PlHlaZqeS82JaUQ9L9bCtsLVLKos5q1M/mv2wB02R4oJENRAupEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZcVXKRWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZcVXKRWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24B9C4CEF5;
	Wed, 17 Dec 2025 17:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765992317;
	bh=U8A740Ty4PAPCjT97R5thNKndUjorc9NP9F4JSYygHc=;
	h=Date:To:From:Subject:From;
	b=ZcVXKRWrDF2RlBVsQVU3qxzWLo9DRIP1/NvpxNd/lcPyXCEf4mFIsV8l3sIKTORaB
	 Qr88Ty2dIHufx4djXSSHC4K687bDDb4KXPi4fe2WYJ5b4D8ihq9P9nY4bQlyQCdwyB
	 cDQw1PML1k0TkU+O50ejvBbdms/oJGX1/PxMANiw=
Date: Wed, 17 Dec 2025 09:25:17 -0800
To: mm-commits@vger.kernel.org,kevin.brodsky@arm.com,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-basic-tests-for-lazy_mmu-fix-fix.patch added to mm-new branch
Message-Id: <20251217172517.B24B9C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-add-basic-tests-for-lazy_mmu-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-basic-tests-for-lazy_mmu-fix-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-add-basic-tests-for-lazy_mmu-fix-fix.patch

