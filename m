Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794439877;
	b=x0hn+xpHcDtfIpam8lAPoz87T27Nj4/pes69qc9UQlzqfwNQRXFn8OzIyKbpc4CGLuNC
	 lZ+zfYe6eMJzVyFuNkQ9woth4XM63dmNi8wXWJPxliwXjO8ZlKIPg2VtfbCcCIQLG0bXw
	 j+EeGKIlFkSFw/Yh+H5IG5UznXrNrEgaM3ub/LmKFMUldaVuRlIEH1+TkTHOZqePtsUK0
	 T0EMLDY9LUepcLDgZhzLF0tSPXPgUK2G9eQ5HJZoApzvubQrOP62Vt3fWc4V+S49WrgZN
	 iDseFYLX+WQqVJfRIlqxaN6q+iGm/Faxn3NDOB0mxz1t9Aep85KCKrljDVN5Y2Wee0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794439877;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1UhdMcH3XCAcIvH1UaJ7ZA/OqL/PB5Hnpr8P7wHYceA=;
	b=3EMMDoKSVi8O2gD77rk7Cp/DG/s6aIviMSa9KV8rlphrDAcm+CJHeAeNvz8DZ0gpcSeF
	 tslmDjWHJQfy9qF1Ur56RYGB5kJryDKmrmE11z86fgP3/Umvbih8s0DaFa3xLd58rAkvK
	 pnNmYQc5S/kGYdS1PwXjVVRjWEKNfjGvoOzqy/7J02qcGQOkIGcwoT9wblp2Rjldjc0n7
	 b69Q6clmhrTCpheNq3ymD1zYAkUBxtbROZ5rWs68cUNr+cWCf9r4mLqAu+l5lVmdAVqF9
	 5NLmMzJDH7zrjXScSqsMq3+Bs2TnrfMAlq6/311sh7VO/coldiH1RKRC9Of6F/qjhoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LqhlrmmE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39FB606A324
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 23:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LqhlrmmE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441221F00A05;
	Wed, 11 Nov 2026 23:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794439876;
	bh=1UhdMcH3XCAcIvH1UaJ7ZA/OqL/PB5Hnpr8P7wHYceA=;
	h=Date:To:From:Subject;
	b=LqhlrmmEhL5Ot1DHHnVs4J+yjxApBmgCESwZVEuSMN8gS/itJILJzQMb/lOz0iczY
	 iHZV6esFAYs9Lmt7eGRUV/5heqbakRy+usri7jQA7wcGYBwtaZbgkm7lYE8TDy4YyW
	 9bHaFc4HmBR4nEf4HZDuNGvzpcqJmDVHLtcD0TUc=
Date: Wed, 11 Nov 2026 15:31:15 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,jiangwen6@xiaomi.com,
	dev.jain@arm.com,david@kernel.org,chleroy@kernel.org,catalin.marinas@arm.com,
	baohua@kernel.org,anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,
	jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix.patch added to mm-unstable branch
Message-Id: <20261111233116.441221F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Subject: mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix
Date: Wed, 11 Nov 2026 11:09:20 +0800

use an unsigned long page index in the walker

Link: https://lore.kernel.org/20261111030920.1297625-1-jiangwenxiaomi@gmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: <jiangwen6@xiaomi.com>
---

 mm/vmalloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix
+++ a/mm/vmalloc.c
@@ -557,8 +557,8 @@ void vunmap_range(unsigned long addr, un
 }
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	const unsigned long chunk_pages = 1UL << (shift - PAGE_SHIFT);
 	unsigned long pfn, size, chunk_end;
@@ -608,8 +608,8 @@ static int vmap_pages_pte_range(pmd_t *p
 }
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -646,8 +646,8 @@ static int vmap_pages_pmd_range(pud_t *p
 }
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -666,8 +666,8 @@ static int vmap_pages_pud_range(p4d_t *p
 }
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask, unsigned int shift)
+		unsigned long end, pgprot_t prot, struct page **pages,
+		unsigned long *nr, pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -696,7 +696,7 @@ static int vmap_pages_range_noflush_walk
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
-	int nr = 0;
+	unsigned long nr = 0;
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
_

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are

mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk-fix.patch

