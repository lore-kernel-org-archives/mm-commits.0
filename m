From: akpm@linux-foundation.org
Subject: + arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch added to -mm tree
Date: Tue, 21 Dec 2010 18:12:37 -0800
Message-ID: <201012220216.oBM2G9vu006347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303Ab0LVCQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 21:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ben@decadent.org.uk, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     arch/alpha/include/asm/io.h: s/extern inline/static inline/
has been added to the -mm tree.  Its filename is
     arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch

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
Subject: arch/alpha/include/asm/io.h: s/extern inline/static inline/
From: Andrew Morton <akpm@linux-foundation.org>

When building the kernel for alpha using gcc 4.4, many files will provoke these
warnings:

arch/alpha/include/asm/io.h: In function '__set_hae':
arch/alpha/include/asm/io.h:41: warning: 'arch_local_irq_save' is static but
used in inline function '__set_hae' which is not static
arch/alpha/include/asm/io.h:49: warning: 'arch_local_irq_restore' is static but
used in inline function '__set_hae' which is not static

and because the alpha makefiles include -Werror in CFLAGS, this is fatal.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=25432

(akpm: there are lots more extern inlines in there, but people have been
playing games mixing them up with extern non-inlines so it needs more work).

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/io.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/io.h~a arch/alpha/include/asm/io.h
--- a/arch/alpha/include/asm/io.h~a
+++ a/arch/alpha/include/asm/io.h
@@ -35,7 +35,7 @@
  * register not being up-to-date with respect to the hardware
  * value.
  */
-extern inline void __set_hae(unsigned long new_hae)
+static inline void __set_hae(unsigned long new_hae)
 {
 	unsigned long flags;
 	local_irq_save(flags);
@@ -49,7 +49,7 @@ extern inline void __set_hae(unsigned lo
 	local_irq_restore(flags);
 }
 
-extern inline void set_hae(unsigned long new_hae)
+static inline void set_hae(unsigned long new_hae)
 {
 	if (new_hae != alpha_mv.hae_cache)
 		__set_hae(new_hae);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu.patch
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
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
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

