From: akpm@linux-foundation.org
Subject: [merged] printk-add-pr_devel_once-and-pr_devel_ratelimited.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:59 -0800
Message-ID: <20130222203959.A95C05A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:48300 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3BVUkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:00 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so103836ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michail.gruzdev@gmail.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add pr_devel_once and pr_devel_ratelimited
has been removed from the -mm tree.  Its filename was
     printk-add-pr_devel_once-and-pr_devel_ratelimited.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

