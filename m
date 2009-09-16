From: akpm@linux-foundation.org
Subject: + kmap_typesh-rename-d-macro.patch added to -mm tree
Date: Wed, 16 Sep 2009 13:32:41 -0700
Message-ID: <200909162032.n8GKWfXO001730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759960AbZIPUco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 16:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com


The patch titled
     kmap_types.h: rename D macro
has been added to the -mm tree.  Its filename is
     kmap_typesh-rename-d-macro.patch

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
Subject: kmap_types.h: rename D macro
From: Andi Kleen <andi@firstfloor.org>

I tend to use a 'D' debugging macro a lot during debugging.  When I define
it before includes I often get conflicts with kmap_types.h's use of 'D'
too.  It's not very nice when a global include pollutes the name space
like this.

Rename the kmap_types.h D to KMAP_D.  It is only used temporarily in the
header so has no effect on anything else.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/kmap_types.h |   47 ++++++++++++++---------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff -puN include/asm-generic/kmap_types.h~kmap_typesh-rename-d-macro include/asm-generic/kmap_types.h
--- a/include/asm-generic/kmap_types.h~kmap_typesh-rename-d-macro
+++ a/include/asm-generic/kmap_types.h
@@ -2,34 +2,35 @@
 #define _ASM_GENERIC_KMAP_TYPES_H
 
 #ifdef __WITH_KM_FENCE
-# define D(n) __KM_FENCE_##n ,
+# define KMAP_D(n) __KM_FENCE_##n ,
 #else
-# define D(n)
+# define KMAP_D(n)
 #endif
 
 enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_SYNC_ICACHE,
-D(14)	KM_SYNC_DCACHE,
-D(15)	KM_UML_USERCOPY, /* UML specific, for copy_*_user - used in do_op_one_page */
-D(16)	KM_IRQ_PTE,
-D(17)	KM_NMI,
-D(18)	KM_NMI_PTE,
-D(19)	KM_TYPE_NR
+KMAP_D(0)	KM_BOUNCE_READ,
+KMAP_D(1)	KM_SKB_SUNRPC_DATA,
+KMAP_D(2)	KM_SKB_DATA_SOFTIRQ,
+KMAP_D(3)	KM_USER0,
+KMAP_D(4)	KM_USER1,
+KMAP_D(5)	KM_BIO_SRC_IRQ,
+KMAP_D(6)	KM_BIO_DST_IRQ,
+KMAP_D(7)	KM_PTE0,
+KMAP_D(8)	KM_PTE1,
+KMAP_D(9)	KM_IRQ0,
+KMAP_D(10)	KM_IRQ1,
+KMAP_D(11)	KM_SOFTIRQ0,
+KMAP_D(12)	KM_SOFTIRQ1,
+KMAP_D(13)	KM_SYNC_ICACHE,
+KMAP_D(14)	KM_SYNC_DCACHE,
+/* UML specific, for copy_*_user - used in do_op_one_page */
+KMAP_D(15)	KM_UML_USERCOPY,
+KMAP_D(16)	KM_IRQ_PTE,
+KMAP_D(17)	KM_NMI,
+KMAP_D(18)	KM_NMI_PTE,
+KMAP_D(19)	KM_TYPE_NR
 };
 
-#undef D
+#undef KMAP_D
 
 #endif
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
kbuild-fix-ld-option-makefile-macro-to-really-work.patch
kbuild-check-if-linker-supports-the-x-option.patch
kbuild-echo-the-record_mcount-command.patch
kbuild-fail-build-if-recordmcountpl-fails.patch
kbuild-set-fconserve-stack-option-for-gcc-45.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
hwpoison-fix-uninitialized-warning.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
documentation-memorytxt-remove-some-very-outdated-recommendations.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
kmap_typesh-rename-d-macro.patch
video-console-use-div_round_up.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

