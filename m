Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF383B6BE5
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521201; cv=none; b=pVvX5qNUSJfYnQ07THk/orbua8dq2oCJ+FloKB/Vq+6L1OHHhOkGPJDWHN0M3Xp1Q1iCc6Df7IQnhXSvvzhn8NYeA/3ggeDDVO6lK8lvJ94BmZ+6jdia5jtrNlM/vQ/xYXX7QVhP5nTn225GrLKGOiNQLV23kFrJB8bzfBInKNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521201; c=relaxed/simple;
	bh=szVNXdXGCD9Gof8VMnfiLjCcgD57f2kZ4QI550pOkNY=;
	h=Date:To:From:Subject:Message-Id; b=byS0vo+Wf8reRYY0OczMwFNgiJ5Jsr7pmDV3IDFKF+c43Pq5WOi0t7emCSF3RLpFNkODyaXXiSbL+bI2fMK1ZRP/1iVTv3ZNbzSJH0It9nrgedL08F/WXRp3dbsx0szEpOB3lAgtiEvIPXKo2F2iwlqOA3M4O2GBkW69655YB5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ixDlqO46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ixDlqO46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142391F00AC4;
	Fri, 31 Jul 2026 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521200;
	bh=/SsDU7gCi2ASZAxx8XJ1IGw3mNksiJ9MOt7MHZow5rQ=;
	h=Date:To:From:Subject;
	b=ixDlqO46WGPL8ZajPTC+COLXx4Xn1ffrNlSaZKTfRhZ2MwNk/8HuNwvZ2/Puk9cu0
	 2TRYPW9BAaqZ3y+4tk+FJ1jpIlX5b6VhskNNQkW0D64ghGSwVXuAWYyzgHieIyS3JK
	 RCtNoDX6uvTN0NSzZ6Q5XDT8K2DNJbGcBG9MSCQE=
Date: Fri, 31 Jul 2026 11:06:39 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-init-remove-call-the-memblock_set_node.patch added to mm-new branch
Message-Id: <20260731180640.142391F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: init: remove call the memblock_set_node()
has been added to the -mm mm-new branch.  Its filename is
     sh-init-remove-call-the-memblock_set_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-init-remove-call-the-memblock_set_node.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: init: remove call the memblock_set_node()
Date: Sun, 10 May 2026 16:55:44 +0300

Without CONFIG_NUMA, the call to memblock_set_node() is not needed.

Remove it.

Link: https://lore.kernel.org/20260510135546.13554-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/setup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/sh/kernel/setup.c~sh-init-remove-call-the-memblock_set_node
+++ a/arch/sh/kernel/setup.c
@@ -228,9 +228,6 @@ void __init __add_active_range(unsigned
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
-
-	memblock_set_node(PFN_PHYS(start_pfn), PFN_PHYS(end_pfn - start_pfn),
-			  &memblock.memory, nid);
 }
 
 void __init __weak plat_early_device_setup(void)
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

