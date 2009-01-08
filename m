From: akpm@linux-foundation.org
Subject: + compiler-gcch-add-more-comments-to-reloc_hide.patch added to -mm tree
Date: Thu, 08 Jan 2009 12:50:09 -0800
Message-ID: <200901082050.n08Ko9Jt026528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501AbZAHUuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 15:50:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, cl@linux-foundation.org, mingo@elte.hu, rth@twiddle.net, rusty@rustcorp.com.au, sfr@canb.auug.org.au, travis@sgi.com


The patch titled
     compiler-gcc.h: add more comments to RELOC_HIDE
has been added to the -mm tree.  Its filename is
     compiler-gcch-add-more-comments-to-reloc_hide.patch

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
Subject: compiler-gcc.h: add more comments to RELOC_HIDE
From: Andi Kleen <andi@firstfloor.org>

Requested by C. Lameter

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-add-more-comments-to-reloc_hide include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-add-more-comments-to-reloc_hide
+++ a/include/linux/compiler-gcc.h
@@ -11,9 +11,19 @@
 /* The "volatile" is due to gcc bugs */
 #define barrier() __asm__ __volatile__("": : :"memory")
 
-/* This macro obfuscates arithmetic on a variable address so that gcc
-   shouldn't recognize the original var, and make assumptions about it */
 /*
+ * This macro obfuscates arithmetic on a variable address so that gcc
+ * shouldn't recognize the original var, and make assumptions about it.
+ *
+ * This is needed because the C standard makes it undefined to do
+ * pointer arithmetic on "objects" outside their boundaries and the
+ * gcc optimizers assume this is the case. In particular they
+ * assume such arithmetic does not wrap.
+ *
+ * A miscompilation has been observed because of this on PPC.
+ * To work around it we hide the relationship of the pointer and the object
+ * using this macro.
+ *
  * Versions of the ppc64 compiler before 4.1 had a bug where use of
  * RELOC_HIDE could trash r30. The bug can be worked around by changing
  * the inline assembly constraint from =g to =r, in this particular
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
elf-implement-at_random-for-glibc-prng-seeding.patch
x86-only-scan-the-root-bus-in-early-pci-quirks.patch
x86-hpet-allow-force-enable-on-ich10-hpet.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
x86-avoid-theoretical-vmalloc-fault-loop.patch
compiler-gcch-add-more-comments-to-reloc_hide.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch

