Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B273C1EB26
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546849; cv=none; b=ZAcbc5jf9w4pxAQNba7HnSUrZEWCIzlUoBJ3lMolsTaHRBvppjPscujr5D43gZgN9Y/Eu7gsRJ1iR2QT3OQdWE0/O/qqoZ2y8Ha2eL0bP1Vigm6XOKmlU6EuWC6PEoYZp0zU1pv/9MBvZ/VLe/aLxwa7yoYnGACK/HeGAtg565E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546849; c=relaxed/simple;
	bh=UoXpy9g1sFUMjzlgEZojWnG9i1lHjBYETBSPsAMHAI8=;
	h=Date:To:From:Subject:Message-Id; b=ZMxzQ/NDakKgzTymBSRRBQTXkHnJg5t6ncSMf3EWOIuGD1F1xxM0Yqc0QukRQUf1OMSbP890rdR2B/taEZWv8c7vlXP3GVB+yjNL4t4FQadT8d+Z6xt8k28UGvjA1X2dvhCYVnjXbe0vT5/zvdGrXvrm4wOA9a6jEZs56+msWoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxmREO9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxmREO9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CAAC433F1;
	Wed, 21 Feb 2024 20:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708546849;
	bh=UoXpy9g1sFUMjzlgEZojWnG9i1lHjBYETBSPsAMHAI8=;
	h=Date:To:From:Subject:From;
	b=fxmREO9NztjBO5NPCuGgb9cYTjSy6DIIqdIAqi3baqzMVgyVez4phHcHOSVjg0OES
	 JD7bqV4Ku6zYCN8VzYqflRNVbNmHYEvrQ/IFpINBw6WXfTpSfx7k3K1Jh7b1UKyQL9
	 vs6LDpZasQ8MC8xaOTKNy8cI/s3gb5qn1UcwsAf0=
Date: Wed, 21 Feb 2024 12:20:48 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,arnd@arndb.de,arnd@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch added to mm-unstable branch
Message-Id: <20240221202049.40CAAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: change __tlb_remove_tlb_entry() to an inline function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch

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
From: Arnd Bergmann <arnd@kernel.org>
Subject: mm/mmu_gather: change __tlb_remove_tlb_entry() to an inline function
Date: Wed, 21 Feb 2024 16:45:21 +0100


clang complains about tlb_remove_tlb_entries() not using the 'ptep' variable
when __tlb_remove_tlb_entry() is an empty macro:

include/asm-generic/tlb.h:627:10: error: parameter 'ptep' set but not used [-Werror,-Wunused-but-set-parameter]

Change it to an equivalent inline function that avoids the warning since
the compiler can see how the variable gets passed into it.

Link: https://lkml.kernel.org/r/20240221154549.2026073-1-arnd@kernel.org
Fixes: 66958b447695 ("mm/mmu_gather: add tlb_remove_tlb_entries()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-add-tlb_remove_tlb_entries-fix
+++ a/include/asm-generic/tlb.h
@@ -592,7 +592,9 @@ static inline void tlb_flush_p4d_range(s
 }
 
 #ifndef __tlb_remove_tlb_entry
-#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long address)
+{
+}
 #endif
 
 /**
_

Patches currently in -mm which might be from arnd@kernel.org are

mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch

