From: akpm@linux-foundation.org
Subject: - hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:27:46 -0700
Message-ID: <200710190427.l9J4Rk2W014994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbXJSE2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpw@sgi.com, clameter@sgi.com, mingo@elte.hu, oleg@tv-sign.ru, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     hotplug cpu: documentation addition to downing a cpu
has been removed from the -mm tree.  Its filename was
     hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch

This patch was dropped because it was folded into hotplug-cpu-migrate-a-task-within-its-cpuset.patch

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

origin.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
