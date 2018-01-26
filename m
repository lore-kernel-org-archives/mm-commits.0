From: akpm@linux-foundation.org
Subject: [alternative-merged]
 include-linux-mtd-rawnandh-fix-build-with-gcc-444.patch removed from -mm
 tree
Date: Fri, 26 Jan 2018 12:06:16 -0800
Message-ID: <20180126200616.DTkVHHNWA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbeAZUGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jan 2018 15:06:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, boris.brezillon@free-electrons.com, miquel.raynal@free-electrons.com, mm-commits@vger.kernel.org, richard@nod.at, sean.nyekjaer@prevas.dk, w@1wt.eu


The patch titled
     Subject: include/linux/mtd/rawnand.h: fix build with gcc-4.4.4
has been removed from the -mm tree.  Its filename was
     include-linux-mtd-rawnandh-fix-build-with-gcc-444.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mtd/rawnand.h: fix build with gcc-4.4.4

gcc-4.4.4 has issues with anon union initializers.  Work aound this.

drivers/mtd/nand/marvell_nand.c:1936: warning: missing braces around initializer
drivers/mtd/nand/marvell_nand.c:1936: warning: (near initialization for '(anonymous)[1].<anonymous>')
drivers/mtd/nand/marvell_nand.c:1936: error: unknown field 'data' specified in initializer
drivers/mtd/nand/marvell_nand.c:1936: error: unknown field 'addr' specified in initializer
drivers/mtd/nand/marvell_nand.c:1936: warning: missing braces around initializer
drivers/mtd/nand/marvell_nand.c:1936: warning: (near initialization for '(anonymous)[1].<anonymous>')
drivers/mtd/nand/marvell_nand.c:1936: error: unknown field 'data' specified in initializer
drivers/mtd/nand/marvell_nand.c:1936: error: unknown field 'addr' specified in i

Fixes: 02f26ecf8c77275 ("mtd: nand: add reworked Marvell NAND controller driver")
Cc: Miquel Raynal <miquel.raynal@free-electrons.com>
Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mtd/rawnand.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mtd/rawnand.h~include-linux-mtd-rawnandh-fix-build-with-gcc-444 include/linux/mtd/rawnand.h
--- a/include/linux/mtd/rawnand.h~include-linux-mtd-rawnandh-fix-build-with-gcc-444
+++ a/include/linux/mtd/rawnand.h
@@ -975,21 +975,21 @@ struct nand_op_parser_pattern_elem {
 	{							\
 		.type = NAND_OP_ADDR_INSTR,			\
 		.optional = _opt,				\
-		.addr.maxcycles = _maxcycles,			\
+		{ .addr = { .maxcycles = _maxcycles }, },	\
 	}
 
 #define NAND_OP_PARSER_PAT_DATA_IN_ELEM(_opt, _maxlen)		\
 	{							\
 		.type = NAND_OP_DATA_IN_INSTR,			\
 		.optional = _opt,				\
-		.data.maxlen = _maxlen,				\
+		{ .data = { .maxlen = _maxlen, }, },		\
 	}
 
 #define NAND_OP_PARSER_PAT_DATA_OUT_ELEM(_opt, _maxlen)		\
 	{							\
 		.type = NAND_OP_DATA_OUT_INSTR,			\
 		.optional = _opt,				\
-		.data.maxlen = _maxlen,				\
+		{ .data = { .maxlen = _maxlen, }, },		\
 	}
 
 #define NAND_OP_PARSER_PAT_WAITRDY_ELEM(_opt)			\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
net-sched-sch_prioc-work-around-gcc-444-union-initializer-issues.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

