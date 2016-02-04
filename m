From: akpm@linux-foundation.org
Subject: + force-inlining-of-some-byteswap-operations.patch added to -mm
 tree
Date: Thu, 04 Feb 2016 13:49:39 -0800
Message-ID: <56b3c773.RP7dCJJhkuwLI21T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbcBDVtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, arnd@arndb.de, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: include/uapi/linux/byteorder, swab: force inlining of some byteswap operations
has been added to the -mm tree.  Its filename is
     force-inlining-of-some-byteswap-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/force-inlining-of-some-byteswap-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/force-inlining-of-some-byteswap-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: include/uapi/linux/byteorder, swab: force inlining of some byteswap operations

Sometimes gcc mysteriously doesn't inline
very small functions we expect to be inlined. See
    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

With this .config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os,
the following functions get deinlined many times.
Examples of disassembly:

<get_unaligned_be16> (12 copies, 51 calls):
       66 8b 07                mov    (%rdi),%ax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       86 e0                   xchg   %ah,%al
       5d                      pop    %rbp
       c3                      retq

<get_unaligned_be32> (12 copies, 135 calls):
       8b 07                   mov    (%rdi),%eax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       0f c8                   bswap  %eax
       5d                      pop    %rbp
       c3                      retq

<get_unaligned_be64> (2 copies, 20 calls):
       48 8b 07                mov    (%rdi),%rax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       48 0f c8                bswap  %rax
       5d                      pop    %rbp
       c3                      retq

<__swab16p> (16 copies, 146 calls):
       55                      push   %rbp
       89 f8                   mov    %edi,%eax
       86 e0                   xchg   %ah,%al
       48 89 e5                mov    %rsp,%rbp
       5d                      pop    %rbp
       c3                      retq

<__swab32p> (43 copies, ~560 calls):
       55                      push   %rbp
       89 f8                   mov    %edi,%eax
       0f c8                   bswap  %eax
       48 89 e5                mov    %rsp,%rbp
       5d                      pop    %rbp
       c3                      retq

<__swab64p> (21 copies, 119 calls):
       55                      push   %rbp
       48 89 f8                mov    %rdi,%rax
       48 0f c8                bswap  %rax
       48 89 e5                mov    %rsp,%rbp
       5d                      pop    %rbp
       c3                      retq

<__swab32s> (6 copies, 47 calls):
       8b 07                   mov    (%rdi),%eax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       0f c8                   bswap  %eax
       89 07                   mov    %eax,(%rdi)
       5d                      pop    %rbp
       c3                      retq

This patch fixes this via s/inline/__always_inline/.
Code size decrease after the patch is ~4.5k:

    text     data      bss       dec     hex filename
92202377 20826112 36417536 149446025 8e85d89 vmlinux
92197848 20826112 36417536 149441496 8e84bd8 vmlinux5_swap_after

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/byteorder/big_endian.h    |   24 ++++++++---------
 include/uapi/linux/byteorder/little_endian.h |   24 ++++++++---------
 include/uapi/linux/swab.h                    |   10 +++----
 3 files changed, 29 insertions(+), 29 deletions(-)

diff -puN include/uapi/linux/byteorder/big_endian.h~force-inlining-of-some-byteswap-operations include/uapi/linux/byteorder/big_endian.h
--- a/include/uapi/linux/byteorder/big_endian.h~force-inlining-of-some-byteswap-operations
+++ a/include/uapi/linux/byteorder/big_endian.h
@@ -40,51 +40,51 @@
 #define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
 #define __be16_to_cpu(x) ((__force __u16)(__be16)(x))
 
-static inline __le64 __cpu_to_le64p(const __u64 *p)
+static __always_inline __le64 __cpu_to_le64p(const __u64 *p)
 {
 	return (__force __le64)__swab64p(p);
 }
-static inline __u64 __le64_to_cpup(const __le64 *p)
+static __always_inline __u64 __le64_to_cpup(const __le64 *p)
 {
 	return __swab64p((__u64 *)p);
 }
-static inline __le32 __cpu_to_le32p(const __u32 *p)
+static __always_inline __le32 __cpu_to_le32p(const __u32 *p)
 {
 	return (__force __le32)__swab32p(p);
 }
-static inline __u32 __le32_to_cpup(const __le32 *p)
+static __always_inline __u32 __le32_to_cpup(const __le32 *p)
 {
 	return __swab32p((__u32 *)p);
 }
-static inline __le16 __cpu_to_le16p(const __u16 *p)
+static __always_inline __le16 __cpu_to_le16p(const __u16 *p)
 {
 	return (__force __le16)__swab16p(p);
 }
-static inline __u16 __le16_to_cpup(const __le16 *p)
+static __always_inline __u16 __le16_to_cpup(const __le16 *p)
 {
 	return __swab16p((__u16 *)p);
 }
-static inline __be64 __cpu_to_be64p(const __u64 *p)
+static __always_inline __be64 __cpu_to_be64p(const __u64 *p)
 {
 	return (__force __be64)*p;
 }
-static inline __u64 __be64_to_cpup(const __be64 *p)
+static __always_inline __u64 __be64_to_cpup(const __be64 *p)
 {
 	return (__force __u64)*p;
 }
-static inline __be32 __cpu_to_be32p(const __u32 *p)
+static __always_inline __be32 __cpu_to_be32p(const __u32 *p)
 {
 	return (__force __be32)*p;
 }
-static inline __u32 __be32_to_cpup(const __be32 *p)
+static __always_inline __u32 __be32_to_cpup(const __be32 *p)
 {
 	return (__force __u32)*p;
 }
-static inline __be16 __cpu_to_be16p(const __u16 *p)
+static __always_inline __be16 __cpu_to_be16p(const __u16 *p)
 {
 	return (__force __be16)*p;
 }
-static inline __u16 __be16_to_cpup(const __be16 *p)
+static __always_inline __u16 __be16_to_cpup(const __be16 *p)
 {
 	return (__force __u16)*p;
 }
diff -puN include/uapi/linux/byteorder/little_endian.h~force-inlining-of-some-byteswap-operations include/uapi/linux/byteorder/little_endian.h
--- a/include/uapi/linux/byteorder/little_endian.h~force-inlining-of-some-byteswap-operations
+++ a/include/uapi/linux/byteorder/little_endian.h
@@ -40,51 +40,51 @@
 #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
 #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
 
-static inline __le64 __cpu_to_le64p(const __u64 *p)
+static __always_inline __le64 __cpu_to_le64p(const __u64 *p)
 {
 	return (__force __le64)*p;
 }
-static inline __u64 __le64_to_cpup(const __le64 *p)
+static __always_inline __u64 __le64_to_cpup(const __le64 *p)
 {
 	return (__force __u64)*p;
 }
-static inline __le32 __cpu_to_le32p(const __u32 *p)
+static __always_inline __le32 __cpu_to_le32p(const __u32 *p)
 {
 	return (__force __le32)*p;
 }
-static inline __u32 __le32_to_cpup(const __le32 *p)
+static __always_inline __u32 __le32_to_cpup(const __le32 *p)
 {
 	return (__force __u32)*p;
 }
-static inline __le16 __cpu_to_le16p(const __u16 *p)
+static __always_inline __le16 __cpu_to_le16p(const __u16 *p)
 {
 	return (__force __le16)*p;
 }
-static inline __u16 __le16_to_cpup(const __le16 *p)
+static __always_inline __u16 __le16_to_cpup(const __le16 *p)
 {
 	return (__force __u16)*p;
 }
-static inline __be64 __cpu_to_be64p(const __u64 *p)
+static __always_inline __be64 __cpu_to_be64p(const __u64 *p)
 {
 	return (__force __be64)__swab64p(p);
 }
-static inline __u64 __be64_to_cpup(const __be64 *p)
+static __always_inline __u64 __be64_to_cpup(const __be64 *p)
 {
 	return __swab64p((__u64 *)p);
 }
-static inline __be32 __cpu_to_be32p(const __u32 *p)
+static __always_inline __be32 __cpu_to_be32p(const __u32 *p)
 {
 	return (__force __be32)__swab32p(p);
 }
-static inline __u32 __be32_to_cpup(const __be32 *p)
+static __always_inline __u32 __be32_to_cpup(const __be32 *p)
 {
 	return __swab32p((__u32 *)p);
 }
-static inline __be16 __cpu_to_be16p(const __u16 *p)
+static __always_inline __be16 __cpu_to_be16p(const __u16 *p)
 {
 	return (__force __be16)__swab16p(p);
 }
-static inline __u16 __be16_to_cpup(const __be16 *p)
+static __always_inline __u16 __be16_to_cpup(const __be16 *p)
 {
 	return __swab16p((__u16 *)p);
 }
diff -puN include/uapi/linux/swab.h~force-inlining-of-some-byteswap-operations include/uapi/linux/swab.h
--- a/include/uapi/linux/swab.h~force-inlining-of-some-byteswap-operations
+++ a/include/uapi/linux/swab.h
@@ -151,7 +151,7 @@ static inline __attribute_const__ __u32
  * __swab16p - return a byteswapped 16-bit value from a pointer
  * @p: pointer to a naturally-aligned 16-bit value
  */
-static inline __u16 __swab16p(const __u16 *p)
+static __always_inline __u16 __swab16p(const __u16 *p)
 {
 #ifdef __arch_swab16p
 	return __arch_swab16p(p);
@@ -164,7 +164,7 @@ static inline __u16 __swab16p(const __u1
  * __swab32p - return a byteswapped 32-bit value from a pointer
  * @p: pointer to a naturally-aligned 32-bit value
  */
-static inline __u32 __swab32p(const __u32 *p)
+static __always_inline __u32 __swab32p(const __u32 *p)
 {
 #ifdef __arch_swab32p
 	return __arch_swab32p(p);
@@ -177,7 +177,7 @@ static inline __u32 __swab32p(const __u3
  * __swab64p - return a byteswapped 64-bit value from a pointer
  * @p: pointer to a naturally-aligned 64-bit value
  */
-static inline __u64 __swab64p(const __u64 *p)
+static __always_inline __u64 __swab64p(const __u64 *p)
 {
 #ifdef __arch_swab64p
 	return __arch_swab64p(p);
@@ -232,7 +232,7 @@ static inline void __swab16s(__u16 *p)
  * __swab32s - byteswap a 32-bit value in-place
  * @p: pointer to a naturally-aligned 32-bit value
  */
-static inline void __swab32s(__u32 *p)
+static __always_inline void __swab32s(__u32 *p)
 {
 #ifdef __arch_swab32s
 	__arch_swab32s(p);
@@ -245,7 +245,7 @@ static inline void __swab32s(__u32 *p)
  * __swab64s - byteswap a 64-bit value in-place
  * @p: pointer to a naturally-aligned 64-bit value
  */
-static inline void __swab64s(__u64 *p)
+static __always_inline void __swab64s(__u64 *p)
 {
 #ifdef __arch_swab64s
 	__arch_swab64s(p);
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

asm-generic-force-inlining-of-some-atomic_long-operations.patch
force-inlining-of-some-byteswap-operations.patch
force-inlining-of-unaligned-byteswap-operations.patch

