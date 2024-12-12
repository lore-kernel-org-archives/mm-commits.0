Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704AFA2D
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733962385; cv=none; b=c64jKNeJkH/DgQUCf7JJ9ukhJtYQq2iXAvpvpv9DbqSWLguwgl2cpiAAkuoH4jQTb3nKxha9iLBy/e/W+TgePidpHhlNg7E6uaHgcdFRX6AugcGadl8Kl8OV3VPSkA9R7HiSkNrW5CX0/VfqUC7LAoc3NUq6ffB3rFgcY5iL2Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733962385; c=relaxed/simple;
	bh=PmLHgG+EqJ4WWrSeb/EP8ZIcXNJOuMqJU/D0ZdiS8ZQ=;
	h=Date:To:From:Subject:Message-Id; b=FvXHalkt25fkimnVuVoYgadpEAaWrpq7L/TITrATj9oxymX/24GCTmcdqaNpy4/950Y5vuQhSwBEtkC2GwpI/leIxZjj65jkegQ+vafhB//JkMzwbBEfV+Wifo/+k6adEFHpyFLmOP6ihItzhizYWKk/XrXKz4L0u4X7eFEySnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xxayJv8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xxayJv8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE421C4CED2;
	Thu, 12 Dec 2024 00:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733962385;
	bh=PmLHgG+EqJ4WWrSeb/EP8ZIcXNJOuMqJU/D0ZdiS8ZQ=;
	h=Date:To:From:Subject:From;
	b=xxayJv8MacrITI6GsY3/IW4uBYAjALTkMiFRYpaNiC/5cHBCcV0GvwyakibpnsWn7
	 ItJzyiMZJkFWGRR7NXdf/x7NbxogdCs157Ondp7I6DsrwpqErpjjZOyAEJpYVhIH2M
	 gNamraNbw46lveQfpm11tNMxlTNlM0PPL/LwLPJs=
Date: Wed, 11 Dec 2024 16:13:04 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yang@os.amperecomputing.com,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,riel@surriel.com,minchan@kernel.org,linux@armlinux.org.uk,leitao@debian.org,jcmvbkbc@gmail.com,jason.andryuk@amd.com,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,bp@alien8.de,bhelgaas@google.com,andreas@gaisler.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arc-use-generic_mmap_hint.patch added to mm-unstable branch
Message-Id: <20241212001304.DE421C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: arc: use generic_mmap_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arc-use-generic_mmap_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arc-use-generic_mmap_hint.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: arc: use generic_mmap_hint()
Date: Wed, 11 Dec 2024 15:27:43 -0800

Introduce arc arch_mmap_hint() and define HAVE_ARCH_MMAP_HINT.  This is a
preparatory patch, no functional change is introduced.

Link: https://lkml.kernel.org/r/20241211232754.1583023-6-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jason Andryuk <jason.andryuk@amd.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/pgtable.h |    1 
 arch/arc/mm/mmap.c             |   43 +++++++++++++++----------------
 2 files changed, 23 insertions(+), 21 deletions(-)

--- a/arch/arc/include/asm/pgtable.h~mm-arc-use-generic_mmap_hint
+++ a/arch/arc/include/asm/pgtable.h
@@ -28,6 +28,7 @@ extern pgd_t swapper_pg_dir[] __aligned(
 
 /* to cope with aliasing VIPT cache */
 #define HAVE_ARCH_UNMAPPED_AREA
+#define HAVE_ARCH_MMAP_HINT
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/arc/mm/mmap.c~mm-arc-use-generic_mmap_hint
+++ a/arch/arc/mm/mmap.c
@@ -14,6 +14,26 @@
 
 #include <asm/cacheflush.h>
 
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags)
+{
+	if (len > TASK_SIZE)
+		return -ENOMEM;
+
+	/*
+	 * We enforce the MAP_FIXED case.
+	 */
+	if (flags & MAP_FIXED) {
+		if (flags & MAP_SHARED &&
+		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
+			return -EINVAL;
+		return addr;
+	}
+
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+
 /*
  * Ensure that shared mappings are correctly aligned to
  * avoid aliasing issues with VIPT caches.
@@ -27,30 +47,11 @@ arch_get_unmapped_area(struct file *filp
 		unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info = {};
 
-	/*
-	 * We enforce the MAP_FIXED case.
-	 */
-	if (flags & MAP_FIXED) {
-		if (flags & MAP_SHARED &&
-		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
-			return -EINVAL;
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
 		return addr;
-	}
-
-	if (len > TASK_SIZE)
-		return -ENOMEM;
-
-	if (addr) {
-		addr = PAGE_ALIGN(addr);
-
-		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)))
-			return addr;
-	}
 
 	info.length = len;
 	info.low_limit = mm->mmap_base;
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-introduce-generic_mmap_hint.patch
mm-x86-introduce-arch_mmap_hint.patch
mm-arm-introduce-arch_mmap_hint.patch
mm-alpha-introduce-arch_mmap_hint.patch
mm-arc-use-generic_mmap_hint.patch
mm-csky-introduce-arch_mmap_hint.patch
mm-loongarch-introduce-arch_mmap_hint.patch
mm-mips-introduce-arch_align_mmap_hint.patch
mm-parisc-introduce-arch_align_mmap_hint.patch
mm-s390-use-generic_mmap_hint.patch
mm-sh-introduce-arch_mmap_hint.patch
mm-sparc32-introduce-arch_mmap_hint.patch
mm-sparc64-introduce-arch_mmap_hint.patch
mm-xtensa-introduce-arch_mmap_hint.patch
mm-powerpc-introduce-arch_mmap_hint.patch
mm-respect-mmap-hint-before-thp-alignment-if-allocation-is-possible.patch

