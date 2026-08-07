Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF323B6363
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068143; cv=none; b=besYCirqG1g1wcZGaWuYkD6uVDy3wya4gZd1Ya9+O470iiTv5RtgiylPy9d6mxv35t047QgJa1z2bNL/HRFKy+o5M4vSweA7Vb3tBlcYERzwno2BNA0gBcP/e6o1Dq0k3yzd6WVRxzdxw3jldjSwsw4QQ0ECd9UOAErWFMOJrEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068143; c=relaxed/simple;
	bh=ZEm+yTchscB16KNh3+jeYFYlmPv03b+A/Kgx86q1i7E=;
	h=Date:To:From:Subject:Message-Id; b=ffPsGlxiSO245uT7YwmWpn9rS+Xd8pbP7szrITTq7R1+Cgsh1WlYPtVRwxjPPtJ/yTIiCLo+9fOnKxvn84DpRRt4vJ/zvot3ycxrYJ70AH+O3cRlPLilpDYLzwUCrRKNtDl/hmV/lZHMzQU9DHTvVT/8bE4Y9HjLfOikZ2425f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oBX9HKRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oBX9HKRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129161F000E9;
	Fri,  7 Aug 2026 02:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068142;
	bh=80e+x469L9aOrvP99YJK1xHHit5Rs28I1aaKF2PdOCY=;
	h=Date:To:From:Subject;
	b=oBX9HKRAgo4ogK7s3tbWqZof6ZI5MuHmyTNMakBaEdSmElr4u+0E/4O/r+zajXvJ3
	 dFE4yCi5y+eCcF/CYeIHDKLRXxEqHdHa1i9r2RfEI7T3rMwNqFF1Ys8qW6EhQ+Ck9W
	 pN4NJoF93S1j5kUJjPXTTCTRwJYHBSjqZrn4OH3M=
Date: Thu, 06 Aug 2026 19:02:21 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch removed from -mm tree
Message-Id: <20260807020222.129161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()
has been removed from the -mm tree.  Its filename was
     riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()
Date: Thu, 9 Jul 2026 02:06:46 +0900

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called.  riscv never calls it because
__set_fixmap() works before and after paging_init().  So remove them.

No functional change.

Link: https://lore.kernel.org/20260708170647.362562-3-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/fixmap.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/riscv/include/asm/fixmap.h~riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap
+++ a/arch/riscv/include/asm/fixmap.h
@@ -55,9 +55,6 @@ enum fixed_addresses {
 
 #define __early_set_fixmap	__set_fixmap
 
-#define __late_set_fixmap	__set_fixmap
-#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
-
 extern void __set_fixmap(enum fixed_addresses idx,
 			 phys_addr_t phys, pgprot_t prot);
 
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-sparse-correct-init-section-annotations.patch
mm-kconfig-make-flatmem-depend-on-numa.patch
mm-page_ext-remove-pgdat_page_ext_init.patch

