Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FE44746BB
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667837; cv=none; b=ENb3I54SHcgzuv+c+LiHVkS6kwnRhJQOa1CB+qLLT1G7X9VnMeTpCD4/FZ8F3avkNttMNc74qO9BjDfYgEVSjei5mWZFjwJ0UPh9Az9D0FoX6DCEnqqMLjCTzRO3tCqo9Vp+wU125WvjOKfuRwYYWi2sa/rizRo1mn4GSvTYxRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667837; c=relaxed/simple;
	bh=VbRLnJtojewE32wQPC5kplYpnBQltLWmJ8tPQWuovKQ=;
	h=Date:To:From:Subject:Message-Id; b=Ep2l262jbhgPB49aSXdxiYoIJnd43TOtqYXZl5aCmFLtORP3neze6fE7cHSFYvwsIKea5ApKwshF0G0bwkYhAOXQJeTM3s4KhfwqobO9aZiytUSWC9DCpTQCTLeNmMVtQp6N45/nnFvYP7/GxjcOPhA5HFAMwwnT921WyQaXN8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LzyXpx78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LzyXpx78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D307D1F00AC4;
	Tue, 21 Jul 2026 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784667832;
	bh=cyDWXk+gtrmrdh5Rh08Lvk8k0g3wi7mVGWEAUvf+MHQ=;
	h=Date:To:From:Subject;
	b=LzyXpx78OJ8dSAsanlpkYmTk8MvVqJ9GY/+YCVPLNM9CxJ8C+RFBrtdFsP41jsC47
	 At5LyN6z5WUF1XAVxIO8iQQxSyHPV3oKxM1WElbNQ2qEFLGwGLoyRZ1WIYqSVxN2nB
	 GzmOWmmNdhyIExpsgkiTfvA5XZBVyHnqZsFMzYEI=
Date: Tue, 21 Jul 2026 14:03:52 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch added to mm-new branch
Message-Id: <20260721210352.D307D1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: remove early_ioremap_reset() call and __late_* macros
has been added to the -mm mm-new branch.  Its filename is
     arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

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
@@ -110,9 +110,6 @@ void __init early_fixmap_init(void);
 
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

arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch
mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

