Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853FBA2D
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733962395; cv=none; b=CU9pLYp17MrwIT0bQpdkMDP+lcTxqVYu7YtXhk4MdZZBzHCZfRFmj5J+6dhX+T/J/ImsgqxKX6rf4t+xPCf1QphVYPQIwIN2RaVn2t90hVSdoK/yupTw9jEDsbPleGo7czCaFXgexVkoXC6Fa18wSyyTU0s6GJey13svqbcNhuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733962395; c=relaxed/simple;
	bh=Z48V5D9y4FYUVADuOVhbTFUmkBCaMCvmtYrlFzli7mA=;
	h=Date:To:From:Subject:Message-Id; b=VAejNgqDeXFDtzJaZ6HMbchZaiR5e4POfmb1CpnpUU/6tUqduStZQY5ULRvHY8/3dtAu7NPW1TDNq6Y/Zj87Hx+Iyow/1lFhq5s8swLRNFnMhqv3iAtHPkwlGClbKst7CQOR0auae5/b+GyZpnPFmLyvb0HD2azueS04j9NNeCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PrSr6cuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PrSr6cuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50257C4CED2;
	Thu, 12 Dec 2024 00:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733962395;
	bh=Z48V5D9y4FYUVADuOVhbTFUmkBCaMCvmtYrlFzli7mA=;
	h=Date:To:From:Subject:From;
	b=PrSr6cuu6N0KCUDSQkFADB7cqD/JmB3jbUPku58Homxb7zsfdXsTTZoQx6qpENdmO
	 qlpUct9/gvw+jvrxNXergsXvgFcvFITQ07RBySsRLkgxpxmn/Xeiv1EuQpQjfiMmof
	 wPGk2n1BSA8RTc4GyVsej2L0eRr7mgSR4X0shE+M=
Date: Wed, 11 Dec 2024 16:13:14 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yang@os.amperecomputing.com,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,riel@surriel.com,minchan@kernel.org,linux@armlinux.org.uk,leitao@debian.org,jcmvbkbc@gmail.com,jason.andryuk@amd.com,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,bp@alien8.de,bhelgaas@google.com,andreas@gaisler.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-parisc-introduce-arch_align_mmap_hint.patch added to mm-unstable branch
Message-Id: <20241212001315.50257C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: parisc: introduce arch_align_mmap_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-parisc-introduce-arch_align_mmap_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-parisc-introduce-arch_align_mmap_hint.patch

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
Subject: mm: parisc: introduce arch_align_mmap_hint()
Date: Wed, 11 Dec 2024 15:27:47 -0800

Introduce parisc arch_mmap_hint() and define HAVE_ARCH_MMAP_HINT.  This is
a preparatory patch, no functional change is introduced.

Link: https://lkml.kernel.org/r/20241211232754.1583023-10-kaleshsingh@google.com
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

 arch/parisc/include/asm/pgtable.h |    1 
 arch/parisc/kernel/sys_parisc.c   |   55 +++++++++++++++-------------
 2 files changed, 32 insertions(+), 24 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h~mm-parisc-introduce-arch_align_mmap_hint
+++ a/arch/parisc/include/asm/pgtable.h
@@ -505,6 +505,7 @@ static inline void ptep_set_wrprotect(st
 
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
+#define HAVE_ARCH_MMAP_HINT
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
--- a/arch/parisc/kernel/sys_parisc.c~mm-parisc-introduce-arch_align_mmap_hint
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -96,24 +96,16 @@ unsigned long mmap_upper_limit(struct rl
 
 enum mmap_allocation_direction {UP, DOWN};
 
-static unsigned long arch_get_unmapped_area_common(struct file *filp,
-	unsigned long addr, unsigned long len, unsigned long pgoff,
-	unsigned long flags, enum mmap_allocation_direction dir)
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev;
 	unsigned long filp_pgoff;
-	int do_color_align;
-	struct vm_unmapped_area_info info = {
-		.length = len
-	};
+	bool do_color_align;
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
 
-	do_color_align = 0;
-	if (filp || (flags & MAP_SHARED))
-		do_color_align = 1;
 	filp_pgoff = GET_FILP_PGOFF(filp);
 
 	if (flags & MAP_FIXED) {
@@ -128,18 +120,33 @@ static unsigned long arch_get_unmapped_a
 		return addr;
 	}
 
-	if (addr) {
-		if (do_color_align)
-			addr = COLOR_ALIGN(addr, filp_pgoff, pgoff);
-		else
-			addr = PAGE_ALIGN(addr);
-
-		vma = find_vma_prev(mm, addr, &prev);
-		if (TASK_SIZE - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)) &&
-		    (!prev || addr >= vm_end_gap(prev)))
-			return addr;
-	}
+	do_color_align = filp || (flags & MAP_SHARED);
+
+	if (do_color_align)
+		addr = COLOR_ALIGN(addr, filp_pgoff, pgoff);
+	else
+		addr = PAGE_ALIGN(addr);
+
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+
+static unsigned long arch_get_unmapped_area_common(struct file *filp,
+	unsigned long addr, unsigned long len, unsigned long pgoff,
+	unsigned long flags, enum mmap_allocation_direction dir)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long filp_pgoff;
+	bool do_color_align;
+	struct vm_unmapped_area_info info = {
+		.length = len
+	};
+
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
+		return addr;
+
+	filp_pgoff = GET_FILP_PGOFF(filp);
+	do_color_align = filp || (flags & MAP_SHARED);
 
 	info.align_mask = do_color_align ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
 	info.align_offset = shared_align_offset(filp_pgoff, pgoff);
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

