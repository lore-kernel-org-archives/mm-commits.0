From: akpm@linux-foundation.org
Subject: [merged] linux-kernelh-fix-kernel-doc-warning.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:36:55 -0700
Message-ID: <51a50757.SGTLWc3QqhyIhsEr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3E1Tg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, rdunlap@infradead.org

Subject: [merged] linux-kernelh-fix-kernel-doc-warning.patch removed from -mm tree
To: rdunlap@infradead.org,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:55 -0700


The patch titled
     Subject: linux/kernel.h: fix kernel-doc warning
has been removed from the -mm tree.  Its filename was
     linux-kernelh-fix-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: linux/kernel.h: fix kernel-doc warning

Fix kernel-doc warning in <linux/kernel.h>:

Warning(include/linux/kernel.h:590): No description found for parameter 'ip'

scripts/kernel-doc cannot handle macros, functions, or function
prototypes between the function or macro that is being documented
and its definition, so move these prototypes above the function
that is being documented.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~linux-kernelh-fix-kernel-doc-warning include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-fix-kernel-doc-warning
+++ a/include/linux/kernel.h
@@ -562,6 +562,9 @@ int __trace_bprintk(unsigned long ip, co
 extern __printf(2, 3)
 int __trace_printk(unsigned long ip, const char *fmt, ...);
 
+extern int __trace_bputs(unsigned long ip, const char *str);
+extern int __trace_puts(unsigned long ip, const char *str, int size);
+
 /**
  * trace_puts - write a string into the ftrace buffer
  * @str: the string to record
@@ -587,8 +590,6 @@ int __trace_printk(unsigned long ip, con
  *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
  */
 
-extern int __trace_bputs(unsigned long ip, const char *str);
-extern int __trace_puts(unsigned long ip, const char *str, int size);
 #define trace_puts(str) ({						\
 	static const char *trace_printk_fmt				\
 		__attribute__((section("__trace_printk_fmt"))) =	\
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch

