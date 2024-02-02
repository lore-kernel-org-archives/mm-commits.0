Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631F613F009
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876058; cv=none; b=eCj3MVaalAShHW/BNAO4EoUal0vg+SQQzA4FLfBjyB4N81iTzAqM6LX/5jlah1WORZVzc3heshOFjgO1aQnoxGv7oUyV1X9t8Xb6N4F2AaN6b7hL6VbKF7umKLXMWUqZ0h4GwZva4e3AxOfmKidaubbrY0F9KkBYoIOlEOsdVxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876058; c=relaxed/simple;
	bh=HnvaoXDXmW/FRsNvf4bQOH9LdkQ0kxx5MzRD5pJ4YyM=;
	h=Date:To:From:Subject:Message-Id; b=Vcyg5YoGjA26pZdQV7FwhL6dOR/RIjSlv9eyBwbe2lA2HK6Neo4SIOrge6h1L1Rahfxv2MEnIX699KyMFrmDNhKEQvjWtziRXN9OVGDBR2bRiF1XD+sjgYVV4z2X9gb+3k4vdfgbgcrSkyzFbQeIO5MG9dSMwS45FxrjXvDKpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QjOxh9Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QjOxh9Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD8FC433F1;
	Fri,  2 Feb 2024 12:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876056;
	bh=HnvaoXDXmW/FRsNvf4bQOH9LdkQ0kxx5MzRD5pJ4YyM=;
	h=Date:To:From:Subject:From;
	b=QjOxh9ZeldMJcKC9Ba7jxsYKP0CF5osHO0e0uY+IclR73jeoDpo7I3pQhHAV+gDYp
	 7LwbfVal1OaFrYrH7uJtd9uWmFHqMtO7IXu5E4jjjdQ/7oJD9GvvyidnVCn1y1eoWn
	 WaOKgwCMumLsLK28rHyW9zXTKKp9RmgEKUjwTMMo=
Date: Fri, 02 Feb 2024 04:14:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-use-pte_next_pfn-in-set_ptes.patch added to mm-unstable branch
Message-Id: <20240202121416.5AD8FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: use pte_next_pfn() in set_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-use-pte_next_pfn-in-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-use-pte_next_pfn-in-set_ptes.patch

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
Subject: powerpc/mm: use pte_next_pfn() in set_ptes()
Date: Mon, 29 Jan 2024 13:46:44 +0100

Let's use our handy new helper. Note that the implementation is slightly
different, but shouldn't really make a difference in practice.

Link: https://lkml.kernel.org/r/20240129124649.189745-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-use-pte_next_pfn-in-set_ptes
+++ a/arch/powerpc/mm/pgtable.c
@@ -220,10 +220,7 @@ void set_ptes(struct mm_struct *mm, unsi
 			break;
 		ptep++;
 		addr += PAGE_SIZE;
-		/*
-		 * increment the pfn.
-		 */
-		pte = pfn_pte(pte_pfn(pte) + 1, pte_pgprot((pte)));
+		pte = pte_next_pfn(pte);
 	}
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

arm-pgtable-define-pfn_pte_shift.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
riscv-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch
arm-mm-use-pte_next_pfn-in-set_ptes.patch
powerpc-mm-use-pte_next_pfn-in-set_ptes.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

