From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-fix-issue-with-dmesgpy-and-python-3x.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:44:26 -0700
Message-ID: <5748958a.pY3Xj6Ij6A0f69wT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbcE0So1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buzdelabuz2+git@gmail.com, jan.kiszka@siemens.com, kieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix issue with dmesg.py and python 3.X
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-issue-with-dmesgpy-and-python-3x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dom Cote <buzdelabuz2+git@gmail.com>
Subject: scripts/gdb: fix issue with dmesg.py and python 3.X

When built against Python 3, GDB differs in the return type for its
read_memory function, causing the lx-dmesg command to fail.

Now that we have an improved read_16() we can use the new read_memoryview()
abstraction to make lx-dmesg return valid data on both current Python APIs

Tested with python 3.4 and 2.7
Tested with gdb 7.7

Link: http://lkml.kernel.org/r/28477b727ff7fe3101fd4e426060e8a68317a639.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Dom Cote <buzdelabuz2+git@gmail.com>
[kieran@bingham.xyz: Adjusted commit log to better reflect code changes]
Tested-by: Kieran Bingham <kieran@bingham.xyz> (Py2.7,Py3.4,GDB10)
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-fix-issue-with-dmesgpy-and-python-3x scripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-fix-issue-with-dmesgpy-and-python-3x
+++ a/scripts/gdb/linux/dmesg.py
@@ -33,11 +33,12 @@ class LxDmesg(gdb.Command):
         if log_first_idx < log_next_idx:
             log_buf_2nd_half = -1
             length = log_next_idx - log_first_idx
-            log_buf = inf.read_memory(start, length)
+            log_buf = utils.read_memoryview(inf, start, length).tobytes()
         else:
             log_buf_2nd_half = log_buf_len - log_first_idx
-            log_buf = inf.read_memory(start, log_buf_2nd_half) + \
-                inf.read_memory(log_buf_addr, log_next_idx)
+            a = utils.read_memoryview(inf, start, log_buf_2nd_half)
+            b = utils.read_memoryview(inf, log_buf_addr, log_next_idx)
+            log_buf = a.tobytes() + b.tobytes()
 
         pos = 0
         while pos < log_buf.__len__():
_

Patches currently in -mm which might be from buzdelabuz2+git@gmail.com are


