From: akpm@linux-foundation.org
Subject: [merged] introduce-pr_cont-macro.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:56 -0700
Message-ID: <200904011839.n31Idu6H008833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932734AbZDATKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, gorcunov@openvz.org, harvey.harrison@gmail.com, hpa@zytor.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     introduce pr_cont() macro
has been removed from the -mm tree.  Its filename was
     introduce-pr_cont-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce pr_cont() macro
From: Cyrill Gorcunov <gorcunov@gmail.com>

We cover all log-levels by pr_...  macros except KERN_CONT one.  Add it
for convenience.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/kernel.h~introduce-pr_cont-macro include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-pr_cont-macro
+++ a/include/linux/kernel.h
@@ -353,6 +353,8 @@ static inline char *pack_hex_byte(char *
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...) \
+	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch

