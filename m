From: akpm@linux-foundation.org
Subject: + memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch added to -mm tree
Date: Tue, 28 Dec 2010 13:50:01 -0800
Message-ID: <201012282150.oBSLo1WU019121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab0L1VuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 16:50:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, maximlevitsky@gmail.com, oakad@yahoo.com, randy.dunlap@oracle.com


The patch titled
     memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix
has been added to the -mm tree.  Its filename is
     memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch

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
Subject: memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/memstick/core/mspro_block.c:1090: warning: format '%x' expects type 'unsigned int', but argument 7 has type 'size_t'

Cc: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix
+++ a/drivers/memstick/core/mspro_block.c
@@ -1051,7 +1051,7 @@ static int mspro_block_read_attributes(s
 		addr = be32_to_cpu(attr->entries[cnt].address);
 		s_attr->size = be32_to_cpu(attr->entries[cnt].size);
 		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
-			"size %x\n", cnt, attr->entries[cnt].id, addr,
+			"size %zx\n", cnt, attr->entries[cnt].id, addr,
 			s_attr->size);
 		s_attr->id = attr->entries[cnt].id;
 		if (mspro_block_attr_name(s_attr->id))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
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
gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
a.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

