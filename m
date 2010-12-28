From: akpm@linux-foundation.org
Subject: + ramoops-fix-types-remove-typecasts.patch added to -mm tree
Date: Mon, 27 Dec 2010 16:55:56 -0800
Message-ID: <201012280056.oBS0uIgA004208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab0L1A4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Dec 2010 19:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, darwish.07@gmail.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com


The patch titled
     ramoops: fix types, remove typecasts
has been added to the -mm tree.  Its filename is
     ramoops-fix-types-remove-typecasts.patch

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
Subject: ramoops: fix types, remove typecasts
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-fix-types-remove-typecasts drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-fix-types-remove-typecasts
+++ a/drivers/char/ramoops.c
@@ -30,7 +30,7 @@
 
 #define RAMOOPS_KERNMSG_HDR "===="
 
-#define RECORD_SIZE 4096
+#define RECORD_SIZE 4096UL
 
 static ulong mem_address;
 module_param(mem_address, ulong, 0400);
@@ -77,7 +77,7 @@ static void ramoops_do_dump(struct kmsg_
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
 
-	buf = (char *)(cxt->virt_addr + (cxt->count * RECORD_SIZE));
+	buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
 	buf_orig = buf;
 
 	memset(buf, '\0', RECORD_SIZE);
@@ -88,8 +88,8 @@ static void ramoops_do_dump(struct kmsg_
 	buf += res;
 
 	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - hdr_size));
-	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - hdr_size) - l2_cpy);
+	l2_cpy = min(l2, RECORD_SIZE - hdr_size);
+	l1_cpy = min(l1, RECORD_SIZE - hdr_size - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

