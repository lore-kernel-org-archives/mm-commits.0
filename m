Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2715364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388614; cv=none; b=cua00wBP/Valb1jDskmfa954Wjnkn2f5j4PGNaiB7A1UjrUqgLMeiKKh6tfcGowiK4b2pNNvMUYN+WhHThwqoj6LqcTXdbMV3LEN/dmzrmKGVUzadnc/x01JNgN2RL8MvcCf9fUnXPiW8sl5k08j02LF6IVlbgISda4Gt6quCx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388614; c=relaxed/simple;
	bh=A+Z/vJCLhHZ645gwvF15zsPEoiVSBmBKZuTnilVQ/pE=;
	h=Date:To:From:Subject:Message-Id; b=SGIekSpKUPBbdADNukQ8ZjP20zEXMLMPaqtqWmbr4ViguiZjaFMiuYKlzYh9eVqT5dS3B1blUuIcckpNVRmvuU/WQFV9cbY+GYNeMLZHvII5RRDIL0WvbtTTtkJuA9AekLzW1EH8qHr3RsWYyV4cB8CqcdF7B3W+BDguEuLsWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KFdMBU91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KFdMBU91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D20C19424;
	Tue, 24 Mar 2026 21:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388614;
	bh=A+Z/vJCLhHZ645gwvF15zsPEoiVSBmBKZuTnilVQ/pE=;
	h=Date:To:From:Subject:From;
	b=KFdMBU91STiGSFkBv7FIBI8Cv1/RWEuSQ2ZYdwy2ZGY0nELICOhQ4GTY6+7hb7mkh
	 4FxwwYgyUiDiExVgDolT0NUo1JJ7CXKSMtbWiURBjzsfIbGKm1t/5sWbejYPO5vfGr
	 kRtYYPxoOyKEfnAz8V06Y26Trh6qNAZ6PzYfJgoE=
Date: Tue, 24 Mar 2026 14:43:34 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch removed from -mm tree
Message-Id: <20260324214334.89D20C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: shstk: use the new common vm_mmap_shadow_stack() helper
has been removed from the -mm tree.  Its filename was
     x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


