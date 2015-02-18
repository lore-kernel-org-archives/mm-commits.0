From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:44:49 -0800
Message-ID: <54e4ebb1.oyiTeuNQK1iMwm34%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: disable pagination while printing from breakpoint handler
has been removed from the -mm tree.  Its filename was
     scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: disable pagination while printing from breakpoint handler

While reporting the (refreshed) list of modules on automatic updates we
may hit the page boundary of the output console and cause a stop if
pagination is enabled.  However, gdb does not accept user input while
running over the breakpoint handler.  So we get stuck, and the user is
forced to interrupt gdb.

Resolve this by disabling pagination during automatic symbol updates.  We
restore the user's configuration once done.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler
+++ a/scripts/gdb/linux/symbols.py
@@ -34,12 +34,23 @@ if hasattr(gdb, 'Breakpoint'):
             # enforce update if object file is not found
             cmd.module_files_updated = False
 
+            # Disable pagination while reporting symbol (re-)loading.
+            # The console input is blocked in this context so that we would
+            # get stuck waiting for the user to acknowledge paged output.
+            show_pagination = gdb.execute("show pagination", to_string=True)
+            pagination = show_pagination.endswith("on.\n")
+            gdb.execute("set pagination off")
+
             if module_name in cmd.loaded_modules:
                 gdb.write("refreshing all symbols to reload module "
                           "'{0}'\n".format(module_name))
                 cmd.load_all_symbols()
             else:
                 cmd.load_module_symbols(module)
+
+            # restore pagination state
+            gdb.execute("set pagination %s" % ("on" if pagination else "off"))
+
             return False
 
 
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

