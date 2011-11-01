From: akpm@linux-foundation.org
Subject: [merged] lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:01 -0700
Message-ID: <201111012116.pA1LG2DY020243@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1KAVQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_counter.c: enclose hotplug only variables in hotplug ifdef
has been removed from the -mm tree.  Its filename was
     lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: lib/percpu_counter.c: enclose hotplug only variables in hotplug ifdef

These variables are only used when CONFIG_HOTPLUG_CPU is enabled, they are
ifdef'ed everywhere else.  So don't define them when CONFIG_HOTPLUG_CPU is
not enabled.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/percpu_counter.c~lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef
+++ a/lib/percpu_counter.c
@@ -10,8 +10,10 @@
 #include <linux/module.h>
 #include <linux/debugobjects.h>
 
+#ifdef CONFIG_HOTPLUG_CPU
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
+#endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
 
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch

