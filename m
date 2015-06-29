From: akpm@linux-foundation.org
Subject: [merged] compiler-intel-fix-wrong-compiler-barrier-macro.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:00 -0700
Message-ID: <5591aec4.kD2xZMpnw8RW3unH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbF2UrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@iogearbox.net, bobby.prani@gmail.com, hpa@zytor.com, mancha1@zoho.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-intel: fix wrong compiler barrier() macro
has been removed from the -mm tree.  Its filename was
     compiler-intel-fix-wrong-compiler-barrier-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

