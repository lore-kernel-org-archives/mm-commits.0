From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-cpu-iterators.patch added to -mm tree
Date: Tue, 10 May 2016 12:34:32 -0700
Message-ID: <573237c8.r9mw+hm83sSb01gz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbcEJTed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add cpu iterators
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-cpu-iterators.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-cpu-iterators.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-cpu-iterators.patch

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
Subject: scripts/gdb: add cpu iterators

The linux kernel provides macro's for iterating against values from the
cpu_list masks. By providing some commonly used masks, we can mirror the
kernels helper macros with easy to use generators.

Link: http://lkml.kernel.org/r/d045c6599771ada1999d49612ee30fd2f9acf17f.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |   38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN scripts/gdb/linux/cpus.py~scripts-gdb-add-cpu-iterators scripts/gdb/linux/cpus.py
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-add-cpu-iterators
+++ a/scripts/gdb/linux/cpus.py
@@ -100,6 +100,44 @@ def cpu_list(mask_name):
         yield cpu
 
 
+def each_online_cpu():
+    for cpu in cpu_list("__cpu_online_mask"):
+        yield cpu
+
+
+def each_present_cpu():
+    for cpu in cpu_list("__cpu_present_mask"):
+        yield cpu
+
+
+def each_possible_cpu():
+    for cpu in cpu_list("__cpu_possible_mask"):
+        yield cpu
+
+
+def each_active_cpu():
+    for cpu in cpu_list("__cpu_active_mask"):
+        yield cpu
+
+
+class LxCpus(gdb.Command):
+    """List CPU status arrays
+
+Displays the known state of each CPU based on the kernel masks
+and can help identify the state of hotplugged CPUs"""
+
+    def __init__(self):
+        super(LxCpus, self).__init__("lx-cpus", gdb.COMMAND_DATA)
+
+    def invoke(self, arg, from_tty):
+        gdb.write("Possible CPUs : {}\n".format(list(each_possible_cpu())))
+        gdb.write("Present CPUs  : {}\n".format(list(each_present_cpu())))
+        gdb.write("Online CPUs   : {}\n".format(list(each_online_cpu())))
+        gdb.write("Active CPUs   : {}\n".format(list(each_active_cpu())))
+
+LxCpus()
+
+
 class PerCpu(gdb.Function):
     """Return per-cpu variable.
 
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

