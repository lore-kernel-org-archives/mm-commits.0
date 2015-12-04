From: akpm@linux-foundation.org
Subject: +
 printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch added to
 -mm tree
Date: Fri, 04 Dec 2015 15:55:29 -0800
Message-ID: <566227f1.fdXEhqhz2BqeuRr+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbbLDXza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:55:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aconole@redhat.com, dvyukov@google.com, jbaron@akamai.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: help pr_debug and pr_devel to optimize out arguments
has been added to the -mm tree.  Its filename is
     printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaron Conole <aconole@redhat.com>
Subject: printk: help pr_debug and pr_devel to optimize out arguments

Currently, pr_debug and pr_devel will not elide function call arguments
appearing in calls to the no_printk for these macros.  This is because all
side effects must be honored before proceeding to the 0-value assignment
in no_printk.

The behavior is contrary to documentation found in the CodingStyle and the
header file where these functions are declared.

This patch corrects that behavior by shunting out the call to no_printk
completely.  The format string is still checked by gcc for correctness,
but no code seems to be emitted in common cases.

Fixes: 5264f2f75d86 ("include/linux/printk.h: use and neaten no_printk")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/printk.h~printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments include/linux/printk.h
--- a/include/linux/printk.h~printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments
+++ a/include/linux/printk.h
@@ -106,13 +106,14 @@ struct va_format {
 
 /*
  * Dummy printk for disabled debugging statements to use whilst maintaining
- * gcc's format and side-effect checking.
+ * gcc's format checking.
  */
-static inline __printf(1, 2)
-int no_printk(const char *fmt, ...)
-{
-	return 0;
-}
+#define no_printk(fmt, ...)			\
+do {						\
+	if (0) {				\
+		printk(fmt, ##__VA_ARGS__);	\
+	}					\
+} while (0)
 
 #ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __printf(1, 2)
_

Patches currently in -mm which might be from aconole@redhat.com are

printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments.patch

