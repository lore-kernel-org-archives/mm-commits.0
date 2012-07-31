From: akpm@linux-foundation.org
Subject: [merged] avr32-fix-build-error-in-atstk1002-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:58 -0700
Message-ID: <20120731184859.0CEC45C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49287 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaStA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:00 -0400
Received: by eaao12 with SMTP id o12so241331eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, dbaryshkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: fix build error in ATSTK1002 code
has been removed from the -mm tree.  Its filename was
     avr32-fix-build-error-in-atstk1002-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: avr32: fix build error in ATSTK1002 code

arch/avr32/boards/atstk1000/atstk1002.c:100: error: 'num_partitions' undeclared here (not in a function)

which is introduced by commit 1754aab9bb86 ("mtd: ATMEL, AVR32: inline
nand partition table access ").

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/boards/atstk1000/atstk1002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/boards/atstk1000/atstk1002.c~avr32-fix-build-error-in-atstk1002-code arch/avr32/boards/atstk1000/atstk1002.c
--- a/arch/avr32/boards/atstk1000/atstk1002.c~avr32-fix-build-error-in-atstk1002-code
+++ a/arch/avr32/boards/atstk1000/atstk1002.c
@@ -97,7 +97,7 @@ static struct atmel_nand_data atstk1006_
 	.enable_pin	= GPIO_PIN_PB(29),
 	.ecc_mode	= NAND_ECC_SOFT,
 	.parts		= nand_partitions,
-	.num_parts	= ARRAY_SIZE(num_partitions),
+	.num_parts	= ARRAY_SIZE(nand_partitions),
 };
 #endif
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
xtensa-select-generic-atomic64_t-support.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
nfs-enable-swap-on-nfs-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix-2.patch
linux-next.patch
rbtree-performance-and-correctness-test-fix.patch

