Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494335F558
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970500; cv=none; b=WI64CrVvOdAV9Jood4AQxgpIsX9Us3Cwlp9/AI3FSZ4WT6N5D2YP9WIB34vRP+EZ38MlizskcRX2SvpgkNWF7lk0AawvGuyUoW76WQuZUdAPaqpW1c4whI3XOk1sawcrelAy5UZxUCvWIV5YdzjZvw1RMYWXqYBque6mS/56Nb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970500; c=relaxed/simple;
	bh=xtsbZxOE1rcj97CHavija3sx91jdpLGGDhz8bkLlJ5E=;
	h=Date:To:From:Subject:Message-Id; b=LkysmxYPKtcEOQOk7tuLX0qyULZyj+uUqqPyN20urCEj36rzP3ZdF08NjVn7+Moo7XzZV+9k9nh/P7XTAQfw2rbzvioH1/eF972BtKQRUXsFm6utSyvLQU6VwQDjOZSgzsKC3D6057uFBaV7yS6wTz68DPwBok6QZvwXah9Ui1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKKnGG5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKKnGG5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40354C43390;
	Tue, 23 Jan 2024 00:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970499;
	bh=xtsbZxOE1rcj97CHavija3sx91jdpLGGDhz8bkLlJ5E=;
	h=Date:To:From:Subject:From;
	b=SKKnGG5ZHMzyphwgFOCvLHG6J7Hleuq0XeS6p25LMhlti26JMye3A1PABUTd0TCke
	 EoOW3j2eTLQ354wCVxfql64fYnSY5uhKr6EL9igW3NmswpUPd9pSTYiy0N+eGSOOuC
	 FUWUDhDjHWvy/BiiLcu8ZVmynTZlX5cwd0nAk1l4=
Date: Mon, 22 Jan 2024 16:41:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-pass-pte-to-copy_present_pte.patch added to mm-unstable branch
Message-Id: <20240123004139.40354C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: pass PTE to copy_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-pass-pte-to-copy_present_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-pass-pte-to-copy_present_pte.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: pass PTE to copy_present_pte()
Date: Mon, 22 Jan 2024 20:41:57 +0100

We already read it, let's just forward it.

This patch is based on work by Ryan Roberts.

Link: https://lkml.kernel.org/r/20240122194200.381241-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-pass-pte-to-copy_present_pte
+++ a/mm/memory.c
@@ -959,10 +959,9 @@ static inline void __copy_present_pte(st
  */
 static inline int
 copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
-		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		 struct folio **prealloc)
+		 pte_t *dst_pte, pte_t *src_pte, pte_t pte, unsigned long addr,
+		 int *rss, struct folio **prealloc)
 {
-	pte_t pte = ptep_get(src_pte);
 	struct page *page;
 	struct folio *folio;
 
@@ -1104,7 +1103,7 @@ again:
 		}
 		/* copy_present_pte() will clear `*prealloc' if consumed */
 		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
-				       addr, rss, &prealloc);
+				       ptent, addr, rss, &prealloc);
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
_

Patches currently in -mm which might be from david@redhat.com are

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch
arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
risc-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

