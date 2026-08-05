Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1848530648C;
	Wed,  5 Aug 2026 03:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898973; cv=none; b=UUsjhOwNHNqfyfeKusVFXAtm5fOwndQlMt7akfoNDSozN0YXO4FHqGHS2az1iGFzeM+LoU5BYvm2snMJQCq5LcjHK7IZ7TT2A9oDhFR/xWAqddCIWbPTIs694l1CBwi7pOJ0kOxwXln5k8qRhQuiWLXAtutGex5AT+LFTZloHMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898973; c=relaxed/simple;
	bh=bQPVLpa92GiZw6yeXzKXXvUwu9qv4Pud018gNaIgCCc=;
	h=Date:To:From:Subject:Message-Id; b=ZQ0RI220yLh1ocmFYyBuZmSDvvJbJm9a2WWKa2Kj/IrRX01YSM4abQ1f8VoSZjcsILKRgEDffJkQqxlP/tVjtTqRjJWXxMR1Shww2VjpsIjH1G94dzxYWQW8H1U44wFxjplRTyZqMAo6aahxaUSFKmZaLVOR+SeJyJhNDEqIHQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xXzzU2NM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xXzzU2NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFA31F00A3A;
	Wed,  5 Aug 2026 03:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898971;
	bh=xPhOXXlS/dzYXN1Siddqx4V1IQvQihZ3dtpaj066hzU=;
	h=Date:To:From:Subject;
	b=xXzzU2NMuGJ3Za9rNwTuIW/Lf1IclvKZ7HbNo20X+KZot22G/J7mgVnYa33PhhKrh
	 vAQnfZ2b/Ne7pRM8+Z9p4im1d5g7kOnpO71jDR/DaAdeydZiGSYp/A/DhULS2Ity4K
	 5gVak4Po9a2ehZMIvmIYlYQunY2OXIGsO7MxoiLQ=
Date: Tue, 04 Aug 2026 20:02:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,monstr@monstr.eu,ramin.moussavi@yacoub.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] microblaze-restore-the-page-alignment-of-swapper_pg_dir.patch removed from -mm tree
Message-Id: <20260805030251.7CFA31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: microblaze: restore the page alignment of swapper_pg_dir
has been removed from the -mm tree.  Its filename was
     microblaze-restore-the-page-alignment-of-swapper_pg_dir.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ramin Moussavi <ramin.moussavi@yacoub.de>
Subject: microblaze: restore the page alignment of swapper_pg_dir
Date: Mon, 27 Jul 2026 23:58:23 +0200

microblaze handles TLB misses in software, and the handler builds the
address of the L1 entry by ORing the index into the page directory base
instead of adding it (hw_exception_handler.S):

		bsrli	r5, r3, PGDIR_SHIFT - 2
		andi	r5, r5, PAGE_SIZE - 4
	/* Assume pgdir aligned on 4K boundary, no need for
	   "andi r4,r4,0xfffff003" */
		or	r4, r4, r5
		lwi	r4, r4, 0		/* Get L1 entry */

The index is masked to the low 12 bits, so the OR only works if those bits
of the base are zero -- which is exactly the assumption the comment states
and the reason the masking of the base can be skipped.

swapper_pg_dir had no alignment directive of its own.  It was aligned
because it followed empty_zero_page in head.S, and that one carried the
.align 12:

	.section .data
	.global empty_zero_page
	.align 12
	empty_zero_page:
		.space	PAGE_SIZE
	.global swapper_pg_dir
	swapper_pg_dir:
		.space	PAGE_SIZE

Commit 6215d9f4470f ("arch, mm: consolidate empty_zero_page") removed
empty_zero_page from head.S, and with it the .align 12 that -- despite
sitting next to empty_zero_page -- was what page aligned swapper_pg_dir. 
Since then swapper_pg_dir lands wherever .data happens to put it, its low
bits are no longer zero, and every kernel TLB miss ORs the index into a
base with a nonzero offset.  The resulting L1 lookups read the wrong
words, no valid translation is ever installed, and the kernel spins in
exceptions long before it can print anything.  On qemu-system-microblazeel
(petalogix-s3adsp1800) the console stays completely silent at 100% CPU;
there is no oops and no guest error reported by qemu, which makes this
awkward to diagnose.

Give swapper_pg_dir the alignment it requires, rather than relying on a
neighbour to provide it.

microblaze has no noMMU variant left in mainline -- CONFIG_MMU is def_bool
y and mmu_defconfig is the only defconfig -- so this is not a corner case:
every mainline microblaze kernel since v7.1-rc1 fails to boot, including
the v7.1 release.

	v7.0:                    swapper_pg_dir = 0xc05fd000  (aligned)
	v7.1-rc1:                swapper_pg_dir = 0xc0603140  (offset 320)
	v7.1-rc1 + this fix:     swapper_pg_dir = 0xc0604000  (aligned)
	next-20260726:           swapper_pg_dir = 0xc0615140  (offset 320)
	next-20260726 + this fix: swapper_pg_dir = 0xc0616000  (aligned)

Verified on qemu-system-microblazeel (petalogix-s3adsp1800) with
mmu_defconfig and microblazeel gcc 12.5.0: v7.1-rc1 and next-20260726 both
print nothing at all without the fix, and both boot to userspace with it.

Link: https://lore.kernel.org/20260727215823.1422701-1-ramin.moussavi@yacoub.de
Fixes: 6215d9f4470f ("arch, mm: consolidate empty_zero_page")
Signed-off-by: Ramin Moussavi <ramin.moussavi@yacoub.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/head.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/microblaze/kernel/head.S~microblaze-restore-the-page-alignment-of-swapper_pg_dir
+++ a/arch/microblaze/kernel/head.S
@@ -39,6 +39,8 @@
 #include <asm/processor.h>
 
 .section .data
+/* The MMU requires a page aligned page directory. */
+.align 12
 .global swapper_pg_dir
 swapper_pg_dir:
 	.space	PAGE_SIZE
_

Patches currently in -mm which might be from ramin.moussavi@yacoub.de are


