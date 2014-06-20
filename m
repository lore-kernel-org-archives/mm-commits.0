From: akpm@linux-foundation.org
Subject: + tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 15:28:03 -0700
Message-ID: <53a4b573.uw0Z8CPas3td5zUN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTW2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com, mgorman@suse.de, masbock@linux.vnet.ibm.com


The patch titled
     Subject: mm tracing: tell mm_migrate_pages event about numa_misplaced
has been added to the -mm tree.  Its filename is
     tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
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
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from masbock@linux.vnet.ibm.com are

tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch

