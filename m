From: akpm@linux-foundation.org
Subject: [merged] sh-fix-format-string-bug-in-stack-tracer.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:29:16 -0700
Message-ID: <533f080c.tiJ/oQZlqLg1nysD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDT3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, lethal@linux-sh.org, keescook@chromium.org, matt.fleming@intel.com

Subject: [merged] sh-fix-format-string-bug-in-stack-tracer.patch removed from -mm tree
To: matt.fleming@intel.com,keescook@chromium.org,lethal@linux-sh.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:16 -0700


The patch titled
     Subject: sh: fix format string bug in stack tracer
has been removed from the -mm tree.  Its filename was
     sh-fix-format-string-bug-in-stack-tracer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: sh: fix format string bug in stack tracer

Kees reported the following error,

   arch/sh/kernel/dumpstack.c: In function 'print_trace_address':
>> arch/sh/kernel/dumpstack.c:118:2: error: format not a string literal and no format arguments [-Werror=format-security]

Use the "%s" format so that it's impossible to interpret 'data' as a
format string.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Reported-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/dumpstack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/dumpstack.c~sh-fix-format-string-bug-in-stack-tracer arch/sh/kernel/dumpstack.c
--- a/arch/sh/kernel/dumpstack.c~sh-fix-format-string-bug-in-stack-tracer
+++ a/arch/sh/kernel/dumpstack.c
@@ -115,7 +115,7 @@ static int print_trace_stack(void *data,
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk(data);
+	printk("%s", (char *)data);
 	printk_address(addr, reliable);
 }
 
_

Patches currently in -mm which might be from matt.fleming@intel.com are

origin.patch

