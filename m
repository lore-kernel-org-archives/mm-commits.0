From: akpm@linux-foundation.org
Subject: + drivers-nfc-pn544c-fix-min_t-warnings.patch added to -mm tree
Date: Thu, 13 Jan 2011 16:24:25 -0800
Message-ID: <201101140024.p0E0OPJq009993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab1ANAZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 19:25:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matti.j.aaltonen@nokia.com, sfr@canb.auug.org.au


The patch titled
     drivers/nfc/pn544.c: fix min_t warnings
has been added to the -mm tree.  Its filename is
     drivers-nfc-pn544c-fix-min_t-warnings.patch

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
Subject: drivers/nfc/pn544.c: fix min_t warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/nfc/pn544.c: In function 'pn544_read':
drivers/nfc/pn544.c:356: warning: comparison of distinct pointer types lacks a cast
drivers/nfc/pn544.c:377: warning: comparison of distinct pointer types lacks a cast
drivers/nfc/pn544.c: In function 'pn544_write':
drivers/nfc/pn544.c:463: warning: comparison of distinct pointer types lacks a cast
drivers/nfc/pn544.c:485: warning: comparison of distinct pointer types lacks a cast

Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nfc/pn544.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/nfc/pn544.c~drivers-nfc-pn544c-fix-min_t-warnings drivers/nfc/pn544.c
--- a/drivers/nfc/pn544.c~drivers-nfc-pn544c-fix-min_t-warnings
+++ a/drivers/nfc/pn544.c
@@ -69,7 +69,7 @@ struct pn544_info {
 	struct mutex read_mutex; /* Serialize read_irq access */
 	struct mutex mutex; /* Serialize info struct access */
 	u8 *buf;
-	unsigned int buflen;
+	size_t buflen;
 };
 
 static const char reg_vdd_io[]	= "Vdd_IO";
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch
thp-pte-alloc-trans-splitting.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch
drivers-nfc-pn544c-fix-min_t-warnings.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

