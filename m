Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B15231A32
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343221; cv=none; b=cafrfVUwFa7XNylJj0IINOH76DT5IrNHEzvHKgLfzVVWjHzYiTnsKl40VdxPaLoEejGHZzybEAA+gG3elcAQ0cBdyevL4e2aNbRrhcU0PDmcp2Q0EMYPhyY2sjan0X/EGifpuu1nNzMP/yJ830WFyDynyoz3muiCt5UQ2ofixQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343221; c=relaxed/simple;
	bh=QP7vXLcAaXJ4Y7477eFBwB979XihV92qsHywzpmhKtU=;
	h=Date:To:From:Subject:Message-Id; b=D7xWA/rD6dhxuyBn/1jfP2ZyOyRp9FmVXZCfCh4t458WwOjg+6GI5yYOMZYsihiowW/CxxTDELNY/hn2XWu6Bol6GmViWd8rsfAujPm4aVCgEuU/2UOa9c/ZLpuI1dKi5peAaQD5arhmxx6AzFOR3MIdxu/RPU0pW/mFGEE2DaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EP99GsQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EP99GsQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3130C4CEF1;
	Mon, 17 Nov 2025 01:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343220;
	bh=QP7vXLcAaXJ4Y7477eFBwB979XihV92qsHywzpmhKtU=;
	h=Date:To:From:Subject:From;
	b=EP99GsQKVxGEwFZLLAmxiIiEPgUmIQcwkQDabjM1RMIZtXmXQzhCK0PyEz0vq10wo
	 7MEX3Tz6q/+4elxnOegjgspjpJ1qLXq+OyqZoyngsyME7axHqicajXclRiQLuCCpWH
	 /yagNBLt4Ym8KMHozjkUm8tFxN/sPOqAGa1AhqkE=
Date: Sun, 16 Nov 2025 17:33:40 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,dave.hansen@intel.com,bp@alien8.de,apopple@nvidia.com,baolu.lu@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-use-pagetable_free.patch removed from -mm tree
Message-Id: <20251117013340.D3130C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: use pagetable_free()
has been removed from the -mm tree.  Its filename was
     x86-mm-use-pagetable_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lu Baolu <baolu.lu@linux.intel.com>
Subject: x86/mm: use pagetable_free()
Date: Wed, 22 Oct 2025 16:26:32 +0800

The kernel's memory management subsystem provides a dedicated interface,
pagetable_free(), for freeing page table pages.  Updates two call sites to
use pagetable_free() instead of the lower-level __free_page() or
free_pages().  This improves code consistency and clarity, and ensures the
correct freeing mechanism is used.

Link: https://lkml.kernel.org/r/20251022082635.2462433-7-baolu.lu@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c        |    2 +-
 arch/x86/mm/pat/set_memory.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-use-pagetable_free
+++ a/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(str
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		__free_pages(page, order);
+		pagetable_free(page_ptdesc(page));
 	}
 }
 
--- a/arch/x86/mm/pat/set_memory.c~x86-mm-use-pagetable_free
+++ a/arch/x86/mm/pat/set_memory.c
@@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(str
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		__free_page(ptdesc_page(ptdesc));
+		pagetable_free(ptdesc);
 	}
 }
 
_

Patches currently in -mm which might be from baolu.lu@linux.intel.com are


