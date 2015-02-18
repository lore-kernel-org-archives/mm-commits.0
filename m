From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-lx_current-convenience-function.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:25 -0800
Message-ID: <54e4eb99.I3QV7Lx3xYhGKyqU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbbBRTo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx_current convenience function
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-lx_current-convenience-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add lx_current convenience function

This is a shorthand for *$lx_per_cpu("current_task"), i.e.  a convenience
function to retrieve the currently running task of the active context.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN scripts/gdb/linux/cpus.py~scripts-gdb-add-lx_current-convenience-function scripts/gdb/linux/cpus.py
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-add-lx_current-convenience-function
+++ a/scripts/gdb/linux/cpus.py
@@ -66,3 +66,20 @@ Note that VAR has to be quoted as string
 
 
 PerCpu()
+
+
+class LxCurrentFunc(gdb.Function):
+    """Return current task.
+
+$lx_current([CPU]): Return the per-cpu task variable for the given CPU
+number. If CPU is omitted, the CPU of the current context is used."""
+
+    def __init__(self):
+        super(LxCurrentFunc, self).__init__("lx_current")
+
+    def invoke(self, cpu=-1):
+        var_ptr = gdb.parse_and_eval("&current_task")
+        return per_cpu(var_ptr, cpu).dereference()
+
+
+LxCurrentFunc()
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

