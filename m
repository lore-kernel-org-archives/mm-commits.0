Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D521F31ED68
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334316; cv=none; b=tY0lFWaaEfLqp1NpWK+AerfCQWmslhwLeN4ZSzbhk6KMNdwX/IXZYuy1PsOdw6Olh8E9K0nDoVr5mIy5JIxjfzJaUba/Ip8fgkgmjxmhcbWZMo/8j9453hmeJG7elm8gKYHw/D84WNSMshVy2jr7SBxi958w00rWArx68qPnfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334316; c=relaxed/simple;
	bh=DgPSS1W1j64Lag1PpagayUB/ywvLHykLu1iYBEc7cHc=;
	h=Date:To:From:Subject:Message-Id; b=Is823KvIUIw+7eGb7G4wZb57tylFjq+InIdRPMBHcK3dRPmn09NXN8sIHYEEeOq/Z8B2Zz10umy1T1yXTBTAG1Xf78CPF4ubyo+zxNZsjxnF1Hho4DzOgLT2Iav2sJcTdTdhKsyTLFHzEAhZXKQnb2mZIs48vhIMtJSgR3bH96U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0UHb9Xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0UHb9Xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F161F0089C;
	Wed,  7 Oct 2026 00:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334313;
	bh=JOgJS7h86IMipjAbwRjopLNNljzrMqNZxMVD851XJ/M=;
	h=Date:To:From:Subject;
	b=j0UHb9XpEaLIL+JN+SFPA5zEDT0es42NGa2WWyL9czyCWuFrZce+xzEbf1Tg2ApSe
	 f/qC/cTh3XBJlvHohhcQ0B4xKaZxnyGAcCkycVt/H4V3ZXO6YsMF/UEk/l4kv1/P3b
	 LgZAvCTDO9qOPXNjABkGzFDAYtpdYiELKZuuoMSA=
Date: Tue, 06 Oct 2026 17:51:52 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] parisc-mm-directly-use-generic-_clear_bad.patch removed from -mm tree
Message-Id: <20261007005153.56F161F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: parisc/mm: directly use generic [pmd|pgd]_clear_bad()
has been removed from the -mm tree.  Its filename was
     parisc-mm-directly-use-generic-_clear_bad.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: parisc/mm: directly use generic [pmd|pgd]_clear_bad()
Date: Mon, 31 Aug 2026 11:13:26 +0530

Drop [pmd|pgd]_ERROR() followed by [pmd|pgd]_clear() instances.  But
instead directly use semantically equivalent generic helpers
[pmd|pgd]_clear_bad() in unmap_uncached_[pte|pmd]() which helps in
dropping their corresponding [pmd|pgd]_ERROR() macros across the tree.

Link: https://lore.kernel.org/20260831054331.625505-5-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/parisc/kernel/pci-dma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/pci-dma.c~parisc-mm-directly-use-generic-_clear_bad
+++ a/arch/parisc/kernel/pci-dma.c
@@ -160,8 +160,7 @@ static inline void unmap_uncached_pte(pm
 	if (pmd_none(*pmd))
 		return;
 	if (pmd_bad(*pmd)) {
-		pmd_ERROR(*pmd);
-		pmd_clear(pmd);
+		pmd_clear_bad(pmd);
 		return;
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
@@ -196,8 +195,7 @@ static inline void unmap_uncached_pmd(pg
 	if (pgd_none(*dir))
 		return;
 	if (pgd_bad(*dir)) {
-		pgd_ERROR(*dir);
-		pgd_clear(dir);
+		pgd_clear_bad(dir);
 		return;
 	}
 	pmd = pmd_offset(pud_offset(p4d_offset(dir, vaddr), vaddr), vaddr);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

