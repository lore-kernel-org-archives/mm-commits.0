From: akpm@linux-foundation.org
Subject: + scripts-gdb-cast-cpu-numbers-to-integer.patch added to -mm tree
Date: Tue, 10 May 2016 12:34:34 -0700
Message-ID: <573237ca.My143mnDZbgAeMCf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbcEJTef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: cast CPU numbers to integer
has been added to the -mm tree.  Its filename is
     scripts-gdb-cast-cpu-numbers-to-integer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-cast-cpu-numbers-to-integer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-cast-cpu-numbers-to-integer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jan.kiszka@siemens.com are

scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch
scripts-gdb-cast-cpu-numbers-to-integer.patch

