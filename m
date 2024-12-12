Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4B31C32
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733962408; cv=none; b=SgU4wRXgY45fV7zylXmyXLBZ/21QduF1cKfk7fkaBbXduwNoqhGOLVX1FeRUdLkhhomIxkHP0AIzeF+JHN3hPtz1aQuZ5G2QpiTUmwn6pzBp3cqyDW8wxxTxThla2YZf5NzXnNy4Sx0x6vloBeecvnJe9msGg5E43+p1hM6P88A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733962408; c=relaxed/simple;
	bh=28TphjnBGIWWBVAiyDkOJewCjJ53MuZMfzg/P5n889w=;
	h=Date:To:From:Subject:Message-Id; b=DqEJ59TOjY0p0hYR1VfrMuGT0u1/QteqBjJ6/4LRk921z6uXgLwV4rhJfWpS5C772jEIlm0FYoCDHPQGPJhtAHSQMzeIBBqkb1PUlIvDbjFq8Pp8/RRwUrVpVoaCbi7vNveVELBX2sDyJlYHwSdIjKgjFLHwaOYYEtRiwtWPHfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XylXlebL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XylXlebL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF70C4CED2;
	Thu, 12 Dec 2024 00:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733962408;
	bh=28TphjnBGIWWBVAiyDkOJewCjJ53MuZMfzg/P5n889w=;
	h=Date:To:From:Subject:From;
	b=XylXlebLc0aFDLWMNKptdkcotUSkY2oRCImPqY06Z6xKhdR/HOymd5IA5+rCBpUJw
	 cFt+MR4AtvbkLEQcZXcocHo53y2giir4hUFZ8LrOa+xp/ONadF9kJwErNDc1MrKSck
	 +5QIcoXe5KOiiL4wl8T2CeMQwDTw6n2xaUtIy7Ek=
Date: Wed, 11 Dec 2024 16:13:27 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yang@os.amperecomputing.com,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,riel@surriel.com,minchan@kernel.org,linux@armlinux.org.uk,leitao@debian.org,jcmvbkbc@gmail.com,jason.andryuk@amd.com,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,bp@alien8.de,bhelgaas@google.com,andreas@gaisler.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-xtensa-introduce-arch_mmap_hint.patch added to mm-unstable branch
Message-Id: <20241212001328.7EF70C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: xtensa: introduce arch_mmap_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-xtensa-introduce-arch_mmap_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-xtensa-introduce-arch_mmap_hint.patch

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
Subject: mm: xtensa: introduce arch_mmap_hint()
Date: Wed, 11 Dec 2024 15:27:52 -0800

Introduce xtensa arch_mmap_hint() and define HAVE_ARCH_MMAP_HINT.

If a sufficiently sized hole doesn't exist at the hint address, fallback
to searching the entire valid VA space instead of only the VA space above
the hint address.

Link: https://lkml.kernel.org/r/20241211232754.1583023-15-kaleshsingh@google.com
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

 arch/xtensa/kernel/syscall.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/arch/xtensa/kernel/syscall.c~mm-xtensa-introduce-arch_mmap_hint
+++ a/arch/xtensa/kernel/syscall.c
@@ -54,12 +54,12 @@ asmlinkage long xtensa_fadvise64_64(int
 }
 
 #ifdef CONFIG_MMU
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags)
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags)
 {
-	struct vm_area_struct *vmm;
-	struct vma_iterator vmi;
+	if (len > TASK_SIZE)
+		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -71,16 +71,27 @@ unsigned long arch_get_unmapped_area(str
 		return addr;
 	}
 
-	if (len > TASK_SIZE)
-		return -ENOMEM;
-	if (!addr)
-		addr = TASK_UNMAPPED_BASE;
-
 	if (flags & MAP_SHARED)
 		addr = COLOUR_ALIGN(addr, pgoff);
 	else
 		addr = PAGE_ALIGN(addr);
 
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+
+unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags,
+		vm_flags_t vm_flags)
+{
+	struct vm_area_struct *vmm;
+	struct vma_iterator vmi;
+
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
+		return addr;
+
+	addr = TASK_UNMAPPED_BASE;
+
 	vma_iter_init(&vmi, current->mm, addr);
 	for_each_vma(vmi, vmm) {
 		/* At this point:  (addr < vmm->vm_end). */
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

