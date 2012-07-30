From: akpm@linux-foundation.org
Subject: + xtensa-select-generic-atomic64_t-support.patch added to -mm tree
Date: Mon, 30 Jul 2012 15:23:02 -0700
Message-ID: <20120730222302.9EB50100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:44629 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2G3WXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 18:23:04 -0400
Received: by obbwc20 with SMTP id wc20so4043993obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 15:23:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, chris@zankel.net


The patch titled
     Subject: xtensa: select generic atomic64_t support
has been added to the -mm tree.  Its filename is
     xtensa-select-generic-atomic64_t-support.patch

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
Subject: xtensa: select generic atomic64_t support

This will fix build errors:

block/blk-cgroup.c:609:2: error: unknown type name 'atomic64_t'
block/blk-cgroup.c:609:2: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/xtensa/Kconfig~xtensa-select-generic-atomic64_t-support arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-select-generic-atomic64_t-support
+++ a/arch/xtensa/Kconfig
@@ -11,6 +11,7 @@ config XTENSA
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
+	select GENERIC_ATOMIC64
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
clk-validate-pointer-in-__clk_disable.patch
avr32-fix-build-error-in-atstk1002-code.patch
xtensa-select-generic-atomic64_t-support.patch
linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-further-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix-2.patch
rbtree-performance-and-correctness-test-fix.patch

