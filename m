Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3174282F06
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917746; cv=none; b=qrrlp0UMTZA5GvGAn08LyDY7gs3nyjBJCII5ue6Th3hNgD3w74+2rLMpIfhLp4La3IWmw1Afa3um1SqEe7JpBu290WYqE8M21jk6thFebyHX7Rmfo/wVFn3wpbIkwdzYzhE1u2Y7d9/ge88C8KeOjLQ3JIfgu8sLzJ01/GmjQFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917746; c=relaxed/simple;
	bh=wy7vAKV1I0U2sBIyzkuuvkdguwb1pC+jU2BHqk8qV8E=;
	h=Date:To:From:Subject:Message-Id; b=H/Y71Q17p40EDPhzo7fflu3ZHnFxrzGyk/VzljHT+tlEfoe8b8np+zsp1B6kwq7JgV58xKMGFNw68cOkU7271cF/xv5GHZIMSmtMtPZi2q04ebvKDPLHqm66aIuuY6Cf94E39sv3NpHcTwaVHwlh4OBwVifMEUypV7cwL3Oy/xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bHmkpEO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bHmkpEO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811E6C4CEF7;
	Tue, 31 Mar 2026 00:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917745;
	bh=wy7vAKV1I0U2sBIyzkuuvkdguwb1pC+jU2BHqk8qV8E=;
	h=Date:To:From:Subject:From;
	b=bHmkpEO8h349b/+nppg0Uel6dtNekR6BcTtgfU/HNg1Ix4np1JPyYbfZQSUlOX6tJ
	 8rZDKV4pdopnEjqL+z4OCpxXVDFhCSF++cYSZwOuwqTMY3Glh802UXEe/PuGlglv1e
	 U21vWbbtTihjFL2q5uun+tOGL8EeKe0GmxTskG88=
Date: Mon, 30 Mar 2026 17:42:24 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,will@kernel.org,viro@zeniv.linux.org.uk,vgupta@kernel.org,vbabka@kernel.org,tsbogend@alpha.franken.de,svens@linux.ibm.com,surenb@google.com,stephen.smalley.work@gmail.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,paul@paul-moore.com,palmer@dabbelt.com,omosnace@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,linux@armlinux.org.uk,liam.howlett@oracle.com,kernel@xen0n.name,kees@kernel.org,johannes@sipsolutions.net,jannh@google.com,jack@suse.cz,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,dinguyen@kernel.org,david@kernel.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,anton.ivanov@cambridgegreys.com,alex@ghiti.fr,agordeev@linux.ibm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch removed from -mm tree
Message-Id: <20260331004225.811E6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: unexport vm_brk_flags() and eliminate vm_flags parameter
has been removed from the -mm tree.  Its filename was
     mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: unexport vm_brk_flags() and eliminate vm_flags parameter
Date: Fri, 20 Mar 2026 19:38:26 +0000

This function is only used by elf_load(), and that is a static function
that doesn't need an exported symbol to invoke an internal function, so
un-EXPORT_SYMBOLS() it.

Also, the vm_flags parameter is unnecessary, as we only ever set VM_EXEC,
so simply make this parameter a boolean.

While we're here, clean up the mm.h definitions for the various vm_xxx()
helpers so we actually specify parameter names and elide the redundant
extern's.

Link: https://lkml.kernel.org/r/7bada48ddf3f9dbd3e6c4fc50ec2f4de97706f52.1774034900.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c    |    3 +--
 include/linux/mm.h |   12 ++++++------
 mm/mmap.c          |    8 ++------
 3 files changed, 9 insertions(+), 14 deletions(-)

--- a/fs/binfmt_elf.c~mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter
+++ a/fs/binfmt_elf.c
@@ -453,14 +453,13 @@ static unsigned long elf_load(struct fil
 		zero_end = ELF_PAGEALIGN(zero_end);
 
 		error = vm_brk_flags(zero_start, zero_end - zero_start,
-				     prot & PROT_EXEC ? VM_EXEC : 0);
+				     prot & PROT_EXEC);
 		if (error)
 			map_addr = error;
 	}
 	return map_addr;
 }
 
-
 static unsigned long total_mapping_size(const struct elf_phdr *phdr, int nr)
 {
 	elf_addr_t min_addr = -1;
--- a/include/linux/mm.h~mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter
+++ a/include/linux/mm.h
@@ -3991,12 +3991,12 @@ static inline void mm_populate(unsigned
 #endif
 
 /* This takes the mm semaphore itself */
-extern int __must_check vm_brk_flags(unsigned long, unsigned long, unsigned long);
-extern int vm_munmap(unsigned long, size_t);
-extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
-        unsigned long, unsigned long,
-        unsigned long, unsigned long);
-extern unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
+int __must_check vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec);
+int vm_munmap(unsigned long start, size_t len);
+unsigned long __must_check vm_mmap(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long prot,
+		unsigned long flag, unsigned long offset);
+unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
 		unsigned long len, unsigned long flags);
 
 struct vm_unmapped_area_info {
--- a/mm/mmap.c~mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter
+++ a/mm/mmap.c
@@ -1201,8 +1201,9 @@ out:
 	return ret;
 }
 
-int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
+int vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec)
 {
+	const vm_flags_t vm_flags = is_exec ? VM_EXEC : 0;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	unsigned long len;
@@ -1217,10 +1218,6 @@ int vm_brk_flags(unsigned long addr, uns
 	if (!len)
 		return 0;
 
-	/* Until we need other flags, refuse anything except VM_EXEC. */
-	if ((vm_flags & (~VM_EXEC)) != 0)
-		return -EINVAL;
-
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
@@ -1246,7 +1243,6 @@ limits_failed:
 	mmap_write_unlock(mm);
 	return ret;
 }
-EXPORT_SYMBOL(vm_brk_flags);
 
 static
 unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

