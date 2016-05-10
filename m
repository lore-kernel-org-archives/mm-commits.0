From: akpm@linux-foundation.org
Subject: + scripts-gdb-add-lx_thread_info_by_pid-helper.patch added to -mm tree
Date: Tue, 10 May 2016 12:34:40 -0700
Message-ID: <573237d0.sxvc71w4PUeUdQdQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbcEJTel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add lx_thread_info_by_pid helper
has been added to the -mm tree.  Its filename is
     scripts-gdb-add-lx_thread_info_by_pid-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-add-lx_thread_info_by_pid-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-add-lx_thread_info_by_pid-helper.patch

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
Subject: scripts/gdb: add lx_thread_info_by_pid helper

The tasks module already provides helpers to find the task struct by
pid, and the thread_info by task struct; however this is cumbersome to
utilise on the gdb commandline.

Wrap these two functionalities together in an extra single helper to
allow exploring the thread info, from a PID value

Link: http://lkml.kernel.org/r/dadc5667f053ec811eb3e3033d99d937fedbc93b.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-add-lx_thread_info_by_pid-helper scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-add-lx_thread_info_by_pid-helper
+++ a/scripts/gdb/linux/tasks.py
@@ -114,3 +114,22 @@ variable."""
 
 
 LxThreadInfoFunc()
+
+
+class LxThreadInfoByPidFunc (gdb.Function):
+    """Calculate Linux thread_info from task variable found by pid
+
+$lx_thread_info_by_pid(PID): Given PID, return the corresponding thread_info
+variable."""
+
+    def __init__(self):
+        super(LxThreadInfoByPidFunc, self).__init__("lx_thread_info_by_pid")
+
+    def invoke(self, pid):
+        task = get_task_by_pid(pid)
+        if task:
+            return get_thread_info(task.dereference())
+        else:
+            raise gdb.GdbError("No task of PID " + str(pid))
+
+LxThreadInfoByPidFunc()
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

