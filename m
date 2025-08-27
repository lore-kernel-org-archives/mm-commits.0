Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422EFC1D
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260018; cv=none; b=A1ltn+/tS8VHuNruCQ6LUU06lHGZQ7IW3hTxR7B+k0q10uTjLXWRv2CXm7EG+mJth42gV55qIrv0OG5Vb8FpjeUfaOxkTCLXnIQc1s0a7q/mSRspbUPrOmQ3iVuOyRqPtRy7x7zk5k//Qo1/fN5Cm05tXzDILCP8hn8oBJoYCCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260018; c=relaxed/simple;
	bh=cJSvCkBd+AijRZJ8mDYUarJ108TpI7kh1PsnnHpf2JM=;
	h=Date:To:From:Subject:Message-Id; b=soD6X/eVvHSx5QaC9Xkryfa3guKevoigYQyfXnUOZ/HmvpbNQSuIiwuAUJfm4mc1w6ksrYa3dauEyUJB9vzDb2HxAik9cTdrLZIHv2qV9wKrdJe0c5dup74DMzbJjRKr+z/YLnavrb7TdSe980YQY6SzyUsISw5k9VY7NPXDsIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYDpNEtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYDpNEtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DA0C4CEF1;
	Wed, 27 Aug 2025 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756260018;
	bh=cJSvCkBd+AijRZJ8mDYUarJ108TpI7kh1PsnnHpf2JM=;
	h=Date:To:From:Subject:From;
	b=IYDpNEtFRsmK0mW3x5b6YU6I0SpHp3kNuTt9q7CS4AaWiZk6TN8bQlQpp/S4ry6ig
	 7V7XD+fkL7K9tMqDsH2VEAdUgw7wxb91TYgxygMuG0jNtYur+1KF69pvr4/4knSfXw
	 gZvQGuMU9RyhTm48NDoZYcXBle6Z4krTpCfB35Bg=
Date: Tue, 26 Aug 2025 19:00:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-stop-calling-page_address-in-free_pages.patch added to mm-new branch
Message-Id: <20250827020018.54DA0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: stop calling page_address() in free_pages()
has been added to the -mm mm-new branch.  Its filename is
     riscv-stop-calling-page_address-in-free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-stop-calling-page_address-in-free_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: riscv: stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:14 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250826205617.1032945-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-stop-calling-page_address-in-free_pages
+++ a/arch/riscv/mm/init.c
@@ -1624,7 +1624,7 @@ static void __meminit free_pud_table(pud
 	if (PageReserved(page))
 		free_reserved_page(page);
 	else
-		free_pages((unsigned long)page_address(page), 0);
+		__free_pages(page, 0);
 	p4d_clear(p4d);
 }
 
@@ -1646,7 +1646,7 @@ static void __meminit free_vmemmap_stora
 		return;
 	}
 
-	free_pages((unsigned long)page_address(page), order);
+	__free_pages(page, order);
 }
 
 static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-tag-kernel-stack-pages.patch
mm-page_alloc-add-kernel-docs-for-free_pages.patch
aoe-stop-calling-page_address-in-free_page.patch
x86-stop-calling-page_address-in-free_pages.patch
riscv-stop-calling-page_address-in-free_pages.patch
powerpc-stop-calling-page_address-in-free_pages.patch
arm64-stop-calling-page_address-in-free_pages.patch
virtio_balloon-stop-calling-page_address-in-free_pages.patch

