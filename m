From: akpm@linux-foundation.org
Subject: - introduce-compat_u64-and-compat_s64-types.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:11 -0700
Message-ID: <200707162057.l6GKvBxD002163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762139AbXGPVfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, dwmw2@infradead.org, linux-arch@vger.kernel.org, vtaras@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Introduce compat_u64 and compat_s64 types
has been removed from the -mm tree.  Its filename was
     introduce-compat_u64-and-compat_s64-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Introduce compat_u64 and compat_s64 types
From: Arnd Bergmann <arnd@arndb.de>

One common problem with 32 bit system call and ioctl emulation is the
different alignment rules between i386 and 64 bit machines.  A number of
drivers work around this by marking the compat structures as
'attribute((packed))', which is not the right solution because it breaks
all the non-x86 architectures that want to use the same compat code.

Hopefully, this patch improves the situation, it introduces two new types,
compat_u64 and compat_s64.  These are defined on all architectures to have
the same size and alignment as the 32 bit version of u64 and s64.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Vasily Tarasov <vtaras@openvz.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/compat.h    |    2 ++
 include/asm-mips/compat.h    |    2 ++
 include/asm-parisc/compat.h  |    2 ++
 include/asm-powerpc/compat.h |    2 ++
 include/asm-s390/compat.h    |    2 ++
 include/asm-sparc64/compat.h |    2 ++
 include/asm-x86_64/compat.h  |    2 ++
 7 files changed, 14 insertions(+)

diff -puN include/asm-ia64/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-ia64/compat.h
--- a/include/asm-ia64/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-ia64/compat.h
@@ -31,8 +31,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64 __attribute__((aligned(4))) compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64 __attribute__((aligned(4))) compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
diff -puN include/asm-mips/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-mips/compat.h
--- a/include/asm-mips/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-mips/compat.h
@@ -37,8 +37,10 @@ typedef s32		compat_key_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
diff -puN include/asm-parisc/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-parisc/compat.h
--- a/include/asm-parisc/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-parisc/compat.h
@@ -31,8 +31,10 @@ typedef s32	compat_timer_t;
 
 typedef s32	compat_int_t;
 typedef s32	compat_long_t;
+typedef s64	compat_s64;
 typedef u32	compat_uint_t;
 typedef u32	compat_ulong_t;
+typedef u64	compat_u64;
 
 struct compat_timespec {
 	compat_time_t		tv_sec;
diff -puN include/asm-powerpc/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-powerpc/compat.h
--- a/include/asm-powerpc/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-powerpc/compat.h
@@ -33,8 +33,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
diff -puN include/asm-s390/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-s390/compat.h
--- a/include/asm-s390/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-s390/compat.h
@@ -60,8 +60,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
diff -puN include/asm-sparc64/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-sparc64/compat.h
--- a/include/asm-sparc64/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-sparc64/compat.h
@@ -31,8 +31,10 @@ typedef s32		compat_timer_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64		compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64		compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
diff -puN include/asm-x86_64/compat.h~introduce-compat_u64-and-compat_s64-types include/asm-x86_64/compat.h
--- a/include/asm-x86_64/compat.h~introduce-compat_u64-and-compat_s64-types
+++ a/include/asm-x86_64/compat.h
@@ -33,8 +33,10 @@ typedef s32		compat_key_t;
 
 typedef s32		compat_int_t;
 typedef s32		compat_long_t;
+typedef s64 __attribute__((aligned(4))) compat_s64;
 typedef u32		compat_uint_t;
 typedef u32		compat_ulong_t;
+typedef u64 __attribute__((aligned(4))) compat_u64;
 
 struct compat_timespec {
 	compat_time_t	tv_sec;
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
git-powerpc.patch
8xx-fix-whitespace-and-indentation.patch
fbdev-spe-helper-penguin-logo.patch
cell-draw-spe-helper-penguin-logos.patch
