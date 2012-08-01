From: akpm@linux-foundation.org
Subject: [merged] xtensa-select-generic-atomic64_t-support.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:17 -0700
Message-ID: <20120801201117.AB0B4100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAULT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:19 -0400
Received: by obbwc20 with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: select generic atomic64_t support
has been removed from the -mm tree.  Its filename was
     xtensa-select-generic-atomic64_t-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -7,6 +7,7 @@ config ZONE_DMA
 config XTENSA
 	def_bool y
 	select HAVE_IDE
+	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
rbtree-performance-and-correctness-test-fix.patch

