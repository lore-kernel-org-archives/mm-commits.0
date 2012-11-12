From: akpm@linux-foundation.org
Subject: [merged] h8300-add-missing-l1_cache_shift.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:31 -0800
Message-ID: <20121112210932.1DA1D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40174 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab2KLVJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:34 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt11so429096wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: add missing L1_CACHE_SHIFT
has been removed from the -mm tree.  Its filename was
     h8300-add-missing-l1_cache_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: h8300: add missing L1_CACHE_SHIFT

To fix build error

lib/atomic64.c: In function 'lock_addr':
lib/atomic64.c:40:11: error: 'L1_CACHE_SHIFT' undeclared (first use in this function)
lib/atomic64.c:40:11: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/cache.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/h8300/include/asm/cache.h~h8300-add-missing-l1_cache_shift arch/h8300/include/asm/cache.h
--- a/arch/h8300/include/asm/cache.h~h8300-add-missing-l1_cache_shift
+++ a/arch/h8300/include/asm/cache.h
@@ -2,7 +2,8 @@
 #define __ARCH_H8300_CACHE_H
 
 /* bytes per L1 cache line */
-#define        L1_CACHE_BYTES  4
+#define        L1_CACHE_SHIFT  2
+#define        L1_CACHE_BYTES  (1 << L1_CACHE_SHIFT)
 
 /* m68k-elf-gcc  2.95.2 doesn't like these */
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
h8300-select-generic-atomic64_t-support.patch
writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

