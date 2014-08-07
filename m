From: akpm@linux-foundation.org
Subject: [merged]
 tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:55 -0700
Message-ID: <53e3dbe7.USctbrD9sDd2j0rl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:42542 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:55 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1173831pde.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: masbock@linux.vnet.ibm.com, mgorman@suse.de, mingo@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm tracing: tell mm_migrate_pages event about numa_misplaced
has been removed from the -mm tree.  Its filename was
     tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Max Asbock <masbock@linux.vnet.ibm.com>
Subject: mm tracing: tell mm_migrate_pages event about numa_misplaced

The mm_migrate_pages trace event reports a reason for the migration,
typically as a symbolic string.  The exception is the reason
MR_NUMA_MISPLACED for which it just displays the numeric value:
mm_migrate_pages: nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=0x5

This patch makes the output consistent by introducing a string value for
MR_NUMA_MISPLACED.  The event is then reported as: mm_migrate_pages:
nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=numa_misplaced

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/trace/events/migrate.h~tracing-tell-mm_migrate_pages-event-about-numa_misplaced include/trace/events/migrate.h
--- a/include/trace/events/migrate.h~tracing-tell-mm_migrate_pages-event-about-numa_misplaced
+++ a/include/trace/events/migrate.h
@@ -17,6 +17,7 @@
 	{MR_MEMORY_HOTPLUG,	"memory_hotplug"},		\
 	{MR_SYSCALL,		"syscall_or_cpuset"},		\
 	{MR_MEMPOLICY_MBIND,	"mempolicy_mbind"},		\
+	{MR_NUMA_MISPLACED,	"numa_misplaced"},		\
 	{MR_CMA,		"cma"}
 
 TRACE_EVENT(mm_migrate_pages,
_

Patches currently in -mm which might be from masbock@linux.vnet.ibm.com are

origin.patch

