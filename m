Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA38288D0;
	Tue, 28 Jul 2026 01:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785200810; cv=none; b=i6WN195sl7DAc50H8QUU6AidGOFGfJAhBtiM4rc0UIw6la0cZ8Szz8JrKtdwrlyEZykRF6Jc43CJY635dNeMYzS49xqQ7139S8tK6kpw8kLSpx7EE/N1QaukAzNA8COlAiEsWNILhF0JGB2SAUzcxJk5rmuIdba18SGGPuxONRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785200810; c=relaxed/simple;
	bh=ttRv57eGRGz47Yhw29jnyw8VQn/g+pdoE423HcknotE=;
	h=Date:To:From:Subject:Message-Id; b=LEgQEXkyyJsbZphZhjqRoZ7EGEKxI8VI12hr9npXzmt+3B5LC2vYrZdxnyqd/Zm9mZnh/ZGu5bFdQKVU8roKY3o8z4NR/KQnzwJxfspl/WLP07maDzaFV81tEDx2/mnQny8QCzd+dxU9EG5YKxUAkX1tHwZ3qqEXaH1Z7qrR5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+xAtS6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+xAtS6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783711F000E9;
	Tue, 28 Jul 2026 01:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785200804;
	bh=pVWWuZDXjf2IKePGdaVPQpq7g6fvA+aO7Ijm9BrELRo=;
	h=Date:To:From:Subject;
	b=x+xAtS6afS4M0s1uk/DwDtPi3OvxtB4QE9W/At9hoNEEVmiMlpYkbMn/Soihaoa3/
	 F+rhfSjnkGlrnnBCTEnHWbQy8RwxKFY8tWZeuXM5hr32VHtCcCorOPxE63NwBu/Lmm
	 CVx0MRy75j1Cl4/D3T/b624qBwm1HTf5y4VxYTPU=
Date: Mon, 27 Jul 2026 18:06:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,monstr@monstr.eu,ramin.moussavi@yacoub.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + microblaze-restore-the-page-alignment-of-swapper_pg_dir.patch added to mm-hotfixes-unstable branch
Message-Id: <20260728010644.783711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: microblaze: restore the page alignment of swapper_pg_dir
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     microblaze-restore-the-page-alignment-of-swapper_pg_dir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/microblaze-restore-the-page-alignment-of-swapper_pg_dir.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

microblaze-restore-the-page-alignment-of-swapper_pg_dir.patch

