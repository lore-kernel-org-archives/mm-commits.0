Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5776317BD8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644487; cv=none; b=W15ziCTEbBL/0GBAbSCeVVQy2bko3WQGUPsw3KNI/n/vmseDYaxVUo2rCf8o3ks+vUchN9QjrdL0zd/dv+1nuto5YHY9dwAmqLwWERSXlY4U8ujnPMO3296Y5vlu7QTkpaS3kzvsTRtCmgzU3DfyOfJDlEJTSg/46anGHa2zuhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644487; c=relaxed/simple;
	bh=BmuSUQoqSilE6zkW2MX94R9/oMuyypy4nq9vVrCuhlA=;
	h=Date:To:From:Subject:Message-Id; b=VfTCSM8K4udGGfoVDQ7Za+9yo3cCA7+rYEmqefwIxeiDLh9fc5eFV8JGwV51LX2540VQWHjfaj5oP3ImDWqfjPMZcvTlXkIJWBg+DaX05CK5T8uJhDnMoh6bYRaizEM5SmBdfgVB0V9XXJaSE8v6iE/vEVoN0gLVtaQSspYmaGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AaVuFFb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AaVuFFb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AF7C433F1;
	Thu, 22 Feb 2024 23:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644487;
	bh=BmuSUQoqSilE6zkW2MX94R9/oMuyypy4nq9vVrCuhlA=;
	h=Date:To:From:Subject:From;
	b=AaVuFFb3MXa7MM6a48ASajuXZNxI6DOj61mZ1NOf4NBsP7aTgQ0yx/bhPt8rqnQ07
	 kev9yvtwybuPA+B1wmVHCKx34RVUnhE+NG9ChES+QFIWP1O0p5RgH90W+gR41qsDwB
	 jRKRp3rI4wY8OWp0FS0sEbvmwBvijzp4A8ldaBYo=
Date: Thu, 22 Feb 2024 15:28:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch removed from -mm tree
Message-Id: <20240222232807.20AF7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: convert pte_next_pfn() to pte_advance_pfn()
has been removed from the -mm tree.  Its filename was
     arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: convert pte_next_pfn() to pte_advance_pfn()
Date: Thu, 15 Feb 2024 10:31:51 +0000

Core-mm needs to be able to advance the pfn by an arbitrary amount, so
override the new pte_advance_pfn() API to do so.

Link: https://lkml.kernel.org/r/20240215103205.2607016-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn
+++ a/arch/arm64/include/asm/pgtable.h
@@ -351,10 +351,10 @@ static inline pgprot_t pte_pgprot(pte_t
 	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
 }
 
-#define pte_next_pfn pte_next_pfn
-static inline pte_t pte_next_pfn(pte_t pte)
+#define pte_advance_pfn pte_advance_pfn
+static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
-	return pfn_pte(pte_pfn(pte) + 1, pte_pgprot(pte));
+	return pfn_pte(pte_pfn(pte) + nr, pte_pgprot(pte));
 }
 
 static inline void set_ptes(struct mm_struct *mm,
@@ -370,7 +370,7 @@ static inline void set_ptes(struct mm_st
 		if (--nr == 0)
 			break;
 		ptep++;
-		pte = pte_next_pfn(pte);
+		pte = pte_advance_pfn(pte, 1);
 	}
 }
 #define set_ptes set_ptes
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


