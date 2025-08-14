Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B637284B26;
	Thu, 14 Aug 2025 23:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755213850; cv=none; b=erXwn/eazwnrKmejzEaB1LeUiKjR+MXCjXih6OEQfQQ/mq0s8M1Hx7hrCn+rpBRW56q7KysHx5Keos3AkZDUAuPZvy2tbi/zR5x+7pj2uMCPg7wpWs8aHTfg/bvOB2KXRyrCtsYWl0oAq+qz97pEF7lLBR01/apG9gcgExvdeD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755213850; c=relaxed/simple;
	bh=lEKRnytuyV0fsbf1VIdHq6DpvwlPCS1o91f3/dGDAfs=;
	h=Date:To:From:Subject:Message-Id; b=RJt+G8muKMHFCzM9RwiqE1s7/33FlgzBu5FT5Yvb2+l/HLIweXCtOtPYgq0mhBF+Mh7827P9M3OEX2sMaHRMebzOcQEdbfZ8y/NSCLXpWwkyLWKqJxao0mkXH+UVThsqu4EcQ6AKWzAmTHJAFO8RXZjSe9mwO/4cORAemZFJBRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eWY/XKAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eWY/XKAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4251C4CEED;
	Thu, 14 Aug 2025 23:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755213849;
	bh=lEKRnytuyV0fsbf1VIdHq6DpvwlPCS1o91f3/dGDAfs=;
	h=Date:To:From:Subject:From;
	b=eWY/XKAomLFYy9WsQqEWyJCqWFJtQmj/d3fn+qX7ncecdGFlV1tp6ZGq3C4OONoEd
	 JI+7pJONqZB1DqKDYDRJr0zMOEg2coMG43rxhGh6XdOW9SFlOjMK+hoO6eQIu5WqZb
	 Cz7RO3nfel/6963IgHv9VYjHGyhFODii1DqPc2Es=
Date: Thu, 14 Aug 2025 16:24:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ajd@linux.ibm.com,alexghiti@rivosinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-use-an-atomic-xchg-in-pudp_huge_get_and_clear.patch added to mm-new branch
Message-Id: <20250814232409.A4251C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: use an atomic xchg in pudp_huge_get_and_clear()
has been added to the -mm mm-new branch.  Its filename is
     riscv-use-an-atomic-xchg-in-pudp_huge_get_and_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-use-an-atomic-xchg-in-pudp_huge_get_and_clear.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: riscv: use an atomic xchg in pudp_huge_get_and_clear()
Date: Thu, 14 Aug 2025 12:06:14 +0000

Make sure we return the right pud value and not a value that could have
been overwritten in between by a different core.

Link: https://lkml.kernel.org/r/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com
Fixes: c3cc2a4a3a23 ("riscv: Add support for PUD THP")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/riscv/include/asm/pgtable.h~riscv-use-an-atomic-xchg-in-pudp_huge_get_and_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -942,6 +942,17 @@ static inline int pudp_test_and_clear_yo
 	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
 }
 
+#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address, pud_t *pudp)
+{
+	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
+
+	page_table_check_pud_clear(mm, pud);
+
+	return pud;
+}
+
 static inline int pud_young(pud_t pud)
 {
 	return pte_young(pud_pte(pud));
_

Patches currently in -mm which might be from alexghiti@rivosinc.com are

selftests-damon-fix-damon-selftests-by-installing-_commonsh.patch
riscv-use-an-atomic-xchg-in-pudp_huge_get_and_clear.patch

