From: akpm@linux-foundation.org
Subject: + linux-bitmap-force-inlining-of-bitmap-weight-functions.patch
 added to -mm tree
Date: Tue, 04 Aug 2015 14:52:28 -0700
Message-ID: <55c1341c.54/qWygU/P6fbhiX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbHDVw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:52:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/bitmap: force inlining of bitmap weight functions
has been added to the -mm tree.  Its filename is
     linux-bitmap-force-inlining-of-bitmap-weight-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-bitmap-force-inlining-of-bitmap-weight-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-bitmap-force-inlining-of-bitmap-weight-functions.patch

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
Subject: linux/bitmap: force inlining of bitmap weight functions

With this config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os

gcc-4.7.2 generates many copies of these tiny functions:

bitmap_weight (55 copies):
55                      push   %rbp
48 89 e5                mov    %rsp,%rbp
e8 3f 3a 8b 00          callq  __bitmap_weight
5d                      pop    %rbp
c3                      retq

hweight_long (23 copies):
55                      push   %rbp
e8 b5 65 8e 00          callq  __sw_hweight64
48 89 e5                mov    %rsp,%rbp
5d                      pop    %rbp
c3                      retq

See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

This patch fixes this via s/inline/__always_inline/

While at it, replaced two "__inline__" with usual "inline"
(the rest of the source file uses the latter).

    text     data      bss       dec     hex filename
86971357 17195880 36659200 140826437 864d745 vmlinux.before
86971120 17195912 36659200 140826232 864d678 vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 include/linux/bitops.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/bitmap.h~linux-bitmap-force-inlining-of-bitmap-weight-functions include/linux/bitmap.h
--- a/include/linux/bitmap.h~linux-bitmap-force-inlining-of-bitmap-weight-functions
+++ a/include/linux/bitmap.h
@@ -295,7 +295,7 @@ static inline int bitmap_full(const unsi
 	return find_first_zero_bit(src, nbits) == nbits;
 }
 
-static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
+static __always_inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
diff -puN include/linux/bitops.h~linux-bitmap-force-inlining-of-bitmap-weight-functions include/linux/bitops.h
--- a/include/linux/bitops.h~linux-bitmap-force-inlining-of-bitmap-weight-functions
+++ a/include/linux/bitops.h
@@ -57,7 +57,7 @@ extern unsigned long __sw_hweight64(__u6
 	     (bit) < (size);					\
 	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
 
-static __inline__ int get_bitmask_order(unsigned int count)
+static inline int get_bitmask_order(unsigned int count)
 {
 	int order;
 
@@ -65,7 +65,7 @@ static __inline__ int get_bitmask_order(
 	return order;	/* We could be slightly more clever with -1 here... */
 }
 
-static __inline__ int get_count_order(unsigned int count)
+static inline int get_count_order(unsigned int count)
 {
 	int order;
 
@@ -75,7 +75,7 @@ static __inline__ int get_count_order(un
 	return order;
 }
 
-static inline unsigned long hweight_long(unsigned long w)
+static __always_inline unsigned long hweight_long(unsigned long w)
 {
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

linux-bitmap-force-inlining-of-bitmap-weight-functions.patch
x86-hweight-force-inlining-of-__arch_hweight3264.patch
jiffies-force-inlining-of-mumsecs_to_jiffies.patch
linux-next.patch

