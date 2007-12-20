From: akpm@linux-foundation.org
Subject: - mm-fix-exit_mmap-bug-on-aout-binary-exit.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:02 -0800
Message-ID: <200712202337.lBKNb2EJ018857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760039AbXLTXsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, a.p.zijlstra@chello.nl, aaw@google.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix exit_mmap BUG() on a.out binary exit
has been removed from the -mm tree.  Its filename was
     mm-fix-exit_mmap-bug-on-aout-binary-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: fix exit_mmap BUG() on a.out binary exit
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

The problem was introduced by commit "mm: variable length argument support"
(b6a2fea39318e43fee84fa7b0b90d68bed92d2ba) as it didn't update
fs/binfmt_aout.c like other binfmt's.

I noticed that on alpha when accidentally launched old OSF/1 Acrobat Reader
binary.  Obviously, other architectures are affected as well.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/binfmt_aout.c~mm-fix-exit_mmap-bug-on-aout-binary-exit fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~mm-fix-exit_mmap-bug-on-aout-binary-exit
+++ a/fs/binfmt_aout.c
@@ -319,7 +319,6 @@ static int load_aout_binary(struct linux
 	current->mm->free_area_cache = current->mm->mmap_base;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	compute_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
 #ifdef __sparc__
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
arch-alpha-removed-duplicate-includes.patch
alpha-atomic_add_return-should-return-int.patch
alpha-kill-deprecated-virt_to_bus.patch
alpha-doesnt-use-socketcall.patch
agp-alpha-nopage.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
calibrate_delay-must-be-__cpuinit.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
make-sure-nobodys-leaking-resources.patch
