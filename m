Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF429D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489903; cv=none; b=O78K8WEwAco5++PYUJG5omhGqKI5nWUYvw8vow8z4ExfjX4nlFoc+E4ybp/rS5Wp0lPNxFFrW2dTKUCnKdxRVrL1ExIcf1vZny2G6cudnu5Q/Eu3Pik5zesh3JDXjlMxFA5+crPK36MJRvMKYz6rSj6DSYvykmaWLJFDCxUHb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489903; c=relaxed/simple;
	bh=h8r949LI766HLkIouNNqUAcgE7gEm7JbKfV2IRce2wI=;
	h=Date:To:From:Subject:Message-Id; b=nu9fWaSa55737UjR3eAd4cCl5oBNDTKzzFr1lxhvFrEdncv8i2PZkID7HjPqTRVu0Wx/4/pYC9criXh39waFDcvYy0YIF0Bg8ib6zOhHAc9ZMqdnJVI8qkCuzyQIPJej4WDkbwU3LyTevnUB+3h88ZNorcT5lTsG3QMexLjpcBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJvfHwKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJvfHwKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D613CC4CEE7;
	Sun, 21 Sep 2025 21:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489902;
	bh=h8r949LI766HLkIouNNqUAcgE7gEm7JbKfV2IRce2wI=;
	h=Date:To:From:Subject:From;
	b=xJvfHwKGKJz8fjlaRd6/vbKUIPie06uMXcnUR1GXnVekMJwqh96r0jVIxiPDICpyh
	 KrD3oStpx1gVEATM+4ORgDPtXW/EH8NUD6GwprgbsquHCtzpC0ot3c5Lay542s5TFl
	 Rp6ZXisiGWV4Mc6c1BguzI8HGimvjTRYS4GzknWU=
Date: Sun, 21 Sep 2025 14:25:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-stop-calling-page_address-in-free_pages.patch removed from -mm tree
Message-Id: <20250921212502.D613CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: stop calling page_address() in free_pages()
has been removed from the -mm tree.  Its filename was
     powerpc-stop-calling-page_address-in-free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: powerpc: stop calling page_address() in free_pages()
Date: Wed, 3 Sep 2025 11:59:19 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
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
Cc: SeongJae Park <sj@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-stop-calling-page_address-in-free_pages
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages
 		while (nr_pages--)
 			free_reserved_page(page++);
 	} else
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 }
 
 static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


