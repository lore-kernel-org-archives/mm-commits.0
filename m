Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E41A312837
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334312; cv=none; b=XF8QZqAIeay6shxK/qJc0OeFgI2L1skdkvmouF00RIwcB5xYQkOthOt+JChlbwSp12EeQpjepy23ypEi4cdQA7capNHP7ZM7Bfchir2aY08pXyiHrZJRZ4/WxadjkfSBK0hF86JPyP4Vk9OEqh+gj2kt3W8NjBWhCDTd3UP0+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334312; c=relaxed/simple;
	bh=hAQW7m7gFpz+BLozddHJXGjbJdyOC8qtFZgGVFdMT2U=;
	h=Date:To:From:Subject:Message-Id; b=cwyD8QCwo5r8KoQDUssVejrr63eVA8qlPsPhjWbiXSA+DRn75+hif1SyXTZmGrZNVMTcvQ3mS4u9NJ6blePqeZMaUmqroSgiceSrgZpKSj1I7Ci8y6wnVn27NnukhoKDOBp8fnmoJC4gfZvqX0V2LIgySRV7r6Y9tYofpoti1Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kDYgvd3F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kDYgvd3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355FD1F0089C;
	Wed,  7 Oct 2026 00:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334311;
	bh=NpOwW552zw+BBAnyhkVMIpan4IgxAJC6jhb/mN3jB/w=;
	h=Date:To:From:Subject;
	b=kDYgvd3F/onxZwcScoJUFZi3EWY80gZdYQ9lFX5jqBvY/0udyUgJsnjwt6rZn9hHa
	 rbcei1kCmzpmsLoOUv0w91QffIhC3rHeOZkQe36SWgAgeUsGq7Ptcb9XLZLLeQE5xS
	 nf42Z3UyNihYSatNrMTTzax4Ee7z6YNpfpB7WGOk=
Date: Tue, 06 Oct 2026 17:51:50 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-stop-using-pxd_error.patch removed from -mm tree
Message-Id: <20261007005151.355FD1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: stop using pxd_ERROR()
has been removed from the -mm tree.  Its filename was
     mm-stop-using-pxd_error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: stop using pxd_ERROR()
Date: Mon, 31 Aug 2026 11:13:24 +0530

pxd_ERROR() has been used in generic mm just to print the page table entry
in pxd_clear_bad() before clearing those out with pxd_clear() later. 
These pxd_ERROR() macros have been provided by all platforms which
basically did the same thing.

Make pxd_clear_bad() use recently added ptval_to_str() instead for
printing page table entries thus completely dropping dependency on
platform provided pxd_ERROR() macros which can then be dropped off later
on.

Link: https://lore.kernel.org/20260831054331.625505-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 mm/pgtable-generic.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/pgtable-generic.c~mm-stop-using-pxd_error
+++ a/mm/pgtable-generic.c
@@ -26,14 +26,20 @@
 
 void pgd_clear_bad(pgd_t *pgd)
 {
-	pgd_ERROR(*pgd);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, pgd_val(*pgd));
+	pr_err("bad pgd %s.\n", str);
 	pgd_clear(pgd);
 }
 
 #ifndef __PAGETABLE_P4D_FOLDED
 void p4d_clear_bad(p4d_t *p4d)
 {
-	p4d_ERROR(*p4d);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, p4d_val(*p4d));
+	pr_err("bad p4d %s.\n", str);
 	p4d_clear(p4d);
 }
 #endif
@@ -41,7 +47,10 @@ void p4d_clear_bad(p4d_t *p4d)
 #ifndef __PAGETABLE_PUD_FOLDED
 void pud_clear_bad(pud_t *pud)
 {
-	pud_ERROR(*pud);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, pud_val(*pud));
+	pr_err("bad pud %s.\n", str);
 	pud_clear(pud);
 }
 #endif
@@ -53,7 +62,10 @@ void pud_clear_bad(pud_t *pud)
  */
 void pmd_clear_bad(pmd_t *pmd)
 {
-	pmd_ERROR(*pmd);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, pmd_val(*pmd));
+	pr_err("bad pmd %s.\n", str);
 	pmd_clear(pmd);
 }
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

