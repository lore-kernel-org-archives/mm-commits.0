Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207853;
	b=KY8UzrpPeVUL5vr75teIoi66SFSvJAjSRrjU7dei9bKhY6shkh2C1vDqb8whwNDYPYeQ
	 vtOyyrUU1VeEjemfszdr9uAcckP3p18ludpq8NOQ2BANWRKiWd9C7qAtmMkAPGlGVNQsO
	 +bX0pUy1IKJstrXoCzQ4h30zYbyxqeyV0It3cna2MMDueztO41+38JpxFqe0+skp9ZmQy
	 jsCPlYpslXiAx0lrCuttGlnWwU22qczhh3iESiQuGSnEKDd9Mb/BwA4X9AY09IXmwR+bu
	 x5w5XcPZ71vRO8FclQETpwl+Y1PBoY0gYrtchmSHqkRg0rzlPid4WCQTClky0oQ0uTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207853;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lLeb4u5BAKegy9+jHfPxXx5XY/YyEwJzJex/FIWwGcE=;
	b=OvC5Sgt7XKaPTGFV7vjI/oKiDQO3YxhC3tNexwuFLMeJ5Z+9a0HMs9v+5BlqGcC/ZcJU
	 owb2D26uGHIOkq8+5Fdbf8/MS5UEh8XK1GIEq22tz2Ke4O+pnR5ABUkntuF/O9dRbjAkv
	 DF1BtkVBY1vxJfp1yCxpRojhl38gy2E8KCztk9EJouLvHHVjfvzLVe0pQah36pUbiB9Iq
	 KahdI8Qr3ykiSPlUQwDsilYW6MQimZ7Uxozg+8WRkOCeCZDfoBCG2WtVPKu8ERt5nPVQj
	 6vaeyisDsf6flO7J2NwDT/9lwtI86AQ4e/wQ66e6k2f+vRYgg3HbDspwzquBAqglshQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m7RufXVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8998606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m7RufXVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0B41F0089F;
	Mon,  9 Nov 2026 07:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207852;
	bh=lLeb4u5BAKegy9+jHfPxXx5XY/YyEwJzJex/FIWwGcE=;
	h=Date:To:From:Subject;
	b=m7RufXVTrKQkhTBvUd75X/HIjPfj14DZ6x318WzcPD5Oftq3+1cy0PA0HU2MCMCOf
	 fk0k/bgL5/Z75UdDQPj6Sdru7YrwVzbTQqWKV7LQd7E1nOf0WR5xJI4SxcKK4TchfR
	 Kn63qxgQveTLlcxjeGgQSDpAqUH3XhrM9llL5WRY=
Date: Sun, 08 Nov 2026 23:04:12 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,dev.jain@arm.com,david@kernel.org,
	chleroy@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,jiangwen6@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch added to mm-new branch
Message-Id: <20261109070412.7A0B41F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wen Jiang <jiangwen6@xiaomi.com>
Subject: mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Sat, 07 Nov 2026 21:49:51 +0800

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Link: https://lore.kernel.org/20261107134953.748622-9-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Dev Jain <dev.jain@arm.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 mm/vmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection
+++ a/mm/vmalloc.c
@@ -3622,6 +3622,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4141,11 +4149,7 @@ void *__vmalloc_node_range_noprof(unsign
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are

arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch
powerpc-8xx-add-vmap_pte_set_huge.patch
mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch
arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch
mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

