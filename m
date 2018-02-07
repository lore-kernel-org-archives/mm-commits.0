From: akpm@linux-foundation.org
Subject: [merged] genl_magic-remove-own-build_bug_on-defines.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:00 -0800
Message-ID: <20180207195900.Y5adSSyV_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbeBGT7C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com, yoshfuji@linux-ipv6.org


The patch titled
     Subject: include/linux/genl_magic_func.h: remove own BUILD_BUG_ON*() defines
has been removed from the -mm tree.  Its filename was
     genl_magic-remove-own-build_bug_on-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: include/linux/genl_magic_func.h: remove own BUILD_BUG_ON*() defines

Do not duplicate BUILD_BUG_ON*.  Use ones from <linux/build_bug.h>.

Link: http://lkml.kernel.org/r/1515121833-3174-2-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genl_magic_func.h |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN include/linux/genl_magic_func.h~genl_magic-remove-own-build_bug_on-defines include/linux/genl_magic_func.h
--- a/include/linux/genl_magic_func.h~genl_magic-remove-own-build_bug_on-defines
+++ a/include/linux/genl_magic_func.h
@@ -2,6 +2,7 @@
 #ifndef GENL_MAGIC_FUNC_H
 #define GENL_MAGIC_FUNC_H
 
+#include <linux/build_bug.h>
 #include <linux/genl_magic_struct.h>
 
 /*
@@ -132,17 +133,6 @@ static void dprint_array(const char *dir
  * use one static buffer for parsing of nested attributes */
 static struct nlattr *nested_attr_tb[128];
 
-#ifndef BUILD_BUG_ON
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
-#endif
