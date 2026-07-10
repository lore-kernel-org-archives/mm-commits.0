Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC05386C0C;
	Fri, 10 Jul 2026 20:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715439; cv=none; b=JH2ml29UgntRlDtG71ajeVrIM+fB2divI8IO3ByT++Ef3BijpTL+l0lko6f0MQegcScQeFXFcrQJ4jS8MrFwlFIM7GecJeRJmrLJMErZRdkpZDPZCycIulrndFs2OU+lxcBPWzvjjN9juSdUII8In88lI8qLF8fpuCcHj2jTMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715439; c=relaxed/simple;
	bh=R7LRuc74n5LW/RBCNp2eG+ofzRJBmko4ipVfFnO4NcA=;
	h=Date:To:From:Subject:Message-Id; b=LvP/Ma/HPKz7EL/HPQc4FL9rF4h6bkvD/qK4XycUHSK/4xJmJXOFGSAgfl3UgYIXlm7s2UCEuCUP7eXA+VF9dn/9ttZTYzvhSdawsjc8qM4Ek6DOAjGp43RRTB2pWcBv0fxS9KmlBSvykLrlv14BLr4o9S7FIQ6QdD872+s9yVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=irotu+9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="irotu+9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162981F00A3A;
	Fri, 10 Jul 2026 20:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783715438;
	bh=hCnA6rEGGa45TF6auX/WM9XguXoir8aRCVKt8jDXcH0=;
	h=Date:To:From:Subject;
	b=irotu+9r9j+v7c4jiWa/PLA0lqctuw/ufLQdky8H8P4mTORYZNbSQ9Ys/tm17D4Nx
	 zOHrhEgjE7CwgdMLh46sKSCGPGl+PrpFFQAGRjAxqB9fVM+ZY7RUUyZ1eYERKchA/M
	 bhWGEY/3Y4Xa53QZXY4+rGpHzZ0eIye/uMhw/StQ=
Date: Fri, 10 Jul 2026 13:30:37 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,toshi.kani@hpe.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,liam@infradead.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch added to mm-new branch
Message-Id: <20260710203038.162981F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ptdump: always stabilise against page table freeing using init_mm
has been added to the -mm mm-new branch.  Its filename is
     mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/ptdump: always stabilise against page table freeing using init_mm
Date: Fri, 10 Jul 2026 14:29:21 +0100

x86 and arm64 invoke ptdump_walk_pgd() with non-init_mm mm whilst still
walking kernel page table ranges.

For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
first passing current->mm, and the second passing efi_mm (we reach kernel
mappings that init_mm protects for current->mm due to x86 cloning shared
kernel page tables for arbitrary mm's).

arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
for efi ranges against efi_mm.

The init_mm mmap lock is used to stabilise page table freeing against
ptdump, so take a nested lock on init_mm to ensure that we are correctly
stabilised.

We take this after mmap write locking the non-init_mm mm.  Nothing
acquires the init_mm lock first before locking an arbitrary mm, so no
deadlock is possible.

Other fixes have been sent which update the two cases which can cause
races with ptdump in init_mm ranges to acquire the init_mm mmap write lock
- vmap and x86 CPA huge page promotion.

For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
already provides exclusion against init_mm for the vmap case, which this
patch also pairs with.

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Link: https://lore.kernel.org/20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org
Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/ptdump.c~mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm
+++ a/mm/ptdump.c
@@ -178,11 +178,18 @@ void ptdump_walk_pgd(struct ptdump_state
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch

