Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A262629D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489899; cv=none; b=BY7WIJFkYSoy3SQvIutmKUIxHTVpqPNVluL4SGCOllX1f/Ysm8cjwMrMCUXxjE6IYebSYFnBz0MDQaRFicDKGhoMGAUp/iwZSFL4LlV8aw2rMsrq2gh+XP4XA2ba1PZr2aSonrnv4O8fqZo6wwuvGsK9U2ZIiJTmiYAYASVvohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489899; c=relaxed/simple;
	bh=6OLmz4oEmDW4mifRpEpCinFQNrE6s59WYr/1B2TdRtU=;
	h=Date:To:From:Subject:Message-Id; b=QoqgZMb0Q+FEi1jHhIoIvNfVJqWedPpK0hMcQB0NaiDOOidYHKryvWjjqbyKAZNuTXnKJAu4E9MqHjfKpswsF3pBbSayb/6Lfiwne5ar6VX2uefS6ejpfsP53ICDAv+QndJnEvAliEfI2rGNbBMiUkGsYw/9fE6z18jQAI7kxWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=esHl1Ibc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="esHl1Ibc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F809C4CEE7;
	Sun, 21 Sep 2025 21:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489899;
	bh=6OLmz4oEmDW4mifRpEpCinFQNrE6s59WYr/1B2TdRtU=;
	h=Date:To:From:Subject:From;
	b=esHl1IbcA2CBZsCIenQkLTox1k6iuhZYCKNGknxvU+9OKYypGPteUxhvs3ReLI7+x
	 quUe9h/wN2nFV+Ywj0M6qogpArZ0ndJEzMnaGhiX3k1aqW6wBktJO4XEYfQk8i2Zki
	 zwpjPdOzYGRn8B7rh7xm/fMkoS8HZPeiREuCJUK4=
Date: Sun, 21 Sep 2025 14:24:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-stop-calling-page_address-in-free_pages.patch removed from -mm tree
Message-Id: <20250921212459.6F809C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: stop calling page_address() in free_pages()
has been removed from the -mm tree.  Its filename was
     x86-stop-calling-page_address-in-free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: x86: stop calling page_address() in free_pages()
Date: Wed, 3 Sep 2025 11:59:17 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 arch/x86/mm/init_64.c          |    2 +-
 arch/x86/platform/efi/memmap.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-stop-calling-page_address-in-free_pages
+++ a/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(str
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 	}
 }
 
--- a/arch/x86/platform/efi/memmap.c~x86-stop-calling-page_address-in-free_pages
+++ a/arch/x86/platform/efi/memmap.c
@@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys,
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
 
-		free_pages((unsigned long) page_address(p), order);
+		__free_pages(p, order);
 	}
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


