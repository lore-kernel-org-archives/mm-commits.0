From: akpm@linux-foundation.org
Subject: [patch 58/84] scripts/gdb: cast CPU numbers to integer
Date: Mon, 23 May 2016 16:25:05 -0700
Message-ID: <57439151.Ets54242+1/5QzCO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jan.kiszka@siemens.com

From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: cast CPU numbers to integer

We won't see more than 2 billion CPUs any time soon, and having cpu_list
return long makes the output of lx-cpus a bit ugly.

Link: http://lkml.kernel.org/r/dcb45c3b0a59e0fd321fa56ff7aa398458c689b3.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/linux/cpus.py~scripts-gdb-cast-cpu-numbers-to-integer scripts/gdb/linux/cpus.py
--- a/scripts/gdb/linux/cpus.py~scripts-gdb-cast-cpu-numbers-to-integer
+++ a/scripts/gdb/linux/cpus.py
@@ -97,7 +97,7 @@ def cpu_list(mask_name):
         bits >>= 1
         bit += 1
 
-        yield cpu
+        yield int(cpu)
 
 
 def each_online_cpu():
_
