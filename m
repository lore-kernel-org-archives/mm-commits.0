From: akpm@linux-foundation.org
Subject: + lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:01:49 -0700
Message-ID: <201109062201.p86M1nlf004743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab1IFWBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com


The patch titled
     lib/percpu_counter.c: enclose hotplug only variables in hotplug ifdef
has been added to the -mm tree.  Its filename is
     lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/percpu_counter.c: enclose hotplug only variables in hotplug ifdef
From: Glauber Costa <glommer@parallels.com>

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

lib-percpu_counterc-enclose-hotplug-only-variables-in-hotplug-ifdef.patch

