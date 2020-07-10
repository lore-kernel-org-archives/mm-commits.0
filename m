Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71ADAC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE80206E2
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417668;
	bh=oJOY2CNSscx78mprG71LlG1KD1rhsE9WXsEsdnqFxZs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OvDCk34j5h44yv+LGSWPF3nX89iABTQ8ko1cDkCjRRcKfUlfc3lYJ0fI8qkL9kNwq
	 z3U9Uj0JGiit6pEVMpnboaqp1+VrAYPfTUic1HxpJaH0nruRyn1mNcjY0mP3ciCgGZ
	 q3w+d1qebIQnsyCJmJPBE+7mM4oEcN1E2f87xW4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgGJVrs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVrr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:47:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1003C2077D;
        Fri, 10 Jul 2020 21:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417666;
        bh=oJOY2CNSscx78mprG71LlG1KD1rhsE9WXsEsdnqFxZs=;
        h=Date:From:To:Subject:From;
        b=GM6sxirgbPCo5SS86uPZ5mLTZyqhEHsCxWuUiBXVgUyevFg4Ob1iBgrKz/4/8p6U3
         C8sGgm8/KNu7QygfrNTFnQirFF7XtlGdntgLfLgdE9w3fQQrA0sBb2RqquON90QiCY
         hvaE7ifgzua6nBZUjp5OZIafh0VJv2N2kYysffhQ=
Date:   Fri, 10 Jul 2020 14:47:45 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com, hch@lst.de,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  + uaccess-remove-segment_eq.patch added to -mm tree
Message-ID: <20200710214745.8hj9DmtPQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess: remove segment_eq
has been added to the -mm tree.  Its filename is
     uaccess-remove-segment_eq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uaccess-remove-segment_eq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uaccess-remove-segment_eq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: uaccess: remove segment_eq

segment_eq is only used to implement uaccess_kernel.  Just open code
uaccess_kernel in the arch uaccess headers and remove one layer of
indirection.

Link: http://lkml.kernel.org/r/20200710135706.537715-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/uaccess.h      |    2 +-
 arch/arc/include/asm/segment.h        |    3 +--
 arch/arm/include/asm/uaccess.h        |    4 ++--
 arch/arm64/include/asm/uaccess.h      |    2 +-
 arch/csky/include/asm/segment.h       |    2 +-
 arch/h8300/include/asm/segment.h      |    2 +-
 arch/ia64/include/asm/uaccess.h       |    2 +-
 arch/m68k/include/asm/segment.h       |    2 +-
 arch/microblaze/include/asm/uaccess.h |    2 +-
 arch/mips/include/asm/uaccess.h       |    2 +-
 arch/nds32/include/asm/uaccess.h      |    2 +-
 arch/nios2/include/asm/uaccess.h      |    2 +-
 arch/openrisc/include/asm/uaccess.h   |    2 +-
 arch/parisc/include/asm/uaccess.h     |    2 +-
 arch/powerpc/include/asm/uaccess.h    |    3 +--
 arch/riscv/include/asm/uaccess.h      |    4 +---
 arch/s390/include/asm/uaccess.h       |    2 +-
 arch/sh/include/asm/segment.h         |    3 +--
 arch/sparc/include/asm/uaccess_32.h   |    2 +-
 arch/sparc/include/asm/uaccess_64.h   |    2 +-
 arch/x86/include/asm/uaccess.h        |    2 +-
 arch/xtensa/include/asm/uaccess.h     |    2 +-
 include/asm-generic/uaccess.h         |    4 ++--
 include/linux/uaccess.h               |    2 --
 24 files changed, 25 insertions(+), 32 deletions(-)

--- a/arch/alpha/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/alpha/include/asm/uaccess.h
@@ -20,7 +20,7 @@
 #define get_fs()  (current_thread_info()->addr_limit)
 #define set_fs(x) (current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 /*
  * Is a address valid? This does a straightforward calculation rather
--- a/arch/arc/include/asm/segment.h~uaccess-remove-segment_eq
+++ a/arch/arc/include/asm/segment.h
@@ -14,8 +14,7 @@ typedef unsigned long mm_segment_t;
 
 #define KERNEL_DS		MAKE_MM_SEG(0)
 #define USER_DS			MAKE_MM_SEG(TASK_SIZE)
-
-#define segment_eq(a, b)	((a) == (b))
+#define uaccess_kernel()	(get_fs() == KERNEL_DS)
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASMARC_SEGMENT_H */
--- a/arch/arm64/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/arm64/include/asm/uaccess.h
@@ -49,7 +49,7 @@ static inline void set_fs(mm_segment_t f
 				CONFIG_ARM64_UAO));
 }
 
-#define segment_eq(a, b)	((a) == (b))
+#define uaccess_kernel()	(get_fs() == KERNEL_DS)
 
 /*
  * Test whether a block of memory is a valid user space address.
--- a/arch/arm/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/arm/include/asm/uaccess.h
@@ -76,7 +76,7 @@ static inline void set_fs(mm_segment_t f
 	modify_domain(DOMAIN_KERNEL, fs ? DOMAIN_CLIENT : DOMAIN_MANAGER);
 }
 
-#define segment_eq(a, b)	((a) == (b))
+#define uaccess_kernel()	(get_fs() == KERNEL_DS)
 
 /* We use 33-bit arithmetic here... */
 #define __range_ok(addr, size) ({ \
@@ -263,7 +263,7 @@ extern int __put_user_8(void *, unsigned
  */
 #define USER_DS			KERNEL_DS
 
-#define segment_eq(a, b)		(1)
+#define uaccess_kernel()	(true)
 #define __addr_ok(addr)		((void)(addr), 1)
 #define __range_ok(addr, size)	((void)(addr), 0)
 #define get_fs()		(KERNEL_DS)
--- a/arch/csky/include/asm/segment.h~uaccess-remove-segment_eq
+++ a/arch/csky/include/asm/segment.h
@@ -13,6 +13,6 @@ typedef struct {
 #define USER_DS			((mm_segment_t) { 0x80000000UL })
 #define get_fs()		(current_thread_info()->addr_limit)
 #define set_fs(x)		(current_thread_info()->addr_limit = (x))
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 #endif /* __ASM_CSKY_SEGMENT_H */
--- a/arch/h8300/include/asm/segment.h~uaccess-remove-segment_eq
+++ a/arch/h8300/include/asm/segment.h
@@ -33,7 +33,7 @@ static inline mm_segment_t get_fs(void)
 	return USER_DS;
 }
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/ia64/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/ia64/include/asm/uaccess.h
@@ -50,7 +50,7 @@
 #define get_fs()  (current_thread_info()->addr_limit)
 #define set_fs(x) (current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 /*
  * When accessing user memory, we need to make sure the entire area really is in
--- a/arch/m68k/include/asm/segment.h~uaccess-remove-segment_eq
+++ a/arch/m68k/include/asm/segment.h
@@ -52,7 +52,7 @@ static inline void set_fs(mm_segment_t v
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
 #endif
 
-#define segment_eq(a, b) ((a).seg == (b).seg)
+#define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/microblaze/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/microblaze/include/asm/uaccess.h
@@ -41,7 +41,7 @@
 # define get_fs()	(current_thread_info()->addr_limit)
 # define set_fs(val)	(current_thread_info()->addr_limit = (val))
 
-# define segment_eq(a, b)	((a).seg == (b).seg)
+# define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 #ifndef CONFIG_MMU
 
--- a/arch/mips/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/mips/include/asm/uaccess.h
@@ -72,7 +72,7 @@ extern u64 __ua_limit;
 #define get_fs()	(current_thread_info()->addr_limit)
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
 /*
  * eva_kernel_access() - determine whether kernel memory access on an EVA system
--- a/arch/nds32/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/nds32/include/asm/uaccess.h
@@ -44,7 +44,7 @@ static inline void set_fs(mm_segment_t f
 	current_thread_info()->addr_limit = fs;
 }
 
-#define segment_eq(a, b)	((a) == (b))
+#define uaccess_kernel()	(get_fs() == KERNEL_DS)
 
 #define __range_ok(addr, size) (size <= get_fs() && addr <= (get_fs() -size))
 
--- a/arch/nios2/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/nios2/include/asm/uaccess.h
@@ -30,7 +30,7 @@
 #define get_fs()		(current_thread_info()->addr_limit)
 #define set_fs(seg)		(current_thread_info()->addr_limit = (seg))
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 
 #define __access_ok(addr, len)			\
 	(((signed long)(((long)get_fs().seg) &	\
--- a/arch/openrisc/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/openrisc/include/asm/uaccess.h
@@ -43,7 +43,7 @@
 #define get_fs()	(current_thread_info()->addr_limit)
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
 
-#define segment_eq(a, b)	((a) == (b))
+#define uaccess_kernel()	(get_fs() == KERNEL_DS)
 
 /* Ensure that the range from addr to addr+size is all within the process'
  * address space
--- a/arch/parisc/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/parisc/include/asm/uaccess.h
@@ -14,7 +14,7 @@
 #define KERNEL_DS	((mm_segment_t){0})
 #define USER_DS 	((mm_segment_t){1})
 
-#define segment_eq(a, b) ((a).seg == (b).seg)
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 
 #define get_fs()	(current_thread_info()->addr_limit)
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
--- a/arch/powerpc/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/powerpc/include/asm/uaccess.h
@@ -38,8 +38,7 @@ static inline void set_fs(mm_segment_t f
 	set_thread_flag(TIF_FSCHECK);
 }
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
-
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 #define user_addr_max()	(get_fs().seg)
 
 #ifdef __powerpc64__
--- a/arch/riscv/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/riscv/include/asm/uaccess.h
@@ -64,11 +64,9 @@ static inline void set_fs(mm_segment_t f
 	current_thread_info()->addr_limit = fs;
 }
 
-#define segment_eq(a, b) ((a).seg == (b).seg)
-
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 #define user_addr_max()	(get_fs().seg)
 
-
 /**
  * access_ok: - Checks if a user space pointer is valid
  * @addr: User space pointer to start of block to check
--- a/arch/s390/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/s390/include/asm/uaccess.h
@@ -32,7 +32,7 @@
 #define USER_DS_SACF	(3)
 
 #define get_fs()        (current->thread.mm_segment)
-#define segment_eq(a,b) (((a) & 2) == ((b) & 2))
+#define uaccess_kernel() ((get_fs() & 2) == KERNEL_DS)
 
 void set_fs(mm_segment_t fs);
 
--- a/arch/sh/include/asm/segment.h~uaccess-remove-segment_eq
+++ a/arch/sh/include/asm/segment.h
@@ -24,8 +24,7 @@ typedef struct {
 #define USER_DS		KERNEL_DS
 #endif
 
-#define segment_eq(a, b) ((a).seg == (b).seg)
-
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 
 #define get_fs()	(current_thread_info()->addr_limit)
 #define set_fs(x)	(current_thread_info()->addr_limit = (x))
--- a/arch/sparc/include/asm/uaccess_32.h~uaccess-remove-segment_eq
+++ a/arch/sparc/include/asm/uaccess_32.h
@@ -28,7 +28,7 @@
 #define get_fs()	(current->thread.current_ds)
 #define set_fs(val)	((current->thread.current_ds) = (val))
 
-#define segment_eq(a, b) ((a).seg == (b).seg)
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 
 /* We have there a nice not-mapped page at PAGE_OFFSET - PAGE_SIZE, so that this test
  * can be fairly lightweight.
--- a/arch/sparc/include/asm/uaccess_64.h~uaccess-remove-segment_eq
+++ a/arch/sparc/include/asm/uaccess_64.h
@@ -32,7 +32,7 @@
 
 #define get_fs() ((mm_segment_t){(current_thread_info()->current_ds)})
 
-#define segment_eq(a, b)  ((a).seg == (b).seg)
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 
 #define set_fs(val)								\
 do {										\
--- a/arch/x86/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/x86/include/asm/uaccess.h
@@ -33,7 +33,7 @@ static inline void set_fs(mm_segment_t f
 	set_thread_flag(TIF_FSCHECK);
 }
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 #define user_addr_max() (current->thread.addr_limit.seg)
 
 /*
--- a/arch/xtensa/include/asm/uaccess.h~uaccess-remove-segment_eq
+++ a/arch/xtensa/include/asm/uaccess.h
@@ -35,7 +35,7 @@
 #define get_fs()	(current->thread.current_ds)
 #define set_fs(val)	(current->thread.current_ds = (val))
 
-#define segment_eq(a, b)	((a).seg == (b).seg)
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 
 #define __kernel_ok (uaccess_kernel())
 #define __user_ok(addr, size) \
--- a/include/asm-generic/uaccess.h~uaccess-remove-segment_eq
+++ a/include/asm-generic/uaccess.h
@@ -86,8 +86,8 @@ static inline void set_fs(mm_segment_t f
 }
 #endif
 
-#ifndef segment_eq
-#define segment_eq(a, b) ((a).seg == (b).seg)
+#ifndef uaccess_kernel
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
 #endif
 
 #define access_ok(addr, size) __access_ok((unsigned long)(addr),(size))
--- a/include/linux/uaccess.h~uaccess-remove-segment_eq
+++ a/include/linux/uaccess.h
@@ -6,8 +6,6 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 
-#define uaccess_kernel() segment_eq(get_fs(), KERNEL_DS)
-
 #include <asm/uaccess.h>
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch

