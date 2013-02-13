From: akpm@linux-foundation.org
Subject: + printk-add-pr_devel_once-and-pr_devel_ratelimited.patch added to -mm tree
Date: Wed, 13 Feb 2013 13:38:50 -0800
Message-ID: <20130213213850.8E44831C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45643 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3BMViv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 16:38:51 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so620734ggi.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 13:38:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michail.gruzdev@gmail.com, gregkh@linuxfoundation.org


The patch titled
     Subject: printk: add pr_devel_once and pr_devel_ratelimited
has been added to the -mm tree.  Its filename is
     printk-add-pr_devel_once-and-pr_devel_ratelimited.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikhail Gruzdev <michail.gruzdev@gmail.com>
Subject: printk: add pr_devel_once and pr_devel_ratelimited

Standardize pr_devel logging macros family by adding pr_devel_once and
pr_devel_ratelimited.

Signed-off-by: Mikhail Gruzdev <michail.gruzdev@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN include/linux/printk.h~printk-add-pr_devel_once-and-pr_devel_ratelimited include/linux/printk.h
--- a/include/linux/printk.h~printk-add-pr_devel_once-and-pr_devel_ratelimited
+++ a/include/linux/printk.h
@@ -252,6 +252,15 @@ extern void dump_stack(void) __cold;
 	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont_once(fmt, ...)					\
 	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
+
+#if defined(DEBUG)
+#define pr_devel_once(fmt, ...)					\
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel_once(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_once(fmt, ...)					\
@@ -295,6 +304,15 @@ extern void dump_stack(void) __cold;
 #define pr_info_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
+
+#if defined(DEBUG)
+#define pr_devel_ratelimited(fmt, ...)					\
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel_ratelimited(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
_

Patches currently in -mm which might be from michail.gruzdev@gmail.com are

printk-add-pr_devel_once-and-pr_devel_ratelimited.patch

