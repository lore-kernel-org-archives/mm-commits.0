Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E512D876A
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048892; cv=none; b=Btr7ExtLIbKm6rmpRlv4pLXi1vSBJUTTor55eouYcGSfv/KhPMDoqYX7VgyH92AICHJlJ4RUFbZ+z38yP4GV8GdprsEZVNUKsBH16GyRgQC/HP4tCz3yUwB7j8iilfKJ38rqzSuVA61b6tZALEPZvZODO1qoWG6FH5uzMI2UgLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048892; c=relaxed/simple;
	bh=TstYc5AgDG7XBVdTcBzpKF6yuLNKnBO5t2UmkIdYhuU=;
	h=Date:To:From:Subject:Message-Id; b=J39hvDNk1wfwKvRzKD6vgntDKgcEsIhdY6srD/wl8V3IxA0sYniPtaaS14A9/SZ8LI65ZFcg3m/gYRij69I1lsE5UDrwclZadOgiRP0Sfvn+YZu4rRmhcoOww7KJj1jOducgNLH3MimQ7/lmHNuevt6iBr0meq1LlAL64bu1u5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HctcMDfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HctcMDfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C3C116D0;
	Wed, 25 Feb 2026 19:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772048891;
	bh=TstYc5AgDG7XBVdTcBzpKF6yuLNKnBO5t2UmkIdYhuU=;
	h=Date:To:From:Subject:From;
	b=HctcMDfvXaAFkVFRKyRf0CRYHmHAvGbK84daa2MmPDQfm+m2ik/8owJM/joGADuJ3
	 o72oeI65HbKKF7uaiWa47IGGsulZ/sU5tORJyB3Pq6G3sDQhdVVktXNainkYd1z7aR
	 cb3wv1Lom0ip9f2JhXikHJgTq/lSqXOQX0iqK6gE=
Date: Wed, 25 Feb 2026 11:48:11 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch added to mm-new branch
Message-Id: <20260225194811.AC6C3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: shstk: use the new common vm_mmap_shadow_stack() helper
has been added to the -mm mm-new branch.  Its filename is
     x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch

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
Subject: x86: shstk: use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:14:01 +0000

Replace part of the x86 alloc_shstk() content with a call to
vm_mmap_shadow_stack(). There is no functional change.

Link: https://lkml.kernel.org/r/20260225161404.3157851-5-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/shstk.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/shstk.c~x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper
+++ a/arch/x86/kernel/shstk.c
@@ -100,17 +100,9 @@ static int create_rstor_token(unsigned l
 static unsigned long alloc_shstk(unsigned long addr, unsigned long size,
 				 unsigned long token_offset, bool set_res_tok)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE | MAP_ABOVE4G;
-	struct mm_struct *mm = current->mm;
-	unsigned long mapped_addr, unused;
+	unsigned long mapped_addr;
 
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	mapped_addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-			      VM_SHADOW_STACK | VM_WRITE, 0, &unused, NULL);
-	mmap_write_unlock(mm);
+	mapped_addr = vm_mmap_shadow_stack(addr, size, MAP_ABOVE4G);
 
 	if (!set_res_tok || IS_ERR_VALUE(mapped_addr))
 		goto out;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch
arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper.patch
riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
mm-do-not-map-the-shadow-stack-as-thp.patch

