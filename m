Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9991B364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388613; cv=none; b=UVA6ECm5W04u8dsqSjNm5vdpmpHg8MU/tIm8MkDgnSiWGLeIm5LurZhcWgo3lHIUfgEewi6IV9QId6wdUn3agd4xj5tKnQwPfWYRrIXSWDGRVU2ABXeDs4pAEcZrSE5S3g6jNyyrv5+LVs0604RamEvGrkm7VhOZoZedt/BRU8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388613; c=relaxed/simple;
	bh=i5MMQKGEUUPnn/aH52WowpuHr6c1I/EgcjobXjvYncY=;
	h=Date:To:From:Subject:Message-Id; b=hOhCv2SyrVmnqI+QojocbN+dDnTSzVPkgolTMlpUfoTZY9WBYUWjmgPYySQh6y5sGzuTHZEEwp4Sw0hwsOb0Pph50ycojKCw0vo/9HJ9p0Klk1F+I2GA9ArqXAIPjOZZFpSOufAxMbI/QvLD1eN74AKMMKQFHdNhIBiBn/d+wY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OC/lrtxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OC/lrtxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28806C19424;
	Tue, 24 Mar 2026 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388613;
	bh=i5MMQKGEUUPnn/aH52WowpuHr6c1I/EgcjobXjvYncY=;
	h=Date:To:From:Subject:From;
	b=OC/lrtxJYHHErG3834POemhMbpkgFNT4o4plo9yfp0YtAvS/4XY4bPJEhC8AsBLvl
	 +k28tvMqW4U7fVm13urln5owW/fRsFrwlbQRCAA4rebp/k3AUutVe+a+RLFQt2Nhz4
	 LjCa2vAFd3tcrzNOXpoHdjwEWCUiLNwSPKxM8mOM=
Date: Tue, 24 Mar 2026 14:43:32 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch removed from -mm tree
Message-Id: <20260324214333.28806C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: shstk: use the new common vm_mmap_shadow_stack() helper
has been removed from the -mm tree.  Its filename was
     riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: riscv: shstk: use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:14:00 +0000

Replace part of the allocate_shadow_stack() content with a call to
vm_mmap_shadow_stack().  There is no functional change.

Link: https://lkml.kernel.org/r/20260225161404.3157851-4-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/usercfi.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/riscv/kernel/usercfi.c~riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper
+++ a/arch/riscv/kernel/usercfi.c
@@ -230,17 +230,7 @@ int restore_user_shstk(struct task_struc
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long populate;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
-	mmap_write_unlock(mm);
+	addr = vm_mmap_shadow_stack(addr, size, 0);
 
 	if (!set_tok || IS_ERR_VALUE(addr))
 		goto out;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


