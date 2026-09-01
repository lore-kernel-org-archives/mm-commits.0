Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201B63CB544
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227759; cv=none; b=JKlan9vCZGEhd9P25ycA4Elf7jkCYl+vMGcSVtEmwxiiQwu6wzfdAqs7PXESBX/30O45PysQ3vHDGGaFWFfRSEPL8f7vm2B/S19u/vCJ8QFE4ZWT5rcwf7llZEmJNRS2aSUCHPOtjkJ64mGJrLxN/SptJd6fCXHYTTBqzEuKThM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227759; c=relaxed/simple;
	bh=51R+K8a/huSVHR6EM3+jy1LnnFTW9SKmbp+qVzzSwrs=;
	h=Date:To:From:Subject:Message-Id; b=bVA3ihZj/rXo9nf12mG3D9+fs9DJw1hdyEz0agQSdw7nUl0jK1EyH7QxCPhXD0H0++Hy6FM8ZaMvCAwNHPu4f2cWZqGHe7Ly4q3o0YKF/jlllO/8ekN0b1MZ1jiXLBQ/2RreqhMfbRfqXgUaBsMt+Zh1dyWiDZxXdTgzsWUbvSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tL7ZPHtk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tL7ZPHtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BF91F00A3F;
	Tue,  1 Sep 2026 01:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227741;
	bh=7gZ4l0XlOin3fnVgUNLGiMJ821qwD+FvBJWCjZRabgg=;
	h=Date:To:From:Subject;
	b=tL7ZPHtkhxwcLt7UMQxMo+uW/+DV7sqeqWGMG2UAITdqlweY56iIEN/RsUWrh8OGe
	 7by5iS1COdmNxtLZPTaKIsF6j32R/DiBlyyJi88FR2Irr0xMmbqGbspg+uwEZg7nA1
	 cEuu5wrkq1+QO7TJ4kHjjsANcps+ynVH2ZwL8jZA=
Date: Mon, 31 Aug 2026 18:55:40 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-stop-using-pxd_error.patch added to mm-new branch
Message-Id: <20260901015541.11BF91F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: stop using pxd_ERROR()
has been added to the -mm mm-new branch.  Its filename is
     mm-stop-using-pxd_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-stop-using-pxd_error.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-make-ptval_to_str-generally-available.patch
mm-stop-using-pxd_error.patch
loongarch-mm-stop-using-pte_error.patch
parisc-mm-directly-use-generic-_clear_bad.patch
sh-mm-stop-using-pte_error.patch
sh-mm-stop-using-_error.patch
sh-mm-stop-using-pgd_error.patch
mm-drop-pxd_error.patch

