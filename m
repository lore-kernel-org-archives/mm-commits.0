Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF0534CDE
	for <mm-commits@vger.kernel.org>; Fri, 11 Oct 2024 22:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728685935; cv=none; b=f1sdEGBKTlHedwQ92uLYmcM6ZvT8jkMNCqfI+hlwwr8qFEaJkAVLnWC+M4kH20YUZsCrpglXpcSisV+JKnfsXvCCCLddHYdjvu6a8hsB2pSNxYMhloaYslmt0t7Iqmu762imO3gB52j0ap/e8bQt2zDRJ12XlI9QPypS0Q/pQZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728685935; c=relaxed/simple;
	bh=ti51qc/yXjYakJ/9O4wgLkbSycuChp8Yja63CRQ2k40=;
	h=Date:To:From:Subject:Message-Id; b=H6fy1Wtbv0bPM8PGWr725H7/S4phlJxnHkdaul41uXSgm343bV/VcSglX+W4K8mjskJKopyihb6k+HlMwVzdlBB+byzVhbxSoJE24HTwd5JKTaLs+zxXjAg1azQa/LGFuzHo7wnSyqRUF69HE17AAPNAfOLf5SKl8XuTQzUMX6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e+mUNrtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e+mUNrtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365F0C4CEC3;
	Fri, 11 Oct 2024 22:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728685935;
	bh=ti51qc/yXjYakJ/9O4wgLkbSycuChp8Yja63CRQ2k40=;
	h=Date:To:From:Subject:From;
	b=e+mUNrtM9R2DQCVy9S9jc/XrTcHxjG4OoekVx9eEJEn11+m8llU3Qbi9mFsvneo99
	 FqjdJdbsPuP2LvXU2tVEiom1kxhlwbQiWzF2poNhU/5cSzLqDEaBW5w2tNA4K1Ms+h
	 d9qpvZXOU94xbdOfmIkTuZ5DIkWrcz02jh9DojI0=
Date: Fri, 11 Oct 2024 15:32:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-module-enable-rox-caches-for-module-text-fix.patch added to mm-unstable branch
Message-Id: <20241011223215.365F0C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86-module-enable-rox-caches-for-module-text-fix
has been added to the -mm mm-unstable branch.  Its filename is
     x86-module-enable-rox-caches-for-module-text-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-module-enable-rox-caches-for-module-text-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: x86-module-enable-rox-caches-for-module-text-fix
Date: Fri, 11 Oct 2024 16:08:12 +0300

fix 32-bit

Link: https://lkml.kernel.org/r/ZwkjPKKxRKUoJuOE@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init.c~x86-module-enable-rox-caches-for-module-text-fix
+++ a/arch/x86/mm/init.c
@@ -1065,20 +1065,30 @@ static void execmem_fill_trapping_insns(
 struct execmem_info __init *execmem_arch_setup(void)
 {
 	unsigned long start, offset = 0;
+	enum execmem_range_flags flags;
+	pgprot_t pgprot;
 
 	if (kaslr_enabled())
 		offset = get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
 
 	start = MODULES_VADDR + offset;
 
+	if (IS_ENABLED(CONFIG_X86_64)) {
+		pgprot = PAGE_KERNEL_ROX;
+		flags = EXECMEM_KASAN_SHADOW | EXECMEM_ROX_CACHE;
+	} else {
+		pgprot = PAGE_KERNEL;
+		flags = EXECMEM_KASAN_SHADOW;
+	}
+
 	execmem_info = (struct execmem_info){
 		.fill_trapping_insns = execmem_fill_trapping_insns,
 		.ranges = {
 			[EXECMEM_MODULE_TEXT] = {
-				.flags	= EXECMEM_KASAN_SHADOW | EXECMEM_ROX_CACHE,
+				.flags	= flags,
 				.start	= start,
 				.end	= MODULES_END,
-				.pgprot	= PAGE_KERNEL_ROX,
+				.pgprot	= pgprot,
 				.alignment = MODULE_ALIGN,
 			},
 			[EXECMEM_KPROBES ... EXECMEM_BPF] = {
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-perpare-module-loading-for-rox-allocations-of-text.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text.patch
x86-module-enable-rox-caches-for-module-text-fix.patch
mm-kmemleak-fix-typo-in-object_no_scan-comment.patch

