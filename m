From: akpm@linux-foundation.org
Subject: + linux-kernelh-fix-kernel-doc-warning.patch added to -mm tree
Date: Mon, 13 May 2013 14:02:46 -0700
Message-ID: <20130513210246.708D231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39712 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3EMVCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:02:47 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so318513qae.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:02:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@infradead.org, rostedt@goodmis.org


The patch titled
     Subject: linux/kernel.h: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     linux-kernelh-fix-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-kernelh-fix-kernel-doc-warning.patch
debugging-keep-track-of-page-owners-fix-2.patch

