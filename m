From: akpm@linux-foundation.org
Subject: +
 linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch added
 to -mm tree
Date: Thu, 05 Jan 2017 15:08:54 -0800
Message-ID: <586ed206.++txkecKrAaBkrIJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763733AbdAEXHg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/const.h: move BIT(_ULL) to linux/const.h for use in assembly
has been added to the -mm tree.  Its filename is
     linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: linux/const.h: move BIT(_ULL) to linux/const.h for use in assembly

Commit 2fc016c5bd8a ("linux/const.h: Add _BITUL() and _BITULL()")
introduced _BITUL() and _BITULL().  Its git-log says the difference
from the already existing BIT() are:

  1. The namespace is such that they can be used in uapi definitions.
  2. The type is set with the _AC() macro to allow it to be used in
     assembly.
  3. The type is explicitly specified to be UL or ULL.

However, I found _BITUL() is often used for "2. use in assembly",
while "1. use in uapi" is unneeded.  If we address only "2.", we can
improve the existing BIT() for that.  It will allow us to replace
many _BITUL() instances with BIT(), i.e. avoid needless use of
underscore-prefixed macros, in the end, for better de-couple of
userspace/kernel headers.

Link: http://lkml.kernel.org/r/1483582810-7046-5-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    3 +--
 include/linux/const.h  |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/bitops.h~linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly include/linux/bitops.h
--- a/include/linux/bitops.h~linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly
+++ a/include/linux/bitops.h
@@ -1,10 +1,9 @@
 #ifndef _LINUX_BITOPS_H
 #define _LINUX_BITOPS_H
+#include <linux/const.h>
 #include <asm/types.h>
 
 #ifdef	__KERNEL__
-#define BIT(nr)			(1UL << (nr))
-#define BIT_ULL(nr)		(1ULL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BIT_ULL_MASK(nr)	(1ULL << ((nr) % BITS_PER_LONG_LONG))
diff -puN include/linux/const.h~linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly include/linux/const.h
--- a/include/linux/const.h~linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly
+++ a/include/linux/const.h
@@ -6,4 +6,7 @@
 #define UL(x)		(_UL(x))
 #define ULL(x)		(_ULL(x))
 
+#define BIT(x)		(_BITUL(x))
+#define BIT_ULL(x)	(_BITULL(x))
+
 #endif /* _LINUX_CONST_H */
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

m68k-rename-ul-to-to_ul.patch
linux-consth-move-ul-macro-to-include-linux-consth.patch
linux-consth-refactor-_bitul-and-_bitull-a-bit.patch
linux-consth-move-bit_ull-to-linux-consth-for-use-in-assembly.patch
scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

