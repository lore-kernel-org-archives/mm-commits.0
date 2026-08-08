Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2D37E5D9
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786208292; cv=none; b=ZCA0SR+eBFYCEEH9W3pRsmaAyu8v86l7BZAH0U08HAjPWdMMCo5+qtZdqWDHsLvyCrfRfPwsInSnoICMDZkVbul6fygkp1XC73sC6c2DP78K1SBNOieiXt6vG1TazJFk+iyovQj5IAE8+rvn8lTEIhfhsXTuJyTcvr1Qm3uOifM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786208292; c=relaxed/simple;
	bh=kO7jtWrn11AqMdSVossrpmcbTArs5vX200tK84ZYyTQ=;
	h=Date:To:From:Subject:Message-Id; b=b6YygcmR9hTwo9VaK4erhj5wsa4Yt7CHzseHdenPKezPbGak5otRjf6Atke+log0DSwakQkTatDZy3nc0V0FccbDI/AA0rZzY0CFdGloMRsfGtsFdgG4H7ZhK6xqec0BmXc5DJb9aUtOt0ghSXlx3j/P4qY8IV+XMXTJENUwDhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HyXcVPrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HyXcVPrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4142C1F000E9;
	Sat,  8 Aug 2026 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786208291;
	bh=0PAxdxpFMbaj3GTv1z1dr58Vw40w2SN0juO5OEDoYl8=;
	h=Date:To:From:Subject;
	b=HyXcVPrwlqCe384glQhWHee1C9wgfjOapc/Fzm/NT1KZeAjx45+3elVqXPsu3n+ke
	 n9rB575VJfaGhIz72FAHjP7OWc8FyqErYiTeKT7ElHMzgY918Y4lLIcEd8nxvx3CDB
	 E9AB+2UHSC9qznoF6+tfB0CZyxBLahcKCqRK6Ky0=
Date: Sat, 08 Aug 2026 09:58:10 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch removed from -mm tree
Message-Id: <20260808165811.4142C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Subject: mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Wed, 15 Jul 2026 20:08:11 +0800

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Link: https://lore.kernel.org/20260715120813.3609949-6-jiangwen6@xiaomi.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection
+++ a/mm/vmalloc.c
@@ -3576,6 +3576,14 @@ void vunmap(const void *addr)
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
@@ -4087,11 +4095,7 @@ void *__vmalloc_node_range_noprof(unsign
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

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are

mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix.patch

