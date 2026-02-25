Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E125038F949
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048885; cv=none; b=Ag0Ok6XPdvqJ8ZciPif1epoZtdOiFnw2Zr2bpDC4QtP2EtvUhLVndbzLAk/iGe+5dsHAe7BBrQG14JxMr5gE9TE4HgDbSyqvwtfyKPylJ/jQOo8G5GAggTo2TDU08mbBGapieiwwdh5lQJbXE1UW798BpuLmPFB3hyRm4sWg7JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048885; c=relaxed/simple;
	bh=ISrrUj3pPY/gCRgGo9jcr3wC1nx0na3K0YcMp/mHeBE=;
	h=Date:To:From:Subject:Message-Id; b=ND86aRzXHrK6F3wRSUw/cHnry3gR0TKLXM4a9uML2yMHjtKtaSGdmZm6WanGD5JMAVx+x7v31ZIOM9x1LpRCyP40tU2rrMxJwMEQJFMhDLVXDgWFSRLKMJ+v954/iZp7El8Z7cAosKxvqiGepqQgnPbQXFVPaJbeckicTbCkrH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eLAXp+et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eLAXp+et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA4BC116D0;
	Wed, 25 Feb 2026 19:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772048884;
	bh=ISrrUj3pPY/gCRgGo9jcr3wC1nx0na3K0YcMp/mHeBE=;
	h=Date:To:From:Subject:From;
	b=eLAXp+et8tmPpdVr/RrnRm7/NMytfu9B0FJ99i7uJ8qe6yRUAYZL+w01wVLEtorxB
	 6edkEKykztQametxOEP+4mKjmynWTl36TRV38zsQ7A9kc4NiimuIEfjILbR/i5r/kM
	 F5opgvmZOJCGwo+e7Swjj0VvDdLkrmBCmJZccEgk=
Date: Wed, 25 Feb 2026 11:48:03 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch added to mm-new branch
Message-Id: <20260225194804.5DA4BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK mappings
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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
@@ -3917,6 +3917,8 @@ extern int vm_munmap(unsigned long, size
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

mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch
arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper.patch
riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
mm-do-not-map-the-shadow-stack-as-thp.patch

