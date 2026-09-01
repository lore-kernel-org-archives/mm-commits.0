Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390703E3C73
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227763; cv=none; b=gX2lO9eR3lf8KoVA6Np5YS+osmPFvwSE8HlUAwqIJngbBPRH4Lk0FYOkS0ygEIpHI2w2n9CbS5d+RqYj+//DMCML4dnZLCZ1nTmiKotBfwRhWgYSEVc17NRIbq2vH8x4uZxIpMndJBD7+bKAy/A9Rw8A2J57fjwEUQOez7fYH4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227763; c=relaxed/simple;
	bh=uYJ40luOh2u6h21cdFjNeIsbYvBTGXJfvhh/Z7x/7do=;
	h=Date:To:From:Subject:Message-Id; b=l6hZhQANHihuUJoG9SJVnkJaFgH8fqfDsyqb2ZCB5mV+wg6nyimR/GYhN8BUeMmbtcGH8ZIIcpZzVefY/PJZehoL6KJDsiqGz/ca3bhENA55Ls8YdQPtEvdCu+ROTnllUFb6lIfbgbaZ6FIzlOnKdr09djJMT9z63xQRgam+kHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UoF+tHPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UoF+tHPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCDC1F00ACA;
	Tue,  1 Sep 2026 01:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227745;
	bh=mInybQxtu3y3uUHUBd0+0QXmOTEM4awZMcRSWKERW8Y=;
	h=Date:To:From:Subject;
	b=UoF+tHPvNH7v05CtU640M9y2rg37vDWs/cjxzTCfKR0bZKrSSgQKCta2x4EK9Sh17
	 yUn7yvDe1lUdq95xkO2Tt4popJ8ArUiMTvX0wyIO+y7Tl9e5xzWBd52ImgD7wihlHZ
	 AwhDfEabE7EWd54WGWLPqCiENzcBopDqr+a1lGzo=
Date: Mon, 31 Aug 2026 18:55:45 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-mm-directly-use-generic-_clear_bad.patch added to mm-new branch
Message-Id: <20260901015545.ADCDC1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: parisc/mm: directly use generic [pmd|pgd]_clear_bad()
has been added to the -mm mm-new branch.  Its filename is
     parisc-mm-directly-use-generic-_clear_bad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-mm-directly-use-generic-_clear_bad.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: parisc/mm: directly use generic [pmd|pgd]_clear_bad()
Date: Mon, 31 Aug 2026 11:13:26 +0530

Drop [pmd|pgd]_ERROR() followed by [pmd|pgd]_clear() instances.  But
instead directly use semantically equivalent generic helpers
[pmd|pgd]_clear_bad() in unmap_uncached_[pte|pmd]() which helps in
dropping their corresponding [pmd|pgd]_ERROR() macros across the tree.

Link: https://lore.kernel.org/20260831054331.625505-5-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-make-ptval_to_str-generally-available.patch
mm-stop-using-pxd_error.patch
loongarch-mm-stop-using-pte_error.patch
parisc-mm-directly-use-generic-_clear_bad.patch
sh-mm-stop-using-pte_error.patch
sh-mm-stop-using-_error.patch
sh-mm-stop-using-pgd_error.patch
mm-drop-pxd_error.patch

