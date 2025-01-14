Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2877223D3CE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837143; cv=none; b=CeZOwrv6vrDSSU+qNpxE1jdtIdd1boTvS84HwasgjnE8pu1TlT5r6QtnWCHrc6XPkQdwNB1iwX15GZfb8RmMuW03dgCSAArGM0n4hUqVEWbEHJOxcOPUVH9PJJUODf8aVgbALpj06OLRfQxB+7tYDBgPCrJkXBvo3WTyL4LH7fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837143; c=relaxed/simple;
	bh=xXCDXMvwKpJrathdzA8ySzvb4GAPHb7cnOAR++XCG9Y=;
	h=Date:To:From:Subject:Message-Id; b=hD9paGlif87RTJ51KwGSrJSiKaK+7CoSWRHofe/k5uDQP/hn8oK7i2O3qtDA76oLDUdlCKeHZQ6EgULmBM7TBr2JuwrrRItX1k6lJahIemnkmZHNCzr4pmqLTJB/3Y5/BdKpIrEo03p9UZVu50xaFLwSSVwrprM3gUKjIMR0VCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sxaeIWtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sxaeIWtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CF6C4CEDD;
	Tue, 14 Jan 2025 06:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837142;
	bh=xXCDXMvwKpJrathdzA8ySzvb4GAPHb7cnOAR++XCG9Y=;
	h=Date:To:From:Subject:From;
	b=sxaeIWtdff1GQdiD2wlSVrkaB89DHPKNfN1RNzhJWzf8YEbJWgTJyN/EMEM3ETDQf
	 QxoyCy4ncaCGeflT5/0XdU8+dAeNWiU7MzcNrhbCZpAo+VsYj4fK0oXsgbvQZjPIdu
	 5mhOwNEAsWtUq+JzE5fjxezgtOittZO7Uej6HmAc=
Date: Mon, 13 Jan 2025 22:45:42 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mm-rename-pgd-helpers.patch removed from -mm tree
Message-Id: <20250114064542.99CF6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ARM: mm: rename PGD helpers
has been removed from the -mm tree.  Its filename was
     arm-mm-rename-pgd-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: ARM: mm: rename PGD helpers
Date: Fri, 3 Jan 2025 18:44:13 +0000

Generic implementations of __pgd_alloc and __pgd_free are about to be
introduced.  Rename the macros in arch/arm/mm/pgd.c to avoid clashes. 
While we're at it, also pass down the mm as argument to those helpers, as
it will be needed to call the generic __pgd_{alloc,free}.

Link: https://lkml.kernel.org/r/20250103184415.2744423-5-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pgd.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm/mm/pgd.c~arm-mm-rename-pgd-helpers
+++ a/arch/arm/mm/pgd.c
@@ -17,11 +17,11 @@
 #include "mm.h"
 
 #ifdef CONFIG_ARM_LPAE
-#define __pgd_alloc()	kmalloc_array(PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL)
-#define __pgd_free(pgd)	kfree(pgd)
+#define _pgd_alloc(mm)		kmalloc_array(PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL)
+#define _pgd_free(mm, pgd)	kfree(pgd)
 #else
-#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
-#define __pgd_free(pgd)	free_pages((unsigned long)pgd, 2)
+#define _pgd_alloc(mm)		(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
+#define _pgd_free(mm, pgd)	free_pages((unsigned long)pgd, 2)
 #endif
 
 /*
@@ -35,7 +35,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	pmd_t *new_pmd, *init_pmd;
 	pte_t *new_pte, *init_pte;
 
-	new_pgd = __pgd_alloc();
+	new_pgd = _pgd_alloc(mm);
 	if (!new_pgd)
 		goto no_pgd;
 
@@ -134,7 +134,7 @@ no_pmd:
 no_pud:
 	p4d_free(mm, new_p4d);
 no_p4d:
-	__pgd_free(new_pgd);
+	_pgd_free(mm, new_pgd);
 no_pgd:
 	return NULL;
 }
@@ -207,5 +207,5 @@ no_pgd:
 		p4d_free(mm, p4d);
 	}
 #endif
-	__pgd_free(pgd_base);
+	_pgd_free(mm, pgd_base);
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


