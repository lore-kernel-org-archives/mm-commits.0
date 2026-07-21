Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE56473C80
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667835; cv=none; b=P2E5bgXwr5GBRzXw9Rli28vH9e2ckwjMXOJdT6dfPeTP+lUt31ZCEl7+61aeotZQnr/eJFFW/xjflrNbiw/bVXN4pZKNTh365pAtGyiXqo7gPhGsX2HV+L0opMyHE9vJ1EmalSr3SOgxcWcJRVr3G1O8UZGI/zH8sGjAafmOURI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667835; c=relaxed/simple;
	bh=6+LKXwBpnOpJyDYDCnJIKqMRwWltEweEeiI+sCJ1l8I=;
	h=Date:To:From:Subject:Message-Id; b=Y6hTT7CxsTwUk31XcOtLqCiAGLpEjzgLcgOyGuapiSz4ko8NG72ULtcdH42SCYgngjr3/v0eYDmejboc8DmfbhhRQ8ulfSb+vgXHyrBOoCmfRYqc5XsaJI8MdtZHgeMNAlDfalA/bSGK2tK0zi2GwWhte3IRTwynNa2OP25G5e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjwqjLba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjwqjLba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A671F00A3D;
	Tue, 21 Jul 2026 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784667830;
	bh=bfklzVwUo5ug2nCPJic9b26Mj2sEM88vszYPCQKUiC4=;
	h=Date:To:From:Subject;
	b=GjwqjLbao6ETe/T/nzeWUeCQSbYlNQ2aDNgwiOQeGRzdwqcWhpt8GOxmKd4Y7Bxuc
	 7wwFwuipwhjkMNWocWmNuY6vL7l/otdOo8DIONQ4INtn1pEZLOqQhCFJaLqZIO9KuD
	 b/rDmkrVNCSUp/9pBxtRE7gKzx1h1TySA7UtBAeY=
Date: Tue, 21 Jul 2026 14:03:50 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch added to mm-new branch
Message-Id: <20260721210350.D6A671F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()
has been added to the -mm mm-new branch.  Its filename is
     riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch

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

arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch
mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

