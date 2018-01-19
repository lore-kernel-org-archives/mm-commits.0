From: akpm@linux-foundation.org
Subject: [patch 4/6] scripts/gdb/linux/tasks.py: fix get_thread_info
Date: Thu, 18 Jan 2018 16:34:00 -0800
Message-ID: <5a613cf8.lVZ1qNyTii6fUAsm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755022AbeASAeC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 19:34:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, imxikangjie@gmail.com, jan.kiszka@siemens.com, kbingham@kernel.org, stable@vger.kernel.org

From: Xi Kangjie <imxikangjie@gmail.com>
Subject: scripts/gdb/linux/tasks.py: fix get_thread_info

Since kernel 4.9, the thread_info has been moved into task_struct, no
longer locates at the bottom of kernel stack.

See c65eacbe290b ("sched/core: Allow putting thread_info into
task_struct") and 15f4eae70d36 ("x86: Move thread_info into task_struct").

Before fix:
(gdb) set $current = $lx_current()
(gdb) p $lx_thread_info($current)
$1 = {flags = 1470918301}
(gdb) p $current.thread_info
$2 = {flags = 2147483648}

After fix:
(gdb) p $lx_thread_info($current)
$1 = {flags = 2147483648}
(gdb) p $current.thread_info
$2 = {flags = 2147483648}

Link: http://lkml.kernel.org/r/20180118210159.17223-1-imxikangjie@gmail.com
Fixes: 15f4eae70d36 ("x86: Move thread_info into task_struct")
Signed-off-by: Xi Kangjie <imxikangjie@gmail.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/tasks.py |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/gdb/linux/tasks.py~scripts-gdb-fix-get_thread_info scripts/gdb/linux/tasks.py
--- a/scripts/gdb/linux/tasks.py~scripts-gdb-fix-get_thread_info
+++ a/scripts/gdb/linux/tasks.py
@@ -96,6 +96,8 @@ def get_thread_info(task):
         thread_info_addr = task.address + ia64_task_size
         thread_info = thread_info_addr.cast(thread_info_ptr_type)
     else:
+        if task.type.fields()[0].type == thread_info_type.get_type():
+            return task['thread_info']
         thread_info = task['stack'].cast(thread_info_ptr_type)
     return thread_info.dereference()
 
_
