From: akpm@linux-foundation.org
Subject: + x86-hweight-force-inlining-of-__arch_hweight3264.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:52:30 -0700
Message-ID: <55c1341e.sSOZlp8njTxITsxL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbbHDVwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/hweight: force inlining of __arch_hweight{32,64}()
has been added to the -mm tree.  Its filename is
     x86-hweight-force-inlining-of-__arch_hweight3264.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-hweight-force-inlining-of-__arch_hweight3264.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-hweight-force-inlining-of-__arch_hweight3264.patch

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
Subject: x86/hweight: force inlining of __arch_hweight{32,64}()

With this config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os

gcc-4.7.2 generates many copies of these tiny functions:

__arch_hweight32 (35 copies):
55                      push   %rbp
e8 66 9b 4a 00          callq  __sw_hweight32
48 89 e5                mov    %rsp,%rbp
5d                      pop    %rbp
c3                      retq

__arch_hweight64 (8 copies):
55                      push   %rbp
e8 5e c2 8a 00          callq  __sw_hweight64
48 89 e5                mov    %rsp,%rbp
5d                      pop    %rbp
c3                      retq

See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

This patch fixes this via s/inline/__always_inline/

To avoid touching 32-bit case where such change was not tested to be a win,
reformat __arch_hweight64() to have completely disjoint 64-bit and 32-bit
implementations. IOW: made #ifdef / #else / #endif blocks contain
complete function definitions for 32 bits and 64 bits
instead of having #ifdef / #else / #endif inside a single function body.
Only 64-bit __arch_hweight64() is __always_inline'd.

    text     data      bss       dec     hex filename
86971120 17195912 36659200 140826232 864d678 vmlinux.before
86970954 17195912 36659200 140826066 864d5d2 vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/arch_hweight.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/arch_hweight.h~x86-hweight-force-inlining-of-__arch_hweight3264 arch/x86/include/asm/arch_hweight.h
--- a/arch/x86/include/asm/arch_hweight.h~x86-hweight-force-inlining-of-__arch_hweight3264
+++ a/arch/x86/include/asm/arch_hweight.h
@@ -21,7 +21,7 @@
  * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
  * compiler switches.
  */
-static inline unsigned int __arch_hweight32(unsigned int w)
+static __always_inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res = 0;
 
@@ -42,20 +42,23 @@ static inline unsigned int __arch_hweigh
 	return __arch_hweight32(w & 0xff);
 }
 
+#ifdef CONFIG_X86_32
 static inline unsigned long __arch_hweight64(__u64 w)
 {
-	unsigned long res = 0;
-
-#ifdef CONFIG_X86_32
 	return  __arch_hweight32((u32)w) +
 		__arch_hweight32((u32)(w >> 32));
+}
 #else
+static __always_inline unsigned long __arch_hweight64(__u64 w)
+{
+	unsigned long res = 0;
+
 	asm (ALTERNATIVE("call __sw_hweight64", POPCNT64, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
-#endif /* CONFIG_X86_32 */
 
 	return res;
 }
+#endif /* CONFIG_X86_32 */
 
 #endif
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

linux-bitmap-force-inlining-of-bitmap-weight-functions.patch
x86-hweight-force-inlining-of-__arch_hweight3264.patch
jiffies-force-inlining-of-mumsecs_to_jiffies.patch
linux-next.patch

