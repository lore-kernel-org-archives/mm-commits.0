Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343312F069E
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 19:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159729; cv=none; b=JMQ1Ppfo5z9xiODkbHquWXyWWc8ldvHeWyhrHpTuBX8gKN958tLPedr9bcG+gbGVh8iy4xE+zJOMASB2ma81LVWH9n2yR5sj7Y+6zgzuYdsD/Li0yjtuMfLBE6bZ36eQtkJ5GJ+uhIUfOjUxaQPWi4zO4K1hdgu8nhpYv+E/Rhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159729; c=relaxed/simple;
	bh=MTgQobNaJY4dgZiqPDTxbTZQHR9A0NalSdD3E9Q1ceI=;
	h=Date:To:From:Subject:Message-Id; b=f8dudM+P8/ZH7PszUGt6PbYe5WH00hXVe07DRqdPfCT0GdXJxVXTOQHXK3/YpG2ErGhaRoU/QwqzVJYrdkU/0TTfB93iWOBxFj/H+WOiEgB5KEkLhaBtHkFjKPGTS4/ubjT1zrXaRyi+EzibtzBEXH9R5FG69A3wpYa1nY7AIZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gM2QLujB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gM2QLujB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2536C4CEF7;
	Wed, 22 Oct 2025 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159729;
	bh=MTgQobNaJY4dgZiqPDTxbTZQHR9A0NalSdD3E9Q1ceI=;
	h=Date:To:From:Subject:From;
	b=gM2QLujBcvm8PjSM2DSF8H9FrgWvTiCB3Na8NZ2/O5n4gjZ1BEapwaqXbxL3V6K33
	 m9nsNgN1/9fQwMsI3JAIe6AYVWvjGMk4D+D8GHGErxp1HLjy6Dq+8nsZkTKO2LSkD1
	 IOJeLna1Q2A5D2bWPRIpU9ccjI5XFbQY8tztjiT4=
Date: Wed, 22 Oct 2025 12:02:08 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pure-page-table-freeing-function.patch added to mm-new branch
Message-Id: <20251022190208.F2536C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce pure page table freeing function
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-pure-page-table-freeing-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-pure-page-table-freeing-function.patch

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: introduce pure page table freeing function
Date: Wed, 22 Oct 2025 16:26:31 +0800

The pages used for ptdescs are currently freed back to the allocator in a
single location.  They will shortly be freed from a second location.

Create a simple helper that just frees them back to the allocator.

Link: https://lkml.kernel.org/r/20251022082635.2462433-6-baolu.lu@linux.intel.com
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

 include/linux/mm.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-introduce-pure-page-table-freeing-function
+++ a/include/linux/mm.h
@@ -3039,6 +3039,13 @@ static inline struct ptdesc *pagetable_a
 }
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
 
+static inline void __pagetable_free(struct ptdesc *pt)
+{
+	struct page *page = ptdesc_page(pt);
+
+	__free_pages(page, compound_order(page));
+}
+
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
@@ -3048,12 +3055,10 @@ static inline struct ptdesc *pagetable_a
  */
 static inline void pagetable_free(struct ptdesc *pt)
 {
-	struct page *page = ptdesc_page(pt);
-
 	if (ptdesc_test_kernel(pt))
 		ptdesc_clear_kernel(pt);
 
-	__free_pages(page, compound_order(page));
+	__pagetable_free(pt);
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-add-a-ptdesc-flag-to-mark-kernel-page-tables.patch
mm-actually-mark-kernel-page-table-pages.patch
x86-mm-use-ptdesc-when-freeing-pmd-pages.patch
mm-introduce-pure-page-table-freeing-function.patch
mm-introduce-deferred-freeing-for-kernel-page-tables.patch

