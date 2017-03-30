From: akpm@linux-foundation.org
Subject: [withdrawn] kernelh-add-is_ptr_aligned-macro.patch removed from
 -mm tree
Date: Thu, 30 Mar 2017 14:16:53 -0700
Message-ID: <58dd75c5.66CnFCrNHXrZVOMq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933428AbdC3VQz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 17:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: add IS_PTR_ALIGNED() macro
has been removed from the -mm tree.  Its filename was
     kernelh-add-is_ptr_aligned-macro.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: kernel.h: add IS_PTR_ALIGNED() macro

We often check if a pointer has a specific alignment.  Because the '&'
(bitwise AND) operator cannot take a pointer for the operand, so we need a
cast like, IS_ALIGNED((unsigned long)p, a).

IS_PTR_ALIGNED will be useful as a shorthand.

Link: http://lkml.kernel.org/r/1490782930-30429-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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

