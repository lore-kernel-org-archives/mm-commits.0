From: akpm@linux-foundation.org
Subject: + force-inlining-of-unaligned-byteswap-operations.patch added to
 -mm tree
Date: Thu, 04 Feb 2016 13:49:41 -0800
Message-ID: <56b3c775.nv82pWqjKrzJ8nPs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbcBDVtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 16:49:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, arnd@arndb.de, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/unaligned: force inlining of byteswap operations
has been added to the -mm tree.  Its filename is
     force-inlining-of-unaligned-byteswap-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/force-inlining-of-unaligned-byteswap-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/force-inlining-of-unaligned-byteswap-operations.patch

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
Subject: include/linux/unaligned: force inlining of byteswap operations

Sometimes gcc mysteriously doesn't inline
very small functions we expect to be inlined. See
    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

With this .config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os,
the following functions get deinlined many times.
Examples of disassembly:

<get_unaligned_be16> (24 copies, 108 calls):
       66 8b 07                mov    (%rdi),%ax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       86 e0                   xchg   %ah,%al
       5d                      pop    %rbp
       c3                      retq

<get_unaligned_be32> (25 copies, 181 calls):
       8b 07                   mov    (%rdi),%eax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       0f c8                   bswap  %eax
       5d                      pop    %rbp
       c3                      retq

<get_unaligned_be64> (23 copies, 94 calls):
       48 8b 07                mov    (%rdi),%rax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       48 0f c8                bswap  %rax
       5d                      pop    %rbp
       c3                      retq

<put_unaligned_be16> (2 copies, 11 calls):
       89 f8                   mov    %edi,%eax
       55                      push   %rbp
       c1 ef 08                shr    $0x8,%edi
       c1 e0 08                shl    $0x8,%eax
       09 c7                   or     %eax,%edi
       48 89 e5                mov    %rsp,%rbp
       66 89 3e                mov    %di,(%rsi)

<put_unaligned_be32> (8 copies, 43 calls):
       55                      push   %rbp
       0f cf                   bswap  %edi
       89 3e                   mov    %edi,(%rsi)
       48 89 e5                mov    %rsp,%rbp
       5d                      pop    %rbp
       c3                      retq

<put_unaligned_be64> (26 copies, 157 calls):
       55                      push   %rbp
       48 0f cf                bswap  %rdi
       48 89 3e                mov    %rdi,(%rsi)
       48 89 e5                mov    %rsp,%rbp
       5d                      pop    %rbp
       c3                      retq

This patch fixes this via s/inline/__always_inline/.

It only affects arches with efficient unaligned access insns, such as x86.
(arched which lack such ops do not include linux/unaligned/access_ok.h)

Code size decrease after the patch is ~8.5k:

    text     data      bss       dec     hex filename
92197848 20826112 36417536 149441496 8e84bd8 vmlinux
92189231 20826144 36417536 149432911 8e82a4f vmlinux6_unaligned_be_after

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned/access_ok.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/unaligned/access_ok.h~force-inlining-of-unaligned-byteswap-operations include/linux/unaligned/access_ok.h
--- a/include/linux/unaligned/access_ok.h~force-inlining-of-unaligned-byteswap-operations
+++ a/include/linux/unaligned/access_ok.h
@@ -4,62 +4,62 @@
 #include <linux/kernel.h>
 #include <asm/byteorder.h>
 
-static inline u16 get_unaligned_le16(const void *p)
+static __always_inline u16 get_unaligned_le16(const void *p)
 {
 	return le16_to_cpup((__le16 *)p);
 }
 
-static inline u32 get_unaligned_le32(const void *p)
+static __always_inline u32 get_unaligned_le32(const void *p)
 {
 	return le32_to_cpup((__le32 *)p);
 }
 
-static inline u64 get_unaligned_le64(const void *p)
+static __always_inline u64 get_unaligned_le64(const void *p)
 {
 	return le64_to_cpup((__le64 *)p);
 }
 
-static inline u16 get_unaligned_be16(const void *p)
+static __always_inline u16 get_unaligned_be16(const void *p)
 {
 	return be16_to_cpup((__be16 *)p);
 }
 
-static inline u32 get_unaligned_be32(const void *p)
+static __always_inline u32 get_unaligned_be32(const void *p)
 {
 	return be32_to_cpup((__be32 *)p);
 }
 
-static inline u64 get_unaligned_be64(const void *p)
+static __always_inline u64 get_unaligned_be64(const void *p)
 {
 	return be64_to_cpup((__be64 *)p);
 }
 
-static inline void put_unaligned_le16(u16 val, void *p)
+static __always_inline void put_unaligned_le16(u16 val, void *p)
 {
 	*((__le16 *)p) = cpu_to_le16(val);
 }
 
-static inline void put_unaligned_le32(u32 val, void *p)
+static __always_inline void put_unaligned_le32(u32 val, void *p)
 {
 	*((__le32 *)p) = cpu_to_le32(val);
 }
 
-static inline void put_unaligned_le64(u64 val, void *p)
+static __always_inline void put_unaligned_le64(u64 val, void *p)
 {
 	*((__le64 *)p) = cpu_to_le64(val);
 }
 
-static inline void put_unaligned_be16(u16 val, void *p)
+static __always_inline void put_unaligned_be16(u16 val, void *p)
 {
 	*((__be16 *)p) = cpu_to_be16(val);
 }
 
-static inline void put_unaligned_be32(u32 val, void *p)
+static __always_inline void put_unaligned_be32(u32 val, void *p)
 {
 	*((__be32 *)p) = cpu_to_be32(val);
 }
 
-static inline void put_unaligned_be64(u64 val, void *p)
+static __always_inline void put_unaligned_be64(u64 val, void *p)
 {
 	*((__be64 *)p) = cpu_to_be64(val);
 }
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

asm-generic-force-inlining-of-some-atomic_long-operations.patch
force-inlining-of-some-byteswap-operations.patch
force-inlining-of-unaligned-byteswap-operations.patch

