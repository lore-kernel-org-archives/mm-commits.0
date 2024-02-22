Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DBF224EE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644489; cv=none; b=tp/HMMOgJCnWgKYcMJ1tr17s2NL1slEb5t/pwi+780jFelS3hoNLfaX4Ng97br0Jb6I0C7YZX46ZGS0idLr0kTifN7Ns1D1aqfHfqjnmpJNXYNUdN6hvRKPHPKiZyRRZgqp2f8Bw5Ub0OVi6RHrui1ef4tth89qTFoo/JcTIk7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644489; c=relaxed/simple;
	bh=oS1jBMi5Tzdh5WI8sVt0Wk0vgNy7aaKPC7RklmTf/40=;
	h=Date:To:From:Subject:Message-Id; b=YiHkCv3rDJaE5/RNqRrUDbEqcsZqoOaKOrqyiqBCM+uyswSvn21/9g7+D2eIApIpEea+mG6cGtoW/lGgBCaoYh3jzcqUSvPbDWO2uQAlHB3+HA/NzGtiDPB0w29CwtXGLGJgFn8JebqYkrXkLAgal6Qb5qbTfWWT1ZVIgd70Mq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dHLmS/Pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dHLmS/Pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17546C433F1;
	Thu, 22 Feb 2024 23:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644489;
	bh=oS1jBMi5Tzdh5WI8sVt0Wk0vgNy7aaKPC7RklmTf/40=;
	h=Date:To:From:Subject:From;
	b=dHLmS/PiAWDPOWkyYRsbrAu/OqDVAoj7+PdN7AOGJlo0VLSLg3QX1ERnp3eKGMTZs
	 8DEeDma/FYbJ61YqZjb470L9u1ZDss7Vcybo5Z/kuS3wRgmMb2bksE8KD4RXvL41Yo
	 N6AsaGkskF358Xl1uqCLSKsnFvTMz+HtBErKLuXU=
Date: Thu, 22 Feb 2024 15:28:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tidy-up-pte_next_pfn-definition.patch removed from -mm tree
Message-Id: <20240222232809.17546C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: tidy up pte_next_pfn() definition
has been removed from the -mm tree.  Its filename was
     mm-tidy-up-pte_next_pfn-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: tidy up pte_next_pfn() definition
Date: Thu, 15 Feb 2024 10:31:53 +0000

Now that the all architecture overrides of pte_next_pfn() have been
replaced with pte_advance_pfn(), we can simplify the definition of the
generic pte_next_pfn() macro so that it is unconditionally defined.

Link: https://lkml.kernel.org/r/20240215103205.2607016-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/pgtable.h~mm-tidy-up-pte_next_pfn-definition
+++ a/include/linux/pgtable.h
@@ -212,7 +212,6 @@ static inline int pmd_dirty(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
-#ifndef pte_next_pfn
 #ifndef pte_advance_pfn
 static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
@@ -221,7 +220,6 @@ static inline pte_t pte_advance_pfn(pte_
 #endif
 
 #define pte_next_pfn(pte) pte_advance_pfn(pte, 1)
-#endif
 
 #ifndef set_ptes
 /**
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


