From: akpm@linux-foundation.org
Subject: [patch 53/84] scripts/gdb: support !CONFIG_MODULES gracefully
Date: Mon, 23 May 2016 16:24:51 -0700
Message-ID: <57439143.0UELwLp0y0gBVGfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com

From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: support !CONFIG_MODULES gracefully

If CONFIG_MODULES is not enabled, lx-lsmod tries to find
a non-existent symbol and generates an unfriendly traceback:

(gdb) lx-lsmod
Address    Module                  Size  Used by
Traceback (most recent call last):
  File "scripts/gdb/linux/modules.py", line 75, in invoke
    for module in module_list():
  File "scripts/gdb/linux/modules.py", line 24, in module_list
    module_ptr_type = module_type.get_type().pointer()
  File "scripts/gdb/linux/utils.py", line 28, in get_type
    self._type = gdb.lookup_type(self._name)
gdb.error: No struct type named module.
Error occurred in Python command: No struct type named module.

Catch the error and return an empty module_list() for a clean command
output as follows:

(gdb) lx-lsmod
Address    Module                  Size  Used by
(gdb)

Link: http://lkml.kernel.org/r/94d533819437408b85ae5864f939dd7ca6fbfcd6.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-support-config_modules-gracefully scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-support-config_modules-gracefully
+++ a/scripts/gdb/linux/modules.py
@@ -21,8 +21,11 @@ module_type = utils.CachedType("struct m
 
 def module_list():
     global module_type
+    modules = utils.gdb_eval_or_none("modules")
+    if modules is None:
+        return
+
     module_ptr_type = module_type.get_type().pointer()
-    modules = gdb.parse_and_eval("modules")
 
     for module in lists.list_for_each_entry(modules, module_ptr_type, "list"):
         yield module
_
