From: akpm@linux-foundation.org
Subject: [patch 61/84] scripts/gdb: add lx_thread_info_by_pid helper
Date: Mon, 23 May 2016 16:25:13 -0700
Message-ID: <57439159.n6ljjdXQ/2Q2sWb9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbcEWXZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, jan.kiszka@siemens.com

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
