From: akpm@linux-foundation.org
Subject: +
 init-version-include-linux-exporth-instead-of-linux-moduleh.patch added to
 -mm tree
Date: Tue, 26 Sep 2017 17:23:43 -0700
Message-ID: <59caef8f.s9vhv+v0aYpecdKJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964956AbdI0AXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2017 20:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/version.c: include <linux/export.h> instead of <linux/module.h>
has been added to the -mm tree.  Its filename is
     init-version-include-linux-exporth-instead-of-linux-moduleh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-version-include-linux-exporth-instead-of-linux-moduleh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-version-include-linux-exporth-instead-of-linux-moduleh.patch

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

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

bitfieldh-remove-32bit-from-field_get-comment-block.patch
init-version-include-linux-exporth-instead-of-linux-moduleh.patch

