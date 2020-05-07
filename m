From: akpm@linux-foundation.org
Subject: + mm-expand-documentation-over-__read_mostly.patch added
 to -mm tree
Date: Thu, 07 May 2020 13:11:48 -0700
Message-ID: <20200507201148.c2UF0r3jc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgEGULt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 16:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, arnd@arndb.de, cl@linux.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: include/linux/cache.h: expand documentation over __read_mostly
has been added to the -mm tree.  Its filename is
     mm-expand-documentation-over-__read_mostly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-expand-documentation-over-__read_mostly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-expand-documentation-over-__read_mostly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: include/linux/cache.h: expand documentation over __read_mostly

__read_mostly can easily be misused by folks, its not meant for just
read-only data.  There are performance reasons for using it, but we also
don't provide any guidance about its use.  Provide a bit more guidance
over its use.

Link: http://lkml.kernel.org/r/20200507161424.2584-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cache.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/cache.h~mm-expand-documentation-over-__read_mostly
+++ a/include/linux/cache.h
@@ -15,8 +15,14 @@
 
 /*
  * __read_mostly is used to keep rarely changing variables out of frequently
- * updated cachelines. If an architecture doesn't support it, ignore the
- * hint.
+ * updated cachelines. Its use should be reserved for data that is used
+ * frequently in hot paths. Performance traces can help decide when to use
+ * this. You want __read_mostly data to be tightly packed, so that in the
+ * best case multiple frequently read variables for a hot path will be next
+ * to each other in order to reduce the number of cachelines needed to
+ * execute a critical path. We should be mindful and selective of its use.
+ * ie: if you're going to use it please supply a *good* justification in your
+ * commit log
  */
 #ifndef __read_mostly
 #define __read_mostly
_

Patches currently in -mm which might be from mcgrof@kernel.org are

mm-expand-documentation-over-__read_mostly.patch
