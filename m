From: akpm@linux-foundation.org
Subject: + bufferhead-force-inlining-of-buffer-head-flag-operations.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 16:23:53 -0800
Message-ID: <56b93199.2CQDT/bMW5QBBCp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbcBIAXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 19:23:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: bufferhead: Force inlining of buffer head flag operations
has been added to the -mm tree.  Its filename is
     bufferhead-force-inlining-of-buffer-head-flag-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bufferhead-force-inlining-of-buffer-head-flag-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bufferhead-force-inlining-of-buffer-head-flag-operations.patch

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
Subject: bufferhead: Force inlining of buffer head flag operations

With both gcc 4.7.2 and 4.9.2, sometimes gcc mysteriously doesn't inline
very small functions we expect to be inlined. See
    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

With this .config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os,
set_buffer_foo(), clear_buffer_foo() and similar functions get deinlined
about 60 times. Examples of disassembly:

<set_buffer_mapped> (14 copies, 43 calls):
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       f0 80 0f 20             lock orb $0x20,(%rdi)
       5d                      pop    %rbp
       c3                      retq
<buffer_mapped> (3 copies, 34 calls):
       48 8b 07                mov    (%rdi),%rax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       48 c1 e8 05             shr    $0x5,%rax
       83 e0 01                and    $0x1,%eax
       5d                      pop    %rbp
       c3                      retq
<set_buffer_new> (5 copies, 13 calls):
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       f0 80 0f 40             lock orb $0x40,(%rdi)
       5d                      pop    %rbp
       c3                      retq

This patch fixes this via s/inline/__always_inline/.
This decreases vmlinux by about 3 kbytes.

    text	    data	     bss	      dec	    hex	filename
88200439	19905208	36421632	144527279	89d4faf	vmlinux2
88197239	19905240	36421632	144524111	89d434f	vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/buffer_head.h~bufferhead-force-inlining-of-buffer-head-flag-operations include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~bufferhead-force-inlining-of-buffer-head-flag-operations
+++ a/include/linux/buffer_head.h
@@ -82,15 +82,15 @@ struct buffer_head {
  * and buffer_foo() functions.
  */
 #define BUFFER_FNS(bit, name)						\
-static inline void set_buffer_##name(struct buffer_head *bh)		\
+static __always_inline void set_buffer_##name(struct buffer_head *bh)	\
 {									\
 	set_bit(BH_##bit, &(bh)->b_state);				\
 }									\
-static inline void clear_buffer_##name(struct buffer_head *bh)		\
+static __always_inline void clear_buffer_##name(struct buffer_head *bh)	\
 {									\
 	clear_bit(BH_##bit, &(bh)->b_state);				\
 }									\
-static inline int buffer_##name(const struct buffer_head *bh)		\
+static __always_inline int buffer_##name(const struct buffer_head *bh)	\
 {									\
 	return test_bit(BH_##bit, &(bh)->b_state);			\
 }
@@ -99,11 +99,11 @@ static inline int buffer_##name(const st
  * test_set_buffer_foo() and test_clear_buffer_foo()
  */
 #define TAS_BUFFER_FNS(bit, name)					\
-static inline int test_set_buffer_##name(struct buffer_head *bh)	\
+static __always_inline int test_set_buffer_##name(struct buffer_head *bh) \
 {									\
 	return test_and_set_bit(BH_##bit, &(bh)->b_state);		\
 }									\
-static inline int test_clear_buffer_##name(struct buffer_head *bh)	\
+static __always_inline int test_clear_buffer_##name(struct buffer_head *bh) \
 {									\
 	return test_and_clear_bit(BH_##bit, &(bh)->b_state);		\
 }									\
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

bufferhead-force-inlining-of-buffer-head-flag-operations.patch
asm-generic-force-inlining-of-some-atomic_long-operations.patch
force-inlining-of-some-byteswap-operations.patch
force-inlining-of-unaligned-byteswap-operations.patch

