Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DDE3115B8
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334318; cv=none; b=Wyc/YURCzexxNH0FSJ5USs37OeV1COR45BD5Hg22DPNiLqvbb46pT4JtDgPkEwSOT58HneLAZI3ucWvBGBoXayfHx5sbftiO+lYWT32hsAH7qjNig9UNT+mWHQCnoqYd4OyiRVrLcfNBzX/wlueeFvNohbes+cJqzrm+6n9/pII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334318; c=relaxed/simple;
	bh=dQWlhtSCKF341J24WLDb5F8sKG6GLc8kuNdXfxr6omE=;
	h=Date:To:From:Subject:Message-Id; b=L6IaDAaU6YvGJZGWfndYWrMOeu6j4aZsXf9MB9LlYoJxe/IJaUW148EGkCrnJwG0XaojXRxg7yqECJi1p0cvm9Mip0SD1Sxv/MMzBPH90ZyGgwoecVDCllhqoBNZvddbe+c8vi7jztW/f21wkKDvuv0NCPkKuScUFdl8LiuLPRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BsUVAPrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BsUVAPrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479C71F0089B;
	Wed,  7 Oct 2026 00:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334312;
	bh=CgkJ36HaU7J9DRTnY1Q5tCJMScxBPC85eFc5bfLzPPE=;
	h=Date:To:From:Subject;
	b=BsUVAPrkxMCrHZMECAYtuNf9PgKrXO0VicK9s7VVGzahRetp73+GpnerDDMgF6LZ+
	 RZbNJZkYRYjC9jj/Xq1ny3T8p5p9ZChkPRc2esnV7F9zst2agvzILPor4pE7lFBfUB
	 1ubtpB1fViCVTzbRuUCvj3Bl9anrwba5N4/OWIU8=
Date: Tue, 06 Oct 2026 17:51:51 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-mm-stop-using-pte_error.patch removed from -mm tree
Message-Id: <20261007005152.479C71F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: loongarch/mm: stop using pte_ERROR()
has been removed from the -mm tree.  Its filename was
     loongarch-mm-stop-using-pte_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: loongarch/mm: stop using pte_ERROR()
Date: Mon, 31 Aug 2026 11:13:25 +0530

Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps
in eventually dropping pte_ERROR() macro across the tree.  In this new
printing __FILE__ and __LINE__ has been dropped because they are always
the same and don't really add any value.  The new ptval_to_str() helper is
being used for converting pgtable entry value into a string.  The error
message itself has been cleaned up as well.

Link: https://lore.kernel.org/20260831054331.625505-4-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/loongarch/include/asm/pgtable.h |    2 --
 arch/loongarch/mm/init.c             |    4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~loongarch-mm-stop-using-pte_error
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -135,8 +135,6 @@ struct vm_area_struct;
 #define ptep_get(ptep) READ_ONCE(*(ptep))
 #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
 
-#define pte_ERROR(e) \
-	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #ifndef __PAGETABLE_PMD_FOLDED
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
--- a/arch/loongarch/mm/init.c~loongarch-mm-stop-using-pte_error
+++ a/arch/loongarch/mm/init.c
@@ -197,13 +197,15 @@ void __init __set_fixmap(enum fixed_addr
 			       phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
+	char str[PTVAL_STR_MAX];
 	pte_t *ptep;
 
 	BUG_ON(idx <= FIX_HOLE || idx >= __end_of_fixed_addresses);
 
 	ptep = populate_kernel_pte(addr);
 	if (!pte_none(ptep_get(ptep))) {
-		pte_ERROR(*ptep);
+		ptval_to_str(str, pte_val(*ptep));
+		pr_err("unexpected set PTE at %lx in %s: %s\n", addr, __func__, str);
 		return;
 	}
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

