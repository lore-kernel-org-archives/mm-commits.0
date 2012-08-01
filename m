From: akpm@linux-foundation.org
Subject: [merged] mm-oom-do-not-schedule-if-current-has-been-killed.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:05 -0700
Message-ID: <20120801201306.439D35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37744 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:08 -0400
Received: by wgbdt11 with SMTP id dt11so342519wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not schedule if current has been killed
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-schedule-if-current-has-been-killed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: do not schedule if current has been killed

The oom killer currently schedules away from current in an uninterruptible
sleep if it does not have access to memory reserves.  It's possible that
current was killed because it shares memory with the oom killed thread or
because it was killed by the user in the interim, however.

This patch only schedules away from current if it does not have a pending
kill, i.e.  if it does not share memory with the oom killed thread.  It's
possible that it will immediately retry its memory allocation and fail,
but it will immediately be given access to memory reserves if it calls the
oom killer again.

This prevents the delay of memory freeing when threads that share memory
with the oom killed thread get unnecessarily scheduled.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-schedule-if-current-has-been-killed mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-schedule-if-current-has-been-killed
+++ a/mm/oom_kill.c
@@ -745,11 +745,11 @@ out:
 	read_unlock(&tasklist_lock);
 
 	/*
-	 * Give "p" a good chance of killing itself before we
-	 * retry to allocate memory unless "p" is current
+	 * Give the killed threads a good chance of exiting before trying to
+	 * allocate memory again.
 	 */
-	if (killed && !test_thread_flag(TIF_MEMDIE))
-		schedule_timeout_uninterruptible(1);
+	if (killed)
+		schedule_timeout_killable(1);
 }
 
 /*
@@ -764,6 +764,5 @@ void pagefault_out_of_memory(void)
 		out_of_memory(NULL, 0, 0, NULL, false);
 		clear_system_oom();
 	}
-	if (!test_thread_flag(TIF_MEMDIE))
-		schedule_timeout_uninterruptible(1);
+	schedule_timeout_killable(1);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
slab-do-not-call-compound_head-in-page_get_cache.patch

