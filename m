From: akpm@linux-foundation.org
Subject: + kernelh-add-is_ptr_aligned-macro.patch added to -mm tree
Date: Wed, 29 Mar 2017 14:38:08 -0700
Message-ID: <58dc2940.YhYD/x+xFie1UEzE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932827AbdC2ViJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 17:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: add IS_PTR_ALIGNED() macro
has been added to the -mm tree.  Its filename is
     kernelh-add-is_ptr_aligned-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-add-is_ptr_aligned-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-add-is_ptr_aligned-macro.patch

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
Subject: kernel.h: add IS_PTR_ALIGNED() macro

We often check if a pointer has a specific alignment.  Because the '&'
(bitwise AND) operator cannot take a pointer for the operand, so we need a
cast like, IS_ALIGNED((unsigned long)p, a).

IS_PTR_ALIGNED will be useful as a shorthand.

Link: http://lkml.kernel.org/r/1490782930-30429-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kernel.h~kernelh-add-is_ptr_aligned-macro include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-is_ptr_aligned-macro
+++ a/include/linux/kernel.h
@@ -50,6 +50,7 @@
 #define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
+#define IS_PTR_ALIGNED(p, a)		(IS_ALIGNED((unsigned long)p, a))
 
 /* generic data direction definitions */
 #define READ			0
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
kernelh-add-is_ptr_aligned-macro.patch

