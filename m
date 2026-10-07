Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617543148D2
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334318; cv=none; b=i+HvYh2vvwVpzlB+fA4TT/3Gy8DfHIqOZPpjeo8P6nmiWQHfVZU2UZhhAi3mpZT3KGmiovNemi3UXw6laww25C7iCD7UT/k5s9pDxqhPeWX/nkCqpUD/CjFfiF/yIiRBKnuY8iv8WBvAiUphFKo+Z84X6ukwxjNZX2lvciqRfmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334318; c=relaxed/simple;
	bh=AJQ+KUQxp45oVNTgEzEu8pkgjCKRRpRM+1wRkFZF3OU=;
	h=Date:To:From:Subject:Message-Id; b=UDvKfxY0RhiBh7+VVVheINAOrBjp1s1pSdK3+2hjIpUw1VZzqDUIhsdqOhrCCnrOs358v7ivIQdCfTZRCIH9AE0X94v8zUiHKlVwkkvEQKg+UO4TNN6r5VSOQ6Yh374xa4xquBNzFqWVbWMoTQv87bCZMUCt7LOT4Ab5vtBPO+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YkXGs2zE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YkXGs2zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6775C1F0089D;
	Wed,  7 Oct 2026 00:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334314;
	bh=riH/6vnkYl14mCSNWGdrk4GhmHHfBYm0ln7oiCdRhzY=;
	h=Date:To:From:Subject;
	b=YkXGs2zEGtdKjZUaUHzzZKeZB1SLOAeEXR8laETpSXji+P4IEdFM4nnTnZsnJRShB
	 Ka53E9aUmAkl8GjbPerIvFr8VRB7BYZwciUmApzeHo4LX+Z0FNAviFVVNab9Wm3FIx
	 rTF9JL9b4E4B6b2X+b7oba85Jw3ZMI6d52c7fU8U=
Date: Tue, 06 Oct 2026 17:51:54 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-stop-using-pte_error.patch removed from -mm tree
Message-Id: <20261007005154.6775C1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh/mm: stop using pte_ERROR()
has been removed from the -mm tree.  Its filename was
     sh-mm-stop-using-pte_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: sh/mm: stop using pte_ERROR()
Date: Mon, 31 Aug 2026 11:13:27 +0530

Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps
in eventually dropping pte_ERROR() macro across the tree.  In this new
printing __FILE__ and __LINE__ has been dropped because they are always
the same and don't really add any value.  Besides ptrval_to_str() has been
able to handle different PTE representation with and without CONFIG_X2TLB,
which helped in unifying error message printing.

Link: https://lore.kernel.org/20260831054331.625505-6-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: WANG Xuerui <kernel@xen0n.name>
---

 arch/sh/include/asm/pgtable_32.h |    5 -----
 arch/sh/mm/init.c                |    6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/sh/include/asm/pgtable_32.h~sh-mm-stop-using-pte_error
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vad
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 #ifdef CONFIG_X2TLB
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
-	       &(e), (e).pte_high, (e).pte_low)
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
 #else
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 #endif
--- a/arch/sh/mm/init.c~sh-mm-stop-using-pte_error
+++ a/arch/sh/mm/init.c
@@ -84,7 +84,11 @@ static void set_pte_phys(unsigned long a
 
 	pte = __get_pte_phys(addr);
 	if (!pte_none(*pte)) {
-		pte_ERROR(*pte);
+		char str[PTVAL_STR_MAX];
+
+		ptval_to_str(str, pte_val(*pte));
+		pr_err("unexpected set PTE at %lx in %s: bad pte %p(%s).\n",
+			addr, __func__, pte, str);
 		return;
 	}
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

