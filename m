Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A139C224249
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343216; cv=none; b=VvvYiGYhKOr3pg/mspVVe2fDXHJE8tzBK7TL5NsfaR970WpME03aHJRLUCpt/HK6ITc9M7pGdnZStdTpKoSyIBQe/niYoqPyYdPX2/FYYhuC8Tonc0iSCoPaFL9oKpmd/BWQYcY4c8tV/F1RXLY8ZF09hTOwnSYzx4ODE8DwPnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343216; c=relaxed/simple;
	bh=2jNmdCqG4Iin5gf4JukLKUAMyh18agu3AqDojiBdEVQ=;
	h=Date:To:From:Subject:Message-Id; b=G+tJlRar1jLo0eXgUM193pt59Pni/2PwqRzaQCWcmBx1FSfcgoGyKOx7+NTTjL01OyP7qU91+GYy9zqlKLJq1RLdhxX76kLWDCXXTqKkIWRDr1DM2W/bBTAF9KSQrry3hElUaE82rWeMBm3WPHlo3t1mMcJkGS0HjzaL3MWclCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cgzbp92m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cgzbp92m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5653BC2BC86;
	Mon, 17 Nov 2025 01:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343216;
	bh=2jNmdCqG4Iin5gf4JukLKUAMyh18agu3AqDojiBdEVQ=;
	h=Date:To:From:Subject:From;
	b=cgzbp92mnFceToAf/lu3fnfgS41gdO6Pz4UY0kjpIsUUM+zj5wscH1CSCuK1lex0D
	 aV+6ooNOf4K/4OKcRHXoX9tN67twdjSWp5st3ZmXIcsubNziY1FF1Us9MdSvyuBVKZ
	 2WqybIpPhS29cw9EDUpoILRTogFId4atQH6SidqE=
Date: Sun, 16 Nov 2025 17:33:35 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-actually-mark-kernel-page-table-pages.patch removed from -mm tree
Message-Id: <20251117013336.5653BC2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: actually mark kernel page table pages
has been removed from the -mm tree.  Its filename was
     mm-actually-mark-kernel-page-table-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: actually mark kernel page table pages
Date: Wed, 22 Oct 2025 16:26:29 +0800

Now that the API is in place, mark kernel page table pages just after they
are allocated.  Unmark them just before they are freed.

Note: Unconditionally clearing the 'kernel' marking (via
ptdesc_clear_kernel()) would be functionally identical to what is here. 
But having the if() makes it logically clear that this function can be
used for kernel and non-kernel page tables.

Link: https://lkml.kernel.org/r/20251022082635.2462433-4-baolu.lu@linux.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
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

 include/asm-generic/pgalloc.h |   18 ++++++++++++++++++
 include/linux/mm.h            |    3 +++
 2 files changed, 21 insertions(+)

--- a/include/asm-generic/pgalloc.h~mm-actually-mark-kernel-page-table-pages
+++ a/include/asm-generic/pgalloc.h
@@ -28,6 +28,8 @@ static inline pte_t *__pte_alloc_one_ker
 		return NULL;
 	}
 
+	ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __pte_alloc_one_kernel(...)	alloc_hooks(__pte_alloc_one_kernel_noprof(__VA_ARGS__))
@@ -146,6 +148,10 @@ static inline pmd_t *pmd_alloc_one_nopro
 		pagetable_free(ptdesc);
 		return NULL;
 	}
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define pmd_alloc_one(...)	alloc_hooks(pmd_alloc_one_noprof(__VA_ARGS__))
@@ -179,6 +185,10 @@ static inline pud_t *__pud_alloc_one_nop
 		return NULL;
 
 	pagetable_pud_ctor(ptdesc);
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
@@ -233,6 +243,10 @@ static inline p4d_t *__p4d_alloc_one_nop
 		return NULL;
 
 	pagetable_p4d_ctor(ptdesc);
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
@@ -277,6 +291,10 @@ static inline pgd_t *__pgd_alloc_noprof(
 		return NULL;
 
 	pagetable_pgd_ctor(ptdesc);
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __pgd_alloc(...)	alloc_hooks(__pgd_alloc_noprof(__VA_ARGS__))
--- a/include/linux/mm.h~mm-actually-mark-kernel-page-table-pages
+++ a/include/linux/mm.h
@@ -3057,6 +3057,9 @@ static inline void pagetable_free(struct
 {
 	struct page *page = ptdesc_page(pt);
 
+	if (ptdesc_test_kernel(pt))
+		ptdesc_clear_kernel(pt);
+
 	__free_pages(page, compound_order(page));
 }
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


