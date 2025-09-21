Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A11129D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489901; cv=none; b=gf5Q079A+XD07kS4vTZgVueQwpPf9lfyka6zcruNEzAi+Xj9E/L/Tm/soswhV7PkAWUPp6HdTVTaTUciyXEXQzZhsX9xPnqC4XNnQIVrLlraR6jIB4JAzdwfSnGmjzfnuOCrStwUSiXE4dwqVUeC9qf5GO66BTjUL5XB9emEmYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489901; c=relaxed/simple;
	bh=cRMnYOhOjc/+5DhCYaZYU3ijUkmS8jxDHh3n6KW4aU8=;
	h=Date:To:From:Subject:Message-Id; b=MKb1JP2MgiLC74PKw2AumRSQefnRApZCiUzbMSjpe69NnBhARFgU26FAXXIP3ECxMveVfV3b5DaeB1K8r6n3X+yGNqckd+Hr8lqWbiIvsih0pBiu/78MzjW+t4YgLfPTT/21qMx+3zAtMVwtn5A6AlziAd3fTUk01ZgRmTsF1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omJhcTM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omJhcTM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE95C4CEE7;
	Sun, 21 Sep 2025 21:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489901;
	bh=cRMnYOhOjc/+5DhCYaZYU3ijUkmS8jxDHh3n6KW4aU8=;
	h=Date:To:From:Subject:From;
	b=omJhcTM5iDtcZDdUppRppfirj0i2Ib6T6YlNwVFMf3kX1Wp4miXUpJKWlXwWjbsWj
	 O+E8fAkv5YBiKOswDhT2ThyGfubV4PYT9JhH3ZIg6dkOSw8D6qSV4/TR8xawAiRBQR
	 FyjAENBONVoVwaVwyxvP2dBey1Jov+wUaIsaxwF0=
Date: Sun, 21 Sep 2025 14:25:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-stop-calling-page_address-in-free_pages.patch removed from -mm tree
Message-Id: <20250921212501.0EE95C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: stop calling page_address() in free_pages()
has been removed from the -mm tree.  Its filename was
     riscv-stop-calling-page_address-in-free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: riscv: stop calling page_address() in free_pages()
Date: Wed, 3 Sep 2025 11:59:18 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
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


