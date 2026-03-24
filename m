Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D8B36C0C8
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388610; cv=none; b=V0zzFg6ODRkngo4Nxdz3ezmcO+iq3UxZeMTrQZlCI/tIlzfYbHpiQ9WST7T5ng+c05kq8jFwSoF6v3CwWbqW+AVX8jfo4DZQpsA1SLcx9WZoCal+j1/LkiFvu8xvGdLTv95rftE3Socq8YnYgrsvY3cMZLVaynY3zixzywplpro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388610; c=relaxed/simple;
	bh=HpI/Tm+I+c0d0g0h2Uog41iJ5LqyELXYrkdiCDP2Cx4=;
	h=Date:To:From:Subject:Message-Id; b=DIOKID1YGqf+q1JvOSLSkk6VE0BgOV5T35PiR/ktyFNnOIttb0wJcFJe4jbQ59KSqI9V84YGjV8U1sDom3AYb4R7qzl+pZykYm1oEMq07MI0SdB5xqfSz8znoi2nrL3lqW/XDT5p4Sbgep8DvhPa0KlwGph+1yo43g2u6QvypIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hk0EAq7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hk0EAq7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70857C2BC9E;
	Tue, 24 Mar 2026 21:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388610;
	bh=HpI/Tm+I+c0d0g0h2Uog41iJ5LqyELXYrkdiCDP2Cx4=;
	h=Date:To:From:Subject:From;
	b=Hk0EAq7aSZIM/pXu3ZJXCCtSY8RaNxnKb7N93ccX0iF5npYmR9ShBgjVWXEQ3Le1X
	 nVTTPXFAUHPuynkWZ8dA6dBLZfon7klKpu9wrZUBnGuBo0ii3HyrOcLBTwsoVf18o0
	 /nvBtfmnR62WyWIK2ESuRUtDTn9/Cm4EJMFQkQqA=
Date: Tue, 24 Mar 2026 14:43:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch removed from -mm tree
Message-Id: <20260324214330.70857C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK mappings
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK mappings
Date: Wed, 25 Feb 2026 16:13:58 +0000

Patch series "mm: arch/shstk: Common shadow stack mapping helper and
VM_NOHUGEPAGE", v2.

A series to extract the common shadow stack mmap into a separate helper
for arm64, riscv and x86.


This patch (of 5):

arm64, riscv and x86 use a similar pattern for mapping the user shadow
stack (cloned from x86).  Extract this into a helper to facilitate code
reuse.

The call to do_mmap() from the new helper uses PROT_READ|PROT_WRITE prot
bits instead of the PROT_READ with an explicit VM_WRITE vm_flag.  The x86
intent was to avoid PROT_WRITE implying normal write since the shadow
stack is not writable by normal stores.  However, from a kernel
perspective, the vma is writeable.  Functionally there is no difference.

Link: https://lkml.kernel.org/r/20260225161404.3157851-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/20260225161404.3157851-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/util.c          |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/mm.h~mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings
+++ a/include/linux/mm.h
@@ -3903,6 +3903,8 @@ extern int vm_munmap(unsigned long, size
 extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
+extern unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
+		unsigned long len, unsigned long flags);
 
 struct vm_unmapped_area_info {
 #define VM_UNMAPPED_AREA_TOPDOWN 1
--- a/mm/util.c~mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings
+++ a/mm/util.c
@@ -618,6 +618,31 @@ unsigned long vm_mmap(struct file *file,
 }
 EXPORT_SYMBOL(vm_mmap);
 
+#ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
+/*
+ * Perform a userland memory mapping for a shadow stack into the current
+ * process address space. This is intended to be used by architectures that
+ * support user shadow stacks.
+ */
+unsigned long vm_mmap_shadow_stack(unsigned long addr, unsigned long len,
+		unsigned long flags)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long ret, unused;
+
+	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
+	if (addr)
+		flags |= MAP_FIXED_NOREPLACE;
+
+	mmap_write_lock(mm);
+	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
+		      VM_SHADOW_STACK, 0, &unused, NULL);
+	mmap_write_unlock(mm);
+
+	return ret;
+}
+#endif /* CONFIG_ARCH_HAS_USER_SHADOW_STACK */
+
 /**
  * __vmalloc_array - allocate memory for a virtually contiguous array.
  * @n: number of elements.
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


