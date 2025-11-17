Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA592264CA
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343220; cv=none; b=o7N6WXHs51rJNER+rYOXdmaQ1MuU7tzze2TMMNGx6mGNzTJBiUe2AyGzpcsthIxArQrLk0VCiitu2U6C6WmtNS59dHFdlY+ty3qM+PlV+30idRKHsCi3ygcJ4mX27+FxPYss+QMyRlR6z3qv6zTNSZAgGvET6Rvyqw8KUZWfui0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343220; c=relaxed/simple;
	bh=V0eq+rh7ccgaZhC3pXWlvYHqy3DmeHf6yi46TXQnsKk=;
	h=Date:To:From:Subject:Message-Id; b=PYJ0rEchknC4Y1/8C3m8rjjrGM495VvVdt6FtmLLzJ1MonG0MGX5yjy47S8ubMFPhuauU0VhWeDn2EFp1orK8AAHKtFhk7ixh+ZC+OBZbMjkGoFAsLD9LzxV+blPYZD1uq4SfP15NAeRJ+5mYjN1C25Kkm6Iv4bQPmm29yyfS8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dNMpfTeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dNMpfTeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606E1C113D0;
	Mon, 17 Nov 2025 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343219;
	bh=V0eq+rh7ccgaZhC3pXWlvYHqy3DmeHf6yi46TXQnsKk=;
	h=Date:To:From:Subject:From;
	b=dNMpfTeVGXO7jH5//22aeDZPx94zgvbJ/U+JOA/hUYhjAMU/wg44ecgxN6GsOmnsY
	 Hj5Iat7xPF5qpCFtXgslc+3iGbfg9u9/O7kdyNrsQ7aQ8ty+hHf/eDMmZdwIWCajns
	 85bfH/YjHxfEeNzEqSTAtvNHQO+gXKAdsUqfY614=
Date: Sun, 16 Nov 2025 17:33:38 -0800
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,bp@alien8.de,baolu.lu@linux.intel.com,apopple@nvidia.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pure-page-table-freeing-function.patch removed from -mm tree
Message-Id: <20251117013339.606E1C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce pure page table freeing function
has been removed from the -mm tree.  Its filename was
     mm-introduce-pure-page-table-freeing-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3046,6 +3046,13 @@ static inline struct ptdesc *pagetable_a
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
@@ -3055,12 +3062,10 @@ static inline struct ptdesc *pagetable_a
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


