Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6450A645
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 00:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733962403; cv=none; b=T4HBg6uzW6K/fn+QEPMVsGQM5zh0Jq0Twim+od/oSnrJPFRDqgkiCeaf6UddHD0lJHLlZdfpFesIV92+hZxa8Tepjer+0pmrd4tp8+/K6hspCseaewotWq/JPC5NRZQCo/82+ztg8HKNwptRZkUkEGZknfBQ0kHRLhqKhVJi2mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733962403; c=relaxed/simple;
	bh=i040RUsCD3heltwWY2BFcKK+8k1Li3SSM3noqXCAcWk=;
	h=Date:To:From:Subject:Message-Id; b=lFta0STZYtsoau/Lwy0YYaYd3T2Eu+6zO7nak1GQTYhwkaXSj/KNy2dg8g2qj2kBPfMd8qcUH9fH1nNgBq/FWbi3M54FYOHwCIoUgQyoYJuv3z3aTry6C5osoRuO9mAo790Mi5xwcnjIqhQYdgnp5Z1O5ePUrFh5grwyvcQ5Xu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cX2xQLSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cX2xQLSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3254DC4CED2;
	Thu, 12 Dec 2024 00:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733962403;
	bh=i040RUsCD3heltwWY2BFcKK+8k1Li3SSM3noqXCAcWk=;
	h=Date:To:From:Subject:From;
	b=cX2xQLSJ2IWsQ/pB/fBUcgRUseSxkJvAi2Tdr3tGLM6B+5wSozzi2d0bzdQhOYP33
	 EZ5yqdJYWDpKPWAm9xVrOyIhmkl0V7m2cazZHT64iPq7o55mNNXumUuvnGR6S3152F
	 aQ1x0uYKNCKy234K1CZdoyt9FYHpMuNsGDnfAKn0=
Date: Wed, 11 Dec 2024 16:13:22 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yang@os.amperecomputing.com,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,riel@surriel.com,minchan@kernel.org,linux@armlinux.org.uk,leitao@debian.org,jcmvbkbc@gmail.com,jason.andryuk@amd.com,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,bp@alien8.de,bhelgaas@google.com,andreas@gaisler.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparc32-introduce-arch_mmap_hint.patch added to mm-unstable branch
Message-Id: <20241212001323.3254DC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: sparc32: introduce arch_mmap_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparc32-introduce-arch_mmap_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparc32-introduce-arch_mmap_hint.patch

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
Subject: mm: sparc32: introduce arch_mmap_hint()
Date: Wed, 11 Dec 2024 15:27:50 -0800

Introduce sparc32 arch_mmap_hint() and define HAVE_ARCH_MMAP_HINT.

If a sufficiently sized hole doesn't exist at the hint address, fallback
to searching the entire valid VA space instead of only the VA space above
the hint address.

Link: https://lkml.kernel.org/r/20241211232754.1583023-13-kaleshsingh@google.com
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

 arch/sparc/include/asm/pgtable_32.h |    1 
 arch/sparc/kernel/sys_sparc_32.c    |   33 +++++++++++++++++---------
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/arch/sparc/include/asm/pgtable_32.h~mm-sparc32-introduce-arch_mmap_hint
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -437,6 +437,7 @@ static inline int io_remap_pfn_range(str
 
 /* We provide our own get_unmapped_area to cope with VA holes for userland */
 #define HAVE_ARCH_UNMAPPED_AREA
+#define HAVE_ARCH_MMAP_HINT
 
 #define pmd_pgtable(pmd)	((pgtable_t)__pmd_page(pmd))
 
--- a/arch/sparc/kernel/sys_sparc_32.c~mm-sparc32-introduce-arch_mmap_hint
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -40,13 +40,17 @@ SYSCALL_DEFINE0(getpagesize)
 	return PAGE_SIZE; /* Possibly older binaries want 8192 on sun4's? */
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags)
 {
-	struct vm_unmapped_area_info info = {};
-	bool file_hugepage = false;
+	bool file_hugepage;
+
+	/* See asm-sparc/uaccess.h */
+	if (len > TASK_SIZE - PAGE_SIZE)
+		return -ENOMEM;
 
-	if (filp && is_file_hugepages(filp))
-		file_hugepage = true;
+	file_hugepage = filp && is_file_hugepages(filp);
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -58,14 +62,21 @@ unsigned long arch_get_unmapped_area(str
 		return addr;
 	}
 
-	/* See asm-sparc/uaccess.h */
-	if (len > TASK_SIZE - PAGE_SIZE)
-		return -ENOMEM;
-	if (!addr)
-		addr = TASK_UNMAPPED_BASE;
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+
+unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
+				     unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
+{
+	struct vm_unmapped_area_info info = {};
+	bool file_hugepage = false;
+
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
+		return addr;
 
 	info.length = len;
-	info.low_limit = addr;
+	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = TASK_SIZE;
 	if (!file_hugepage) {
 		info.align_mask = (flags & MAP_SHARED) ?
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

