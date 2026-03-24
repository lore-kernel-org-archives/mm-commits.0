Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179353659F9
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388612; cv=none; b=nB1c9KnTz8NafoEOfTljZashZkvd9bvqPqNsDRr5e+zysqjaVwIwiMvK8d64ctQUnOJR3WUSREFkfSLdzEcYVJ6VHgidMqxXLr1gG08+Y/vu9d7Rto2ySr9hK9I0Lr8UN3k4Ip+NN63CT0GKS6Frir6BZBGde9I9FiGjk0t7t6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388612; c=relaxed/simple;
	bh=v3O63PO0yAuWF6q4F9uzHpjjaQg0yBF3cy2ymfs+Tgs=;
	h=Date:To:From:Subject:Message-Id; b=Raf1acKGu1XCryUZf9l0dfHMBPebRnrLKlnR3nzL+EU3MpEYbRCd6Xacqwd6BLnR85rJOk/Miw/Qi9fTtik08dWNanOGtRae9C2HXqG+mtmB7xOoTX1f+NkfdFxEQL5GwT+cCLf3OpUOz9x1pBO5Zurd/UQufELBw0t5/hdlf+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S5azKXsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S5azKXsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40BBC19424;
	Tue, 24 Mar 2026 21:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388611;
	bh=v3O63PO0yAuWF6q4F9uzHpjjaQg0yBF3cy2ymfs+Tgs=;
	h=Date:To:From:Subject:From;
	b=S5azKXsMKesx08Q6jcblF1aigZY9Ws4n99cDWO51YjmVq8PNebHWK98ee86ODfuDU
	 beMa3p2IA52IaudduXjKY3hceaOFN5mcTjXBp9U8I71tgdt/bktWXQDiONUc7tYDoR
	 lc3Vv+KqqqQx6TWHeOBNkabS00AWKXFQyC09Tx9M=
Date: Tue, 24 Mar 2026 14:43:31 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper.patch removed from -mm tree
Message-Id: <20260324214331.C40BBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: gcs: use the new common vm_mmap_shadow_stack() helper
has been removed from the -mm tree.  Its filename was
     arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm64: gcs: use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:13:59 +0000

Replace the arm64 map_shadow_stack() content with a call to
vm_mmap_shadow_stack().  There is no functional change.

Link: https://lkml.kernel.org/r/20260225161404.3157851-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/gcs.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/arch/arm64/mm/gcs.c~arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper
+++ a/arch/arm64/mm/gcs.c
@@ -12,19 +12,7 @@
 
 static unsigned long alloc_gcs(unsigned long addr, unsigned long size)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long mapped_addr, unused;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	mapped_addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-			      VM_SHADOW_STACK | VM_WRITE, 0, &unused, NULL);
-	mmap_write_unlock(mm);
-
-	return mapped_addr;
+	return vm_mmap_shadow_stack(addr, size, 0);
 }
 
 static unsigned long gcs_size(unsigned long size)
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


