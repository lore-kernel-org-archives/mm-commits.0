From: akpm@linux-foundation.org
Subject: + scripts-gdb-fix-get_thread_info.patch added to -mm tree
Date: Thu, 18 Jan 2018 13:51:09 -0800
Message-ID: <5a6116cd.2X+2RNeTF4q3ypPg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbeARVvK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 16:51:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imxikangjie@gmail.com, jan.kiszka@siemens.com, kbingham@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/linux/tasks.py: fix get_thread_info
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-get_thread_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-get_thread_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-get_thread_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from imxikangjie@gmail.com are

scripts-gdb-fix-get_thread_info.patch

