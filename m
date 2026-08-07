Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AE03B960C
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068144; cv=none; b=YfzJynyMaSKwHN8Hvs2IBkKR+zeyh01Bn4O8p99a+e06QZE9KAYca34fC0yOMKtNd8f+7kr7mpyqITRBERUxxQGqkC32ZuE8cmP2EIDKWeKx6Cdi8l5Zp+FoGU5O7ZhSmgwk6Ep+hM8J8vKkW3krFC+11c57mromRjBx0HPFeSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068144; c=relaxed/simple;
	bh=VgtRbyJfcJwWm1i7QoXpDS49XaANLzLkH9spn4NMmlo=;
	h=Date:To:From:Subject:Message-Id; b=Y1bo6eKMJaO9hGl2/88TeJ2S298n/D4+DzcFmTJ7Qwg3CggtTQYULyCHMwkTFOczUyig7hR8pUDG+W9839RLarcW3hWkMnrrehoXIJLWxXTzqPVh1VObOgZfy2G1WSOmHF4Vx7jFwUxrHjA9gxPY7iLACTB/qwM8x41YPuWa5Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTUFAuC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTUFAuC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490CA1F00A3A;
	Fri,  7 Aug 2026 02:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068143;
	bh=GliXqQPyCMaBWCihLUj6fekNaFRZsCqWbFPHeaHjAOo=;
	h=Date:To:From:Subject;
	b=DTUFAuC7JW1jGtMb8OR08pKjw6dSntGhSwDMBJUZsSNrqkWBoTimxIIdpXSiMD0Ch
	 LMdqIMDYlBYm/Jy8WH7TMywuzqYeBSDJaLvhqwphzGWrsKa1s4mUoop8v82Bej+BY4
	 KHZEZXdclhG2fwHsU2YfENAXY03xFS0Bb02YAPdI=
Date: Thu, 06 Aug 2026 19:02:22 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch removed from -mm tree
Message-Id: <20260807020223.490CA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: remove early_ioremap_reset() call and __late_* macros
has been removed from the -mm tree.  Its filename was
     arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: arm64: remove early_ioremap_reset() call and __late_* macros
Date: Thu, 9 Jul 2026 02:06:47 +0900

On arm64, __early_set_fixmap(), __late_set_fixmap() and
__late_clear_fixmap() are all __set_fixmap().  Calling
early_ioremap_reset() changes nothing.  So remove the call and the macros.

No functional change.

Link: https://lore.kernel.org/20260708170647.362562-4-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Acked-by: Will Deacon <will@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/fixmap.h |    3 ---
 arch/arm64/kernel/setup.c       |    2 --
 2 files changed, 5 deletions(-)

--- a/arch/arm64/include/asm/fixmap.h~arm64-remove-early_ioremap_reset-call-and-__late_-macros
+++ a/arch/arm64/include/asm/fixmap.h
@@ -114,9 +114,6 @@ void __init early_fixmap_init(void);
 
 #define __early_set_fixmap __set_fixmap
 
-#define __late_set_fixmap __set_fixmap
-#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
-
 extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
 #include <asm-generic/fixmap.h>
--- a/arch/arm64/kernel/setup.c~arm64-remove-early_ioremap_reset-call-and-__late_-macros
+++ a/arch/arm64/kernel/setup.c
@@ -347,8 +347,6 @@ void __init __no_sanitize_address setup_
 
 	request_standard_resources();
 
-	early_ioremap_reset();
-
 	if (acpi_disabled)
 		psci_dt_init();
 	else
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-sparse-correct-init-section-annotations.patch
mm-kconfig-make-flatmem-depend-on-numa.patch
mm-page_ext-remove-pgdat_page_ext_init.patch

