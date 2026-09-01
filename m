Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD363EFD2D
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227756; cv=none; b=LPvCtomtqkXuonWhny3gH/0m7y6hUZQv8nRyrndQyTNjEBSeku+t8tH77kmzikP5ZnDlQJ7bs/LD5iHgR+wttY9fFi+OMSn9SwqIvHKlgu9J/69kcbc+/+aLkx7OUNNhmWBzhIsQyz7TUBO56m4+J5F8xdbxYq8VlIGrgoindXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227756; c=relaxed/simple;
	bh=gmOLPl1EnxhXU8CsAwBsAKUl5IvIUt2gLOznSg9DMsg=;
	h=Date:To:From:Subject:Message-Id; b=WVzDTcBTT+5r7gI6Rq43ollQkvpG34qp8nesv0gQEs01ccfCFocilcFzlDvi16qqV9hNPDh/1YicBGAbtRJ6zkcwF9a81T3fCe+6A2BAYzsGg8j+k81/u3LurQDSHD14uxAr0VbMIZxULymlO9aEEu7jnRlbMal4uhxWijO6ftQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2U4jxUfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2U4jxUfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD271F00A3D;
	Tue,  1 Sep 2026 01:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227743;
	bh=Uhq7gaZN24GoVpF3bCLbSnS1EfnmyjogHGdrDkUehSg=;
	h=Date:To:From:Subject;
	b=2U4jxUfoJR+egZWBhOvAtQ79RUkA9zZiGcd5+3s446mzbS7eVCqK+x7GnHQFCIGZo
	 15a3wvDr8wzUf/QQ6vFp1w5P7sGnAPeJtP/3AJNHQ2LdI0ZTSWJ4ohQrxJx32tpEKG
	 JNFC73JbQOkZv1fakwnnJEPHyi4Gmva4pahPwQAI=
Date: Mon, 31 Aug 2026 18:55:42 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-mm-stop-using-pte_error.patch added to mm-new branch
Message-Id: <20260901015543.2CD271F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: loongarch/mm: stop using pte_ERROR()
has been added to the -mm mm-new branch.  Its filename is
     loongarch-mm-stop-using-pte_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-mm-stop-using-pte_error.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-make-ptval_to_str-generally-available.patch
mm-stop-using-pxd_error.patch
loongarch-mm-stop-using-pte_error.patch
parisc-mm-directly-use-generic-_clear_bad.patch
sh-mm-stop-using-pte_error.patch
sh-mm-stop-using-_error.patch
sh-mm-stop-using-pgd_error.patch
mm-drop-pxd_error.patch

