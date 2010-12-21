From: akpm@linux-foundation.org
Subject: + thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:11:30 -0800
Message-ID: <201012212211.oBLMBV4T028991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab0LUWLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:11:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com


The patch titled
     thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#64: FILE: arch/sparc/mm/generic_32.c:53:
+		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);

ERROR: "foo * bar" should be "foo *bar"
#76: FILE: arch/sparc/mm/generic_64.c:95:
+		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);

total: 2 errors, 0 warnings, 56 lines checked

./patches/thp-pte-alloc-trans-splitting-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/generic_32.c |    2 +-
 arch/sparc/mm/generic_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes arch/sparc/mm/generic_32.c
--- a/arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
+++ a/arch/sparc/mm/generic_32.c
@@ -50,7 +50,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);
+		pte_t *pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
diff -puN arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes arch/sparc/mm/generic_64.c
--- a/arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
+++ a/arch/sparc/mm/generic_64.c
@@ -92,7 +92,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);
+		pte_t *pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

