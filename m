From: akpm@linux-foundation.org
Subject: + h8300-add-missing-l1_cache_shift.patch added to -mm tree
Date: Mon, 05 Nov 2012 12:45:50 -0800
Message-ID: <20121105204551.007DF5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:54343 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab2KEUpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:45:53 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so274893wib.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:45:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300: add missing L1_CACHE_SHIFT
has been added to the -mm tree.  Its filename is
     h8300-add-missing-l1_cache_shift.patch

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

h8300-add-missing-l1_cache_shift.patch
linux-next.patch
h8300-select-generic-atomic64_t-support.patch
writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

