From: akpm@linux-foundation.org
Subject: [patch 50/94] init/version.c: include <linux/export.h>
 instead of <linux/module.h>
Date: Fri, 17 Nov 2017 15:29:10 -0800
Message-ID: <20171117232910.K8fdBFFUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965501AbdKQX3L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, paul.gortmaker@windriver.com, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: init/version.c: include <linux/export.h> instead of <linux/module.h>

init/version.c has nothing to do with modules, so remove the
<linux/modude.h>.

Instead, include <linux/export.h> for EXPORT_SYMBOL_GPL.

This cuts off a lot of unnecessary header parsing.

Link: http://lkml.kernel.org/r/1505920984-8523-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/version.c~init-version-include-linux-exporth-instead-of-linux-moduleh init/version.c
--- a/init/version.c~init-version-include-linux-exporth-instead-of-linux-moduleh
+++ a/init/version.c
@@ -7,7 +7,7 @@
  */
 
 #include <generated/compile.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <generated/utsrelease.h>
_
