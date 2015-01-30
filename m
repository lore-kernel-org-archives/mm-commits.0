From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch added to -mm tree
Date: Fri, 30 Jan 2015 15:37:11 -0800
Message-ID: <54cc15a7.ee3d+3o6m9NTQ6OZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbbA3XhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: disable pagination while printing from breakpoint handler
has been added to the -mm tree.  Its filename is
     scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-add-infrastructure.patch
scripts-gdb-add-cache-for-type-objects.patch
scripts-gdb-add-container_of-helper-and-convenience-function.patch
scripts-gdb-add-module-iteration-class.patch
scripts-gdb-add-lx-symbols-command.patch
module-do-not-inline-do_init_module.patch
scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch
scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch
scripts-gdb-add-get_target_endianness-helper.patch
scripts-gdb-add-read_u16-32-64-helpers.patch
scripts-gdb-add-lx-dmesg-command.patch
scripts-gdb-add-task-iteration-class.patch
scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks.patch
scripts-gdb-add-is_target_arch-helper.patch
scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch
scripts-gdb-add-get_gdbserver_type-helper.patch
scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup.patch
scripts-gdb-add-lx_current-convenience-function.patch
scripts-gdb-add-class-to-iterate-over-cpu-masks.patch
scripts-gdb-add-lx-lsmod-command.patch
scripts-gdb-add-basic-documentation.patch
scripts-gdb-port-to-python3-gdb77.patch
scripts-gdb-ignore-byte-compiled-python-files.patch
scripts-gdb-use-a-generator-instead-of-iterator-for-task-list.patch
scripts-gdb-convert-modulelist-to-generator-function.patch
scripts-gdb-convert-cpulist-to-generator-function.patch
scripts-gdb-define-maintainer.patch
scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch

