From: akpm@linux-foundation.org
Subject: [patch 52/84] scripts/gdb: provide exception catching parser
Date: Mon, 23 May 2016 16:24:48 -0700
Message-ID: <57439140.1MCVtr5cpJP3OYR1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com

From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: provide exception catching parser

If we attempt to read a value that is not available to GDB, an exception
is raised.  Most of the time, this is a good thing; however on occasion we
will want to be able to determine if a symbol is available.

By catching the exception to simply return None, we can determine if we
tried to read an invalid value, without the exception taking our execution
context away from us

Link: http://lkml.kernel.org/r/c72b25c06fc66e1d68371154097e2cbb112555d8.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-provide-exception-catching-parser scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-provide-exception-catching-parser
+++ a/scripts/gdb/linux/utils.py
@@ -154,3 +154,10 @@ def get_gdbserver_type():
         if gdbserver_type is not None and hasattr(gdb, 'events'):
             gdb.events.exited.connect(exit_handler)
     return gdbserver_type
+
+
+def gdb_eval_or_none(expresssion):
+    try:
+        return gdb.parse_and_eval(expresssion)
+    except:
+        return None
_
