From: akpm@linux-foundation.org
Subject: + genl_magic-remove-own-build_bug_on-defines.patch added to -mm
 tree
Date: Fri, 05 Jan 2018 13:01:15 -0800
Message-ID: <5a4fe79b.Z7SX+/PqsQXyVux1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbeAEVBR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jan 2018 16:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, abbotti@mev.co.uk, davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/genl_magic_func.h: remove own BUILD_BUG_ON*() defines
has been added to the -mm tree.  Its filename is
     genl_magic-remove-own-build_bug_on-defines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genl_magic-remove-own-build_bug_on-defines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genl_magic-remove-own-build_bug_on-defines.patch

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
