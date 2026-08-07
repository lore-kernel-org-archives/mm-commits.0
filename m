Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057E03B9D80
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068142; cv=none; b=pJKxbwLo2PkK+4Hh0W1AHFq6MDFYpMoBrR1DSu+x3Y3MATuQ7oGXWwGua+x8u4/RHQgMKkeNSP0t6NJUk9EFbLyZFIWlPyaWfn4piEwZSpqT/xD8FVuf5z9/HSK2WoRcFzZ1lLho/qLTIL1YQVC1SqSDg/OaK6/rOvauFZy1eFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068142; c=relaxed/simple;
	bh=KEg4nBEAQa2jFMvS22i6whOhAPKFSADe1oingO1KAng=;
	h=Date:To:From:Subject:Message-Id; b=fMZGUi9DyJn/O1dOxpiVym52u5CEknXEkyVAD3gnHIi4SJQs2OQ/HKCaXWuqvg9VkP7PM4fA97igHe1Y+k7OEqY2doB8okNZQAPvXbMfBnN2n3zMVcNlHHY1P1mwixZRj6nhArY5UP7M7nvgZu9eMwhyox+IJXir8hc7ZVAxiKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQc3Plp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQc3Plp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0BB1F00A3A;
	Fri,  7 Aug 2026 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068140;
	bh=8+y4A8yjirzjJXU9J3nEaslMZcAPOU4J+SJG8fDJOhY=;
	h=Date:To:From:Subject;
	b=nQc3Plp2mh7AtE6kanFl1nKzV/ys796oJYt3WFxNP39U2o8k93eQhr+cI6duWbGkn
	 7u0YPcZ8AvA8RZreogHwyfDmgJAcNFh+z284g5PN+LexfnZRRKqbkszrh6xjYLyc9G
	 af1bukVJ0KooZ1Q9Y0Q3VNQB5yFJcnzBeT0Qx+KM=
Date: Thu, 06 Aug 2026 19:02:20 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch removed from -mm tree
Message-Id: <20260807020220.CE0BB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/early_ioremap: clarify early_ioremap_reset() semantics
has been removed from the -mm tree.  Its filename was
     mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/early_ioremap: clarify early_ioremap_reset() semantics
Date: Thu, 9 Jul 2026 02:06:45 +0900

Patch series "mm/early_ioremap: clarify and clean up
early_ioremap_reset()".

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called, but the comment above them does not
say anything about that.  So arm64, riscv and powerpc, whose
__set_fixmap() works before and after paging_init(), describe the same
situation in three different ways:

                 calls reset    defines the macros
        arm64    yes            yes
        riscv    no             yes
        powerpc  no             no

Patch 1 documents when early_ioremap_reset() needs to be called and that
only architectures calling it need to define the macros.

Patches 2 and 3 remove the unneeded riscv macros, which are unreachable,
and the arm64 reset call and macros, which change nothing.

No functional change.


This patch (of 3):

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called.

arm64, riscv and powerpc all have a __set_fixmap() that works before and
after paging_init(), so they do not need to call early_ioremap_reset() or
define the macros, but they describe the same situation in three different
ways:

                 calls reset    defines the macros
        arm64    yes            yes
        riscv    no             yes
        powerpc  no             no

The existing comment is vague and allows all three.  Replace it with
comments that make it clear when the reset and the macros are needed.

No functional change.

Link: https://lore.kernel.org/20260708170647.362562-1-ekffu200098@gmail.com
Link: https://lore.kernel.org/20260708170647.362562-2-ekffu200098@gmail.com
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

 mm/early_ioremap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/early_ioremap.c~mm-early_ioremap-clarify-early_ioremap_reset-semantics
+++ a/mm/early_ioremap.c
@@ -47,15 +47,19 @@ pgprot_t __init __weak early_memremap_pg
 	return prot;
 }
 
+/*
+ * Only architectures whose early_ioremap() must stop using __early_set_fixmap()
+ * after paging_init() need to call this.
+ */
 void __init early_ioremap_reset(void)
 {
 	after_paging_init = 1;
 }
 
 /*
- * Generally, ioremap() is available after paging_init() has been called.
- * Architectures wanting to allow early_ioremap after paging_init() can
- * define __late_set_fixmap and __late_clear_fixmap to do the right thing.
+ * Only architectures that call early_ioremap_reset() need to define
+ * __late_set_fixmap() and __late_clear_fixmap(), which early_ioremap() uses
+ * instead of __early_set_fixmap() after the reset.
  */
 #ifndef __late_set_fixmap
 static inline void __init __late_set_fixmap(enum fixed_addresses idx,
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-sparse-correct-init-section-annotations.patch
mm-kconfig-make-flatmem-depend-on-numa.patch
mm-page_ext-remove-pgdat_page_ext_init.patch

