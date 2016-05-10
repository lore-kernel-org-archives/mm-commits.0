From: akpm@linux-foundation.org
Subject: + scripts-gdb-support-config_modules-gracefully.patch added to
 -mm tree
Date: Tue, 10 May 2016 12:34:24 -0700
Message-ID: <573237c0.HATQ+Znl265CmwhQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcEJTeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: support !CONFIG_MODULES gracefully
has been added to the -mm tree.  Its filename is
     scripts-gdb-support-config_modules-gracefully.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-support-config_modules-gracefully.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-support-config_modules-gracefully.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kieran.bingham@linaro.org are

scripts-gdb-provide-linux-constants.patch
scripts-gdb-provide-kernel-list-item-generators.patch
scripts-gdb-convert-modules-usage-to-lists-functions.patch
scripts-gdb-provide-exception-catching-parser.patch
scripts-gdb-support-config_modules-gracefully.patch
scripts-gdb-provide-a-dentry_name-vfs-path-helper.patch
scripts-gdb-add-io-resource-readers.patch
scripts-gdb-add-mount-point-list-command.patch
scripts-gdb-add-cpu-iterators.patch
scripts-gdb-add-a-radix-tree-parser.patch
scripts-gdb-add-documentation-example-for-radix-tree.patch
scripts-gdb-add-lx_thread_info_by_pid-helper.patch

