From: akpm@linux-foundation.org
Subject: [patch 099/124] include/linux/iopoll.h: include <linux/ktime.h>
 instead of <linux/hrtimer.h>
Date: Fri, 24 Feb 2017 15:00:29 -0800
Message-ID: <58b0bb0d.Tl/Dx0xHQTD8SBCq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdBXXAa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: include/linux/iopoll.h: include <linux/ktime.h> instead of <linux/hrtimer.h>

The timer APIs this header needs are ktime_get(), ktime_add_us(), and
ktime_compare().  So, including <linux/ktime.h> seems enough.  This commit
will cut unnecessary header file parsing.

Link: http://lkml.kernel.org/r/1481679225-10885-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iopoll.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/iopoll.h~iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh include/linux/iopoll.h
--- a/include/linux/iopoll.h~iopoll-include-linux-ktimeh-instead-of-linux-hrtimerh
+++ a/include/linux/iopoll.h
@@ -17,7 +17,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/hrtimer.h>
+#include <linux/ktime.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/io.h>
_
