Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C7218E344
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925298; cv=none; b=WjCIVDwUGq1dM10XoR3zLhMGJ8MmYkzxEaKtFmzE9ZsdB+ongA8TcZn40n9d6cx/r85WIHTlPfIJ1XewInFpkGBXpeDXhx3bjUYF/+dvVLwkUE18fNHT3+JSR6cQWF38OI+wWmbHdmNRUZCFJpMR+zY64Jr4mos12i6chkTgpfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925298; c=relaxed/simple;
	bh=eb7qI286l9bqNqkpMOUundbFSxa8a3MCwuFzX9PQ0Fw=;
	h=Date:To:From:Subject:Message-Id; b=EBBlPjyVR6DT5frgLyFV2+yfwz86CUWB6MiIaUBlPM1SyJdol0ZpjiaTNasr/heq8n9reTuWfRCYPi/D2S6Vqp81MO8Ma7Y19U3Bt7VhIOe99s8WH+8DC+r7BL2UYOEOabtKoLSU0AwjVE9wC6hn8hm/O63V3YlELPdRsmeHRNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LfkszvI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LfkszvI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BCCC4CEC5;
	Mon,  9 Sep 2024 23:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925298;
	bh=eb7qI286l9bqNqkpMOUundbFSxa8a3MCwuFzX9PQ0Fw=;
	h=Date:To:From:Subject:From;
	b=LfkszvI7+LuI8aJOXf9zOToAiCpxNbsXiOULRygFPZy2FrTAFHnQ07HENSZXq5qRw
	 zXfwP2hNPe5EOgi4LFnLhWX4XVPw+y+wdJgS0hSPmRpkBVQKRlx9OYRaBzwIiOXsVz
	 yeec4XJ2Y5aNiuKCPUn5e1rOHx2vElM8KvC6nU4U=
Date: Mon, 09 Sep 2024 16:41:37 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,svens@linux.ibm.com,rick.p.edgecombe@intel.com,richard.henderson@linaro.org,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kernel@xen0n.name,jcmvbkbc@gmail.com,James.Bottomley@HansenPartnership.com,ink@jurassic.park.msu.ru,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-vm_flags-to-generic_get_unmapped_area.patch removed from -mm tree
Message-Id: <20240909234138.32BCCC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass vm_flags to generic_get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     mm-pass-vm_flags-to-generic_get_unmapped_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: mm: pass vm_flags to generic_get_unmapped_area()
Date: Wed, 04 Sep 2024 17:58:00 +0100

In preparation for using vm_flags to ensure guard pages for shadow stacks
supply them as an argument to generic_get_unmapped_area().  The only user
outside of the core code is the PowerPC book3s64 implementation which is
trivially wrapping the generic implementation in the radix_enabled() case.

No functional changes.

Link: https://lkml.kernel.org/r/20240904-mm-generic-shadow-stack-guard-v2-2-a46b8b6dc0ed@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/slice.c |    4 ++--
 include/linux/sched/mm.h         |    4 ++--
 mm/mmap.c                        |   10 ++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

--- a/arch/powerpc/mm/book3s64/slice.c~mm-pass-vm_flags-to-generic_get_unmapped_area
+++ a/arch/powerpc/mm/book3s64/slice.c
@@ -641,7 +641,7 @@ unsigned long arch_get_unmapped_area(str
 				     vm_flags_t vm_flags)
 {
 	if (radix_enabled())
-		return generic_get_unmapped_area(filp, addr, len, pgoff, flags);
+		return generic_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 
 	return slice_get_unmapped_area(addr, len, flags,
 				       mm_ctx_user_psize(&current->mm->context), 0);
@@ -655,7 +655,7 @@ unsigned long arch_get_unmapped_area_top
 					     vm_flags_t vm_flags)
 {
 	if (radix_enabled())
-		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags);
+		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags, vm_flags);
 
 	return slice_get_unmapped_area(addr0, len, flags,
 				       mm_ctx_user_psize(&current->mm->context), 1);
--- a/include/linux/sched/mm.h~mm-pass-vm_flags-to-generic_get_unmapped_area
+++ a/include/linux/sched/mm.h
@@ -204,11 +204,11 @@ unsigned long mm_get_unmapped_area_vmfla
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags);
+			  unsigned long flags, vm_flags_t vm_flags);
 unsigned long
 generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags);
+				  unsigned long flags, vm_flags_t vm_flags);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm,
 					 struct rlimit *rlim_stack) {}
--- a/mm/mmap.c~mm-pass-vm_flags-to-generic_get_unmapped_area
+++ a/mm/mmap.c
@@ -738,7 +738,7 @@ unsigned long vm_unmapped_area(struct vm
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags)
+			  unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -772,7 +772,8 @@ arch_get_unmapped_area(struct file *filp
 		       unsigned long len, unsigned long pgoff,
 		       unsigned long flags, vm_flags_t vm_flags)
 {
-	return generic_get_unmapped_area(filp, addr, len, pgoff, flags);
+	return generic_get_unmapped_area(filp, addr, len, pgoff, flags,
+					 vm_flags);
 }
 #endif
 
@@ -783,7 +784,7 @@ arch_get_unmapped_area(struct file *filp
 unsigned long
 generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long len, unsigned long pgoff,
-				  unsigned long flags)
+				  unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma, *prev;
 	struct mm_struct *mm = current->mm;
@@ -836,7 +837,8 @@ arch_get_unmapped_area_topdown(struct fi
 			       unsigned long len, unsigned long pgoff,
 			       unsigned long flags, vm_flags_t vm_flags)
 {
-	return generic_get_unmapped_area_topdown(filp, addr, len, pgoff, flags);
+	return generic_get_unmapped_area_topdown(filp, addr, len, pgoff, flags,
+						 vm_flags);
 }
 #endif
 
_

Patches currently in -mm which might be from broonie@kernel.org are


