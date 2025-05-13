Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E741D6DB4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119279; cv=none; b=EbHzjm/AAqFMKGEjr658uycSK8OcaDPUCax9MEJur6DhF7e6LNGLzOPnUe+iBcjnltROgif1+upGvhReBTMDLacQYBiFH3UlZCuwpHEnOIh7pZyg6yMDNxE+UbHS6uA3ffLJc1x/LOEWAUwGImdae6XPetYxaVCRW8Q7flJ8/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119279; c=relaxed/simple;
	bh=AvP++gXNBMADhQkGv8q3AGUEsy0f/OrerdAM8fZAPCs=;
	h=Date:To:From:Subject:Message-Id; b=uFni/6O99JFBm0wR2Y9VS5erscwqunBFVr8Xg0hKJ3UObjd5mmTachwnMrs0Eqlvx7R8gn6+/yPETLsxd5yDoI+Cj0EqQnl41w9pGpf7eWtGL9KntBQ11okMTMSCbf1D2V4atMqT5hdeuqfQHGWp+EjehZhYGxDnX22d4WnZXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDl8mfkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDl8mfkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13182C4CEE4;
	Tue, 13 May 2025 06:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119279;
	bh=AvP++gXNBMADhQkGv8q3AGUEsy0f/OrerdAM8fZAPCs=;
	h=Date:To:From:Subject:From;
	b=uDl8mfkjIgAf1yV0KEKDYALRLCD71KBb9RfveGaVcs3yniUj6JHs5sJFHUYaUSq1d
	 PeLkuFx1F0ZghaNm2tZQ4IY4JEeFwy0U1NDcMAuQy9hlz1xbQ5ZFMEpQ5ZtQRUI/Ce
	 3SoBXAdz8LjfWO0opnUmH4c/nbsP+kaQOohlBkHQ=
Date: Mon, 12 May 2025 23:54:38 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-implement-for_each_valid_pfn-for-config_flatmem.patch removed from -mm tree
Message-Id: <20250513065439.13182C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: implement for_each_valid_pfn() for CONFIG_FLATMEM
has been removed from the -mm tree.  Its filename was
     mm-implement-for_each_valid_pfn-for-config_flatmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm: implement for_each_valid_pfn() for CONFIG_FLATMEM
Date: Wed, 23 Apr 2025 14:33:38 +0100

In the FLATMEM case, the default pfn_valid() just checks that the PFN is
within the range [ ARCH_PFN_OFFSET ..  ARCH_PFN_OFFSET + max_mapnr ).

The for_each_valid_pfn() function can therefore be a simple for() loop
using those as min/max respectively.

Link: https://lkml.kernel.org/r/20250423133821.789413-3-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/asm-generic/memory_model.h~mm-implement-for_each_valid_pfn-for-config_flatmem
+++ a/include/asm-generic/memory_model.h
@@ -30,7 +30,15 @@ static inline int pfn_valid(unsigned lon
 	return pfn >= pfn_offset && (pfn - pfn_offset) < max_mapnr;
 }
 #define pfn_valid pfn_valid
-#endif
+
+#ifndef for_each_valid_pfn
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
+	for ((pfn) = max_t(unsigned long, (start_pfn), ARCH_PFN_OFFSET); \
+	     (pfn) < min_t(unsigned long, (end_pfn),			 \
+			   ARCH_PFN_OFFSET + max_mapnr);		 \
+	     (pfn)++)
+#endif /* for_each_valid_pfn */
+#endif /* valid_pfn */
 
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are


