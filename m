Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107C1624E5;
	Mon, 17 Mar 2025 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188514; cv=none; b=YcjHqLQVMDYByodxmVSjkiz2P4PWh/pQ2kqwfceEAhQj9J5CCEANmvAj0fqJkMyXSzitOYjpIhV7ShR6XaWbtRNTW29bXtn0P5PLDE5os2L+aO/9rRU5LGYA2PWuRN4ZtzT5XIg+q6sETpewhdPtaRtjKhCwL+1Imj1kIPpSFoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188514; c=relaxed/simple;
	bh=EnZdhGBlhKVDXnmtgopckYNq+xfqNbOjj+q5tyDFwcM=;
	h=Date:To:From:Subject:Message-Id; b=ESnzaS4RlOmttluAI5v7WAWKGOcym1eZoOpFPakJvjt/kikTLfTHfvPCf1tOsnUH9wGL/IyP3ipl9H9CSYUV/E5yFSgMXnTbgSu81KIpJSRfPJaT/gGSNbM4VM0eZbRUNFdosKyaExobp6cXScmdr4QMXh3KJ8wXXFk9iqb+gAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YmblwWg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YmblwWg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D10FC4CEEC;
	Mon, 17 Mar 2025 05:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188514;
	bh=EnZdhGBlhKVDXnmtgopckYNq+xfqNbOjj+q5tyDFwcM=;
	h=Date:To:From:Subject:From;
	b=YmblwWg8qYmrNpbB8LO/CQXawBq3HnVFjT1lXJD+fw4T1aESxMKOsbyOyAYfJKbQo
	 eDTZ3lbBRvfedkbJ1IjlF+zTzxyf2ET5E9KOgoyN1Nvp7ucOFe1UzyqcOQh6VKm1rb
	 Rp2Ua8zSpMt1OEY+ljbIEoJj/lTb+SMIuQSjT65s=
Date: Sun, 16 Mar 2025 22:15:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch removed from -mm tree
Message-Id: <20250317051514.5D10FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
has been removed from the -mm tree.  Its filename was
     sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
Date: Mon, 3 Mar 2025 14:15:38 +0000

With commit 1a10a44dfc1d ("sparc64: implement the new page table range
API") set_ptes was added to the sparc architecture.  The implementation
included calling arch_enter/leave_lazy_mmu() calls.

The patch removes the usage of arch_enter/leave_lazy_mmu() since this
implies nesting of lazy mmu regions which is not supported.  Without this
fix, lazy mmu mode is effectively disabled because we exit the mode after
the first set_ptes:

remap_pte_range()
  -> arch_enter_lazy_mmu()
  -> set_ptes()
      -> arch_enter_lazy_mmu()
      -> arch_leave_lazy_mmu()
  -> arch_leave_lazy_mmu()

Powerpc suffered the same problem and fixed it in a corresponding way with
commit 47b8def9358c ("powerpc/mm: Avoid calling
arch_enter/leave_lazy_mmu() in set_ptes").

Link: https://lkml.kernel.org/r/20250303141542.3371656-5-ryan.roberts@arm.com
Fixes: 1a10a44dfc1d ("sparc64: implement the new page table range API")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h~sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -936,7 +936,6 @@ static inline void __set_pte_at(struct m
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	arch_enter_lazy_mmu_mode();
 	for (;;) {
 		__set_pte_at(mm, addr, ptep, pte, 0);
 		if (--nr == 0)
@@ -945,7 +944,6 @@ static inline void set_ptes(struct mm_st
 		pte_val(pte) += PAGE_SIZE;
 		addr += PAGE_SIZE;
 	}
-	arch_leave_lazy_mmu_mode();
 }
 #define set_ptes set_ptes
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

