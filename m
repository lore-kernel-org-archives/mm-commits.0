From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-io-resource-readers.patch added to -mm tree
Date: Tue, 10 May 2016 12:34:28 -0700
Message-ID: <573237c4.DtCub1suh9MLR66A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbcEJTe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add io resource readers
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-io-resource-readers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-io-resource-readers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-io-resource-readers.patch

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
Subject: scripts/gdb: add io resource readers

Provide iomem_resource and ioports_resource printers and command hooks

It can be quite interesting to halt the kernel as it's booting and check
to see this list as it is being populated.

It should be useful in the event that a kernel is not booting, you
can identify what memory resources have been registered

Link: http://lkml.kernel.org/r/f0a6b9fa9c92af4d7ed2e7343ccc84150e9c6fc5.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py |   57 ++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff -puN scripts/gdb/linux/proc.py~scripts-gdb-add-io-resource-readers scripts/gdb/linux/proc.py
--- a/scripts/gdb/linux/proc.py~scripts-gdb-add-io-resource-readers
+++ a/scripts/gdb/linux/proc.py
@@ -39,3 +39,60 @@ class LxVersion(gdb.Command):
         gdb.write(gdb.parse_and_eval("linux_banner").string())
 
 LxVersion()
+
+
+# Resource Structure Printers
+#  /proc/iomem
+#  /proc/ioports
+
+def get_resources(resource, depth):
+    while resource:
+        yield resource, depth
+
+        child = resource['child']
+        if child:
+            for res, deep in get_resources(child, depth + 1):
+                yield res, deep
+
+        resource = resource['sibling']
+
+
+def show_lx_resources(resource_str):
+        resource = gdb.parse_and_eval(resource_str)
+        width = 4 if resource['end'] < 0x10000 else 8
+        # Iterate straight to the first child
+        for res, depth in get_resources(resource['child'], 0):
+            start = int(res['start'])
+            end = int(res['end'])
+            gdb.write(" " * depth * 2 +
+                      "{0:0{1}x}-".format(start, width) +
+                      "{0:0{1}x} : ".format(end, width) +
+                      res['name'].string() + "\n")
+
+
+class LxIOMem(gdb.Command):
+    """Identify the IO memory resource locations defined by the kernel
+
+Equivalent to cat /proc/iomem on a running target"""
+
+    def __init__(self):
+        super(LxIOMem, self).__init__("lx-iomem", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        return show_lx_resources("iomem_resource")
+
+LxIOMem()
+
+
+class LxIOPorts(gdb.Command):
+    """Identify the IO port resource locations defined by the kernel
+
+Equivalent to cat /proc/ioports on a running target"""
+
+    def __init__(self):
+        super(LxIOPorts, self).__init__("lx-ioports", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        return show_lx_resources("ioport_resource")
+
+LxIOPorts()
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

