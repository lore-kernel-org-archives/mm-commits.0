Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EC9A2D
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 00:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733962393; cv=none; b=mNQ9bIZ1HRK0VBCJJ18mgiCtVgSxa1agCPvsGlgiSfbW+oC6mhIX0xqTIkhmeeDKnlWF0HHRAm6VJ/jBbbsyWRBVU0FrcgFUOmHFrRy4bj8fLlh2dVCLJzdR0PcTYdMGzUeHVNYM5xlovUKq70U757a5vBpwyqEU/NeyjVyN484=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733962393; c=relaxed/simple;
	bh=4ZbUJlRy2X3MjMkBUyLmB33cvPcvEWZSmiWXj7q2ad4=;
	h=Date:To:From:Subject:Message-Id; b=GP3hq0aaG/4HvZiyCtlShbn43RzL7RTmREynx23ZyPIhwjarQe3fq/uWBmBrzo/GTMWTD40XNhFpIdNoJ4twdvRmOZ+kOLQMaJNeNpK67ClZICMGZYc8zQLcajiOAP/0KNUOCJY7qixeThfXX0ALHAOIwBcIgikoWDX/y4qSh+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOlkNZaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOlkNZaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1A5C4CED2;
	Thu, 12 Dec 2024 00:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733962392;
	bh=4ZbUJlRy2X3MjMkBUyLmB33cvPcvEWZSmiWXj7q2ad4=;
	h=Date:To:From:Subject:From;
	b=OOlkNZaziS/NJAUvoU8jG5CbulPrNOhSvY0rqvxzGvawSc9B2LItbHpSH4FzY/UwQ
	 ++Kpz/Z72OGYbQL1yzoNlnveDA8shY6QphaGbIiAi2qTfYcGAWipBuV6sVs6XBG1Wr
	 1kv919a0hzJc9s63lglVNbTeacyWkfG3cJmDYxug=
Date: Wed, 11 Dec 2024 16:13:12 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yang@os.amperecomputing.com,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,riel@surriel.com,minchan@kernel.org,linux@armlinux.org.uk,leitao@debian.org,jcmvbkbc@gmail.com,jason.andryuk@amd.com,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,bp@alien8.de,bhelgaas@google.com,andreas@gaisler.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mips-introduce-arch_align_mmap_hint.patch added to mm-unstable branch
Message-Id: <20241212001312.AB1A5C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mips: introduce arch_align_mmap_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mips-introduce-arch_align_mmap_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mips-introduce-arch_align_mmap_hint.patch

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
Subject: mm: mips: introduce arch_align_mmap_hint()
Date: Wed, 11 Dec 2024 15:27:46 -0800

Introduce mips arch_mmap_hint() and define HAVE_ARCH_MMAP_HINT.  This is a
preparatory patch, no functional change is introduced.

Link: https://lkml.kernel.org/r/20241211232754.1583023-9-kaleshsingh@google.com
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

 arch/mips/include/asm/pgtable.h |    1 
 arch/mips/mm/mmap.c             |   50 ++++++++++++++++--------------
 2 files changed, 29 insertions(+), 22 deletions(-)

--- a/arch/mips/include/asm/pgtable.h~mm-mips-introduce-arch_align_mmap_hint
+++ a/arch/mips/include/asm/pgtable.h
@@ -766,5 +766,6 @@ static inline pmd_t pmdp_huge_get_and_cl
  */
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
+#define HAVE_ARCH_MMAP_HINT
 
 #endif /* _ASM_PGTABLE_H */
--- a/arch/mips/mm/mmap.c~mm-mips-introduce-arch_align_mmap_hint
+++ a/arch/mips/mm/mmap.c
@@ -26,15 +26,11 @@ EXPORT_SYMBOL(shm_align_mask);
 
 enum mmap_allocation_direction {UP, DOWN};
 
-static unsigned long arch_get_unmapped_area_common(struct file *filp,
-	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags, enum mmap_allocation_direction dir)
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long addr = addr0;
-	int do_color_align;
-	struct vm_unmapped_area_info info = {};
+	bool do_color_align;
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
@@ -54,22 +50,32 @@ static unsigned long arch_get_unmapped_a
 		return addr;
 	}
 
-	do_color_align = 0;
-	if (filp || (flags & MAP_SHARED))
-		do_color_align = 1;
+	do_color_align = filp || (flags & MAP_SHARED);
+
+	if (do_color_align)
+		addr = COLOUR_ALIGN(addr, pgoff);
+	else
+		addr = PAGE_ALIGN(addr);
+
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+
+
+static unsigned long arch_get_unmapped_area_common(struct file *filp,
+	unsigned long addr0, unsigned long len, unsigned long pgoff,
+	unsigned long flags, enum mmap_allocation_direction dir)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr = addr0;
+	struct vm_unmapped_area_info info = {};
+	bool do_color_align;
 
 	/* requesting a specific address */
-	if (addr) {
-		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
-		else
-			addr = PAGE_ALIGN(addr);
-
-		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)))
-			return addr;
-	}
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
+		return addr;
+
+	do_color_align = filp || (flags & MAP_SHARED);
 
 	info.length = len;
 	info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
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

