From: akpm@linux-foundation.org
Subject: + avr32-fix-build-error-in-atstk1002-code.patch added to -mm tree
Date: Wed, 25 Jul 2012 12:22:33 -0700
Message-ID: <20120725192234.18A705C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44511 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2GYTWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 15:22:36 -0400
Received: by lbbgp10 with SMTP id gp10so56643lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 12:22:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, dbaryshkov@gmail.com


The patch titled
     Subject: avr32: fix build error in ATSTK1002 code
has been added to the -mm tree.  Its filename is
     avr32-fix-build-error-in-atstk1002-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: avr32: fix build error in ATSTK1002 code

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
parisc-redefine-atomic_init-and-atomic64_init-like-other-architectures.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix-2.patch
clk-validate-pointer-in-__clk_disable.patch
avr32-fix-build-error-in-atstk1002-code.patch
rbtree-performance-and-correctness-test-fix.patch

