From: akpm@linux-foundation.org
Subject: + compiler-intel-fix-wrong-compiler-barrier-macro.patch added to
 -mm tree
Date: Wed, 20 May 2015 12:38:13 -0700
Message-ID: <555ce2a5.W+Yk/IN8sz3oQ3s2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbETTiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 May 2015 15:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@iogearbox.net, bobby.prani@gmail.com, hpa@zytor.com, mancha1@zoho.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-intel: fix wrong compiler barrier() macro
has been added to the -mm tree.  Its filename is
     compiler-intel-fix-wrong-compiler-barrier-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compiler-intel-fix-wrong-compiler-barrier-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compiler-intel-fix-wrong-compiler-barrier-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Borkmann <daniel@iogearbox.net>
Subject: compiler-intel: fix wrong compiler barrier() macro

Cleanup commit 73679e508201 ("compiler-intel.h: Remove duplicate
definition") removed the double definition of __memory_barrier()
intrinsics.

However, in doing so, it also removed the preceding #undef barrier by
accident, meaning, the actual barrier() macro from compiler-gcc.h with
inline asm is still in place as __GNUC__ is provided.

Subsequently, barrier() can never be defined as __memory_barrier() from
compiler.h since it already has a definition in place and if we trust the
comment in compiler-intel.h, ecc doesn't support gcc specific asm
statements.

I don't have an ecc at hand (unsure if that's still used in the field?)
and only found this by accident during code review, a revert of that
cleanup would be simplest option.

Fixes: 73679e508201 ("compiler-intel.h: Remove duplicate definition")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: mancha security <mancha1@zoho.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-intel.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/compiler-intel.h~compiler-intel-fix-wrong-compiler-barrier-macro include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h~compiler-intel-fix-wrong-compiler-barrier-macro
+++ a/include/linux/compiler-intel.h
@@ -13,10 +13,12 @@
 /* Intel ECC compiler doesn't support gcc specific asm stmts.
  * It uses intrinsics to do the equivalent things.
  */
+#undef barrier
 #undef barrier_data
 #undef RELOC_HIDE
 #undef OPTIMIZER_HIDE_VAR
 
+#define barrier() __memory_barrier()
 #define barrier_data(ptr) barrier()
 
 #define RELOC_HIDE(ptr, off)					\
_

Patches currently in -mm which might be from daniel@iogearbox.net are

compiler-intel-fix-wrong-compiler-barrier-macro.patch
linux-next.patch

