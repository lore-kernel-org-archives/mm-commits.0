Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F485956
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824869; cv=none; b=lG7LKPAfSzgHmc4PFjaV+gJEhOGyykIzvguPcVYTn9J2PXYqOMO54PZ9pdPgwv2yXOlTkob88T3GY0c1dF1MKjDavDvfewnDwZUUIkEVu2D05uaAR9TJFqfeOz1JbWXky3wRUNfXZ1RRmDicwYtngM8dtunxcSELJEFuR6r27OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824869; c=relaxed/simple;
	bh=jdWYVLfPRY3mDFzTJBkC+kbmCI+nLqIWLf5Xdxn/XmM=;
	h=Date:To:From:Subject:Message-Id; b=JOFiGpPou77LihiPGqDGP1gvkM7nNL87xk/DYMRNQeUEzB1MitR8343G1OycpJ+IIjkRnaZTtKN5D6ZUi24mHOlUO3YuAybRPEo5E7ZAtDKnu7e6ACDSPJ4vJ9YzCBub2fym88/1+U1whfE2yBYrgmRNkdxciBYdb8ms/GMomKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z3iF1cjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z3iF1cjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F74C4AF07;
	Fri, 12 Jul 2024 22:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824869;
	bh=jdWYVLfPRY3mDFzTJBkC+kbmCI+nLqIWLf5Xdxn/XmM=;
	h=Date:To:From:Subject:From;
	b=Z3iF1cjWwK8cC1MKOsGYZLd2P7UbNUj/Jcp/vF4sjdv7fReNHBNxwcXvfog4N18uY
	 mqQ3pK4gjnkOsagu7ZG41GsRAUXVbb542zqq7VwWn6nuUrBmveDWR0x4ARsn3D8/F/
	 6RLz5CWb1pjlxHiNtFlqd8nAKUl7ATd+klcNRO1U=
Date: Fri, 12 Jul 2024 15:54:28 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-remove-_page_psize.patch removed from -mm tree
Message-Id: <20240712225429.54F74C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: remove _PAGE_PSIZE
has been removed from the -mm tree.  Its filename was
     powerpc-mm-remove-_page_psize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/mm: remove _PAGE_PSIZE
Date: Tue, 2 Jul 2024 15:51:21 +0200

_PAGE_PSIZE macro is never used outside the place it is defined and is
used only on 8xx and e500.

Remove indirection, remove it and use its content directly.

Link: https://lkml.kernel.org/r/c41da3b0ceda7311a50f0391cc4d54302ae15b74.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/32/pte-44x.h  |    3 ---
 arch/powerpc/include/asm/nohash/32/pte-85xx.h |    3 ---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h  |    5 ++---
 arch/powerpc/include/asm/nohash/pte-e500.h    |    4 +---
 4 files changed, 3 insertions(+), 12 deletions(-)

--- a/arch/powerpc/include/asm/nohash/32/pte-44x.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/32/pte-44x.h
@@ -75,9 +75,6 @@
 #define _PAGE_NO_CACHE	0x00000400		/* H: I bit */
 #define _PAGE_WRITETHRU	0x00000800		/* H: W bit */
 
-/* No page size encoding in the linux PTE */
-#define _PAGE_PSIZE		0
-
 /* TODO: Add large page lowmem mapping support */
 #define _PMD_PRESENT	0
 #define _PMD_PRESENT_MASK (PAGE_MASK)
--- a/arch/powerpc/include/asm/nohash/32/pte-85xx.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/32/pte-85xx.h
@@ -31,9 +31,6 @@
 #define _PAGE_WRITETHRU	0x00400	/* H: W bit */
 #define _PAGE_SPECIAL	0x00800 /* S: Special page */
 
-/* No page size encoding in the linux PTE */
-#define _PAGE_PSIZE		0
-
 #define _PMD_PRESENT	0
 #define _PMD_PRESENT_MASK (PAGE_MASK)
 #define _PMD_BAD	(~PAGE_MASK)
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -74,12 +74,11 @@
 #define _PTE_NONE_MASK	0
 
 #ifdef CONFIG_PPC_16K_PAGES
-#define _PAGE_PSIZE	_PAGE_SPS
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_SPS)
 #else
-#define _PAGE_PSIZE		0
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED)
 #endif
 
-#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE)
 #define _PAGE_BASE	(_PAGE_BASE_NC)
 
 #include <asm/pgtable-masks.h>
--- a/arch/powerpc/include/asm/nohash/pte-e500.h~powerpc-mm-remove-_page_psize
+++ a/arch/powerpc/include/asm/nohash/pte-e500.h
@@ -65,8 +65,6 @@
 
 #define _PAGE_SPECIAL	_PAGE_SW0
 
-/* Base page size */
-#define _PAGE_PSIZE	_PAGE_PSIZE_4K
 #define	PTE_RPN_SHIFT	(24)
 
 #define PTE_WIMGE_SHIFT (19)
@@ -89,7 +87,7 @@
  * pages. We always set _PAGE_COHERENT when SMP is enabled or
  * the processor might need it for DMA coherency.
  */
-#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE)
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE_4K)
 #if defined(CONFIG_SMP)
 #define _PAGE_BASE	(_PAGE_BASE_NC | _PAGE_COHERENT)
 #else
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


