From: akpm@linux-foundation.org
Subject: + hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch added to -mm tree
Date: Mon, 27 Aug 2007 16:50:02 -0700
Message-ID: <200708272350.l7RNo2Qf002403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbXH0XuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 19:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, clameter@sgi.com, mingo@elte.hu, oleg@tv-sign.ru, pj@sgi.com


The patch titled
     hotplug cpu: documentation addition to downing a cpu
has been added to the -mm tree.  Its filename is
     hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hotplug cpu: documentation addition to downing a cpu
From: Cliff Wickman <cpw@sgi.com>

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-hotplug.txt |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/cpu-hotplug.txt~hotplug-cpu-migrate-a-task-within-its-cpuset-doc Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt~hotplug-cpu-migrate-a-task-within-its-cpuset-doc
+++ a/Documentation/cpu-hotplug.txt
@@ -220,7 +220,9 @@ A: The following happen, listed in no pa
   CPU_DOWN_PREPARE or CPU_DOWN_PREPARE_FROZEN, depending on whether or not the
   CPU is being offlined while tasks are frozen due to a suspend operation in
   progress
-- All process is migrated away from this outgoing CPU to a new CPU
+- All processes are migrated away from this outgoing CPU to new CPUs.
+  The new CPU is chosen from each process' current cpuset, which may be
+  a subset of all online CPUs.
 - All interrupts targeted to this CPU is migrated to a new CPU
 - timers/bottom half/task lets are also migrated to a new CPU
 - Once all services are migrated, kernel calls an arch specific routine
_

Patches currently in -mm which might be from cpw@sgi.com are

do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
