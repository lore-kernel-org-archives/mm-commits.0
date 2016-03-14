From: akpm@linux-foundation.org
Subject: + scripts-gdb-account-for-changes-in-module-data-structure.patch
 added to -mm tree
Date: Mon, 14 Mar 2016 14:48:01 -0700
Message-ID: <56e73191.qy380ac6l8tI0wqn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbcCNVsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2016 17:48:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, jason.wessel@windriver.com, jkosina@suse.cz, kieran.bingham@linaro.org, rusty@rustcorp.com.au, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: account for changes in module data structure
has been added to the -mm tree.  Its filename is
     scripts-gdb-account-for-changes-in-module-data-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-account-for-changes-in-module-data-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-account-for-changes-in-module-data-structure.patch

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
Subject: scripts/gdb: account for changes in module data structure

Commit 7523e4dc50 ("module: use a structure to encapsulate layout.")
factored out the module_layout structure.  Adjust the symbol loader and
the lsmod command to this.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Kieran Bingham <kieran.bingham@linaro.org>
Tested-by: Kieran Bingham <kieran.bingham@linaro.org> (qemu-{ARM,x86})
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: <stable@vger.kernel.org>	[4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |    5 +++--
 scripts/gdb/linux/symbols.py |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-account-for-changes-in-module-data-structure scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-account-for-changes-in-module-data-structure
+++ a/scripts/gdb/linux/modules.py
@@ -73,10 +73,11 @@ class LxLsmod(gdb.Command):
                 "        " if utils.get_long_type().sizeof == 8 else ""))
 
         for module in module_list():
+            layout = module['core_layout']
             gdb.write("{address} {name:<19} {size:>8}  {ref}".format(
-                address=str(module['module_core']).split()[0],
+                address=str(layout['base']).split()[0],
                 name=module['name'].string(),
-                size=str(module['core_size']),
+                size=str(layout['size']),
                 ref=str(module['refcnt']['counter'])))
 
             source_list = module['source_list']
diff -puN scripts/gdb/linux/symbols.py~scripts-gdb-account-for-changes-in-module-data-structure scripts/gdb/linux/symbols.py
--- a/scripts/gdb/linux/symbols.py~scripts-gdb-account-for-changes-in-module-data-structure
+++ a/scripts/gdb/linux/symbols.py
@@ -108,7 +108,7 @@ lx-symbols command."""
 
     def load_module_symbols(self, module):
         module_name = module['name'].string()
-        module_addr = str(module['module_core']).split()[0]
+        module_addr = str(module['core_layout']['base']).split()[0]
 
         module_file = self._get_module_file(module_name)
         if not module_file and not self.module_files_updated:
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

scripts-gdb-account-for-changes-in-module-data-structure.patch

