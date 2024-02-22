Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE016E618
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644488; cv=none; b=AQPI+lCaM8UnlhFCdAhNwATN05n5UGdOTJ45Ck9IooOQHQSbhxsbx4RzkQtP1+iy62kicWmz037GkNyofJ+igWhBQy4an8tTIV2wGN2mWNwjdvl6nGxO9DBWxHpDu8vSsCDleqWQaG2Hqky0lQUXlbrDAdDC4jq54Gy84j6B2k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644488; c=relaxed/simple;
	bh=yJYyELOwXp5ghJ6Ie3FcETpzl5WJQm37UfIL8QVMTcg=;
	h=Date:To:From:Subject:Message-Id; b=lvP5iclN1G5ayX40QMsamldqdVKPV2x1Idx/lEUGCCzsfJm7qQFpcpvKVT1irWKKaMa8mwRyUeh46NPyBqQGqsvFsaTAsMP2N6HlCgm/VwqfgumIfBgPo55oP4sK5nnIYjdY5nkUKvyFW+/KuqzWgO2VgRGmR0JrZbQiAts/jkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VSTu0ZbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSTu0ZbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21724C433C7;
	Thu, 22 Feb 2024 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644488;
	bh=yJYyELOwXp5ghJ6Ie3FcETpzl5WJQm37UfIL8QVMTcg=;
	h=Date:To:From:Subject:From;
	b=VSTu0ZbF2n8HBZqYSNJNOlRSQ0EDVItB7q7+fiW8h/4RWmwEm9a2NzZ/l5f1CImMU
	 6syPK3xzWcbyy76NQFD/MUm9ZTTRCaaeB1cMdUc8jsqcuP5x/JVWstibydxYY0/zGV
	 pFzUmwxLFzfCF7Ezns6v+Adq74SbJwW+yfSHmjmk=
Date: Thu, 22 Feb 2024 15:28:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch removed from -mm tree
Message-Id: <20240222232808.21724C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: convert pte_next_pfn() to pte_advance_pfn()
has been removed from the -mm tree.  Its filename was
     x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: x86/mm: convert pte_next_pfn() to pte_advance_pfn()
Date: Thu, 15 Feb 2024 10:31:52 +0000

Core-mm needs to be able to advance the pfn by an arbitrary amount, so
override the new pte_advance_pfn() API to do so.

Link: https://lkml.kernel.org/r/20240215103205.2607016-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

 arch/x86/include/asm/pgtable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-convert-pte_next_pfn-to-pte_advance_pfn
+++ a/arch/x86/include/asm/pgtable.h
@@ -955,13 +955,13 @@ static inline int pte_same(pte_t a, pte_
 	return a.pte == b.pte;
 }
 
-static inline pte_t pte_next_pfn(pte_t pte)
+static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
 	if (__pte_needs_invert(pte_val(pte)))
-		return __pte(pte_val(pte) - (1UL << PFN_PTE_SHIFT));
-	return __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+		return __pte(pte_val(pte) - (nr << PFN_PTE_SHIFT));
+	return __pte(pte_val(pte) + (nr << PFN_PTE_SHIFT));
 }
-#define pte_next_pfn	pte_next_pfn
+#define pte_advance_pfn	pte_advance_pfn
 
 static inline int pte_present(pte_t a)
 {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


