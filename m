From: akpm@linux-foundation.org
Subject: + m68k-rename-ul-to-to_ul.patch added to -mm tree
Date: Thu, 05 Jan 2017 15:08:48 -0800
Message-ID: <586ed200.BwVU16f7z8GbFRZp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763730AbdAEXHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: rename UL() to TO_UL()
has been added to the -mm tree.  Its filename is
     m68k-rename-ul-to-to_ul.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-rename-ul-to-to_ul.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-rename-ul-to-to_ul.patch

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
Subject: m68k: rename UL() to TO_UL()

Patch series "linux/const.h: cleanups of macros such as UL(), _BITUL(), BIT() etc", v2.

ARM, ARM64, UniCore32 define UL() as a shorthand of _AC(..., UL).  In the
future, more architectures may introduce it, so move the definition to
include/linux/const.h.

The _AC() is used for either (likely) UL or (unlikely) ULL.  Having UL(L)
in a common place can avoid direct use of _AC().

The _AC() is defined under the uapi directory, so it compels
underscore-prefixed macros even for unexported headers.

I see similar situation for _BITUL().  This is available in both C and
assembly.  However, it is defined in an uapi header, so direct use of the
underscore macro is needed even for unexported headers.  The 3/3 makes
BIT() available in assembly too, which will be more suitable for use in
unexported headers.


This patch (of 4):

ARM, ARM64 and UniCore32 define UL(x) like follows:

  #define UL(x) _AC(x, UL)

While, M68K defines it differently:
  #define UL(x) ((unsigned long) (x))

I am moving the former to a common header in the next commit.
Beforehand, this commit renames the latter to avoid name conflict.

Link: http://lkml.kernel.org/r/1483582810-7046-2-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/m68k/mm/init.c~m68k-rename-ul-to-to_ul arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~m68k-rename-ul-to-to_ul
+++ a/arch/m68k/mm/init.c
@@ -121,9 +121,9 @@ void free_initmem(void)
 
 void __init print_memmap(void)
 {
-#define UL(x) ((unsigned long) (x))
-#define MLK(b, t) UL(b), UL(t), (UL(t) - UL(b)) >> 10
-#define MLM(b, t) UL(b), UL(t), (UL(t) - UL(b)) >> 20
+#define TO_UL(x) ((unsigned long) (x))
+#define MLK(b, t) TO_UL(b), TO_UL(t), (TO_UL(t) - TO_UL(b)) >> 10
+#define MLM(b, t) TO_UL(b), TO_UL(t), (TO_UL(t) - TO_UL(b)) >> 20
 #define MLK_ROUNDUP(b, t) b, t, DIV_ROUND_UP(((t) - (b)), 1024)
 
 	pr_notice("Virtual kernel memory layout:\n"
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

