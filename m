Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC02C10F4
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560463; cv=none; b=lTvJMeJ4WwPR5Jk8+N0VH+mOtYN1C0MkXV9BSdNg03LsBO9KpP4nw0QbDRDnl7k4jsduJbMC1X4qvdmkzHfARFhwYy3DQ3y8a5l8ItU+amtg0oCfQFS+HqeT6JTDdw0YbDNfb5uQxJIj/M+edfrvgXiYIhv8ph9i5eglt6UbYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560463; c=relaxed/simple;
	bh=qKhJ0rArJ+Yju65cq4CddNtLX9xozEATXj0TEZoSSZA=;
	h=Date:To:From:Subject:Message-Id; b=QuigFnk5S5HDST4V1ZbHPk6UdWQBTBj+b6Cf4hB8fsMwbV/Hhm2NJoAdq8fc/T/f+g58p+0meIlPuNKImRn2YHt7VQ/cwtwm9WEALQDaPw2p1/jhmQfVt8gzF+TP9RLtB792e8baQnNGcfqbB5DRyWanqe+v8Kgkv2NkrLJbzUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFkrUU0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFkrUU0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1764C4CEC7;
	Tue, 17 Sep 2024 08:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560463;
	bh=qKhJ0rArJ+Yju65cq4CddNtLX9xozEATXj0TEZoSSZA=;
	h=Date:To:From:Subject:From;
	b=lFkrUU0qxmWCpfmh8SMuSgPajVZhF40eBov0RALZNN5R5rU9CLtnhluW/POgCGxR8
	 pBhwrgdPiNJKJv8n7Eb+jv7Kq/E4PdxLsf/VEu5Wxs488LjPW+58ii5fdH3y78ggOL
	 xqNQ/hrP1Co8TFy4umbbgx6LWFGEaIL/mcVdTpNU=
Date: Tue, 17 Sep 2024 01:07:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-thp-orders-for-pfnmaps.patch removed from -mm tree
Message-Id: <20240917080742.A1764C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow THP orders for PFNMAPs
has been removed from the -mm tree.  Its filename was
     mm-allow-thp-orders-for-pfnmaps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: allow THP orders for PFNMAPs
Date: Mon, 26 Aug 2024 16:43:38 -0400

This enables PFNMAPs to be mapped at either pmd/pud layers.  Generalize the
dax case into vma_is_special_huge() so as to cover both.  Meanwhile, rename
the macro to THP_ORDERS_ALL_SPECIAL.

Link: https://lkml.kernel.org/r/20240826204353.2228736-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 +++---
 mm/huge_memory.c        |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/huge_mm.h~mm-allow-thp-orders-for-pfnmaps
+++ a/include/linux/huge_mm.h
@@ -76,9 +76,9 @@ extern struct kobj_attribute thpsize_shm
 /*
  * Mask of all large folio orders supported for file THP. Folios in a DAX
  * file is never split and the MAX_PAGECACHE_ORDER limit does not apply to
- * it.
+ * it.  Same to PFNMAPs where there's neither page* nor pagecache.
  */
-#define THP_ORDERS_ALL_FILE_DAX		\
+#define THP_ORDERS_ALL_SPECIAL		\
 	(BIT(PMD_ORDER) | BIT(PUD_ORDER))
 #define THP_ORDERS_ALL_FILE_DEFAULT	\
 	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
@@ -87,7 +87,7 @@ extern struct kobj_attribute thpsize_shm
  * Mask of all large folio orders supported for THP.
  */
 #define THP_ORDERS_ALL	\
-	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DAX | THP_ORDERS_ALL_FILE_DEFAULT)
+	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
 
 #define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
 #define TVA_IN_PF		(1 << 1)	/* Page fault handler */
--- a/mm/huge_memory.c~mm-allow-thp-orders-for-pfnmaps
+++ a/mm/huge_memory.c
@@ -97,8 +97,8 @@ unsigned long __thp_vma_allowable_orders
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma))
-		supported_orders = THP_ORDERS_ALL_FILE_DAX;
+	else if (vma_is_special_huge(vma))
+		supported_orders = THP_ORDERS_ALL_SPECIAL;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


