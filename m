Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD4432692C
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334322; cv=none; b=HXTFkk4UagyWRGKNlKJ+c6TnLh4PuKN1E8sb1I4jJEqdLnkXBfLEuza5zUdaPYR9yOiCAO6B3KlY6gllGiALIalYNw8+kTRvin+h7M9Rkr7H/h4ymUUNmc+udGY4rip3G+WU1rQmaNYCUxJ2MmCaFRXP4SrTE1M2cdUIxvkF7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334322; c=relaxed/simple;
	bh=pcBXKeYkuagzx8oFiuazGTji18fdKL585I4USENO77Y=;
	h=Date:To:From:Subject:Message-Id; b=pmVkL4SsVZyY0Ht5eOqM6ImDpv1MZEEZ5yJ6UfCGTnqj/mT/PXnObD82ItQGKu6B7lHdHlOloYGrKtlObDkh+nIwHHwERjughKqk1NH04r4W9JFwFBCxzMa8W+cOLKaDhNFJezQWXqjORP0tsAiDH9EuE4eK6uSCyzlDMJMRF5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RjcIMTDK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RjcIMTDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860731F0089F;
	Wed,  7 Oct 2026 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334316;
	bh=jrvZm1Zx/7r4XQDR3TXsSmpUrUlvPYgssXDhnfDcLAM=;
	h=Date:To:From:Subject;
	b=RjcIMTDKciKI2kVtxmHlg0TRWR/SEawQ4h2ITZoR61Z7fc2DQxYraphAa2GKCwPxa
	 5iGH55B0l14JhE5xOqvSNPIoJhQDgfABmIBbKPX+kqeODc8MIegM60OJ7WcRvnA6Ng
	 osmE6NI+lIn05P9Xhp2F92TeCll3YbjeXGZgAiic=
Date: Tue, 06 Oct 2026 17:51:56 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-stop-using-pgd_error.patch removed from -mm tree
Message-Id: <20261007005156.860731F0089F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh/mm: stop using pgd_ERROR()
has been removed from the -mm tree.  Its filename was
     sh-mm-stop-using-pgd_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: sh/mm: stop using pgd_ERROR()
Date: Mon, 31 Aug 2026 11:13:29 +0530

Stop using pgd_ERROR() in __get_pte_phys() when page table entry is
already known to be empty.

Link: https://lore.kernel.org/20260831054331.625505-8-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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

 arch/sh/mm/init.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/sh/mm/init.c~sh-mm-stop-using-pgd_error
+++ a/arch/sh/mm/init.c
@@ -52,10 +52,8 @@ static pte_t *__get_pte_phys(unsigned lo
 	pmd_t *pmd;
 
 	pgd = pgd_offset_k(addr);
-	if (pgd_none(*pgd)) {
-		pgd_ERROR(*pgd);
+	if (pgd_none(*pgd))
 		return NULL;
-	}
 
 	p4d = p4d_alloc(NULL, pgd, addr);
 	if (unlikely(!p4d)) {
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

