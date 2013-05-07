From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-warnings.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:09 -0700
Message-ID: <20130507174609.76DF45A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:38677 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3EGRqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:11 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so85031qen.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vincent.stehle@laposte.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: fix warnings
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Vincent Stehl=E9 <vincent.stehle@laposte.net>
Subject: memory hotplug: fix warnings

=46ix the following compilation warnings:

  mm/slab.c: In function `kmem_cache_init_late':
  mm/slab.c:1778:2: warning: statement with no effect [-Wunused-value]

  mm/page_cgroup.c: In function `page_cgroup_init':
  mm/page_cgroup.c:305:2: warning: statement with no effect [-Wunused-v=
alue]

Signed-off-by: Vincent Stehl=E9 <vincent.stehle@laposte.net>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memory.h~memory-hotplug-fix-warnings include/li=
nux/memory.h
--- a/include/linux/memory.h~memory-hotplug-fix-warnings
+++ a/include/linux/memory.h
@@ -137,7 +137,7 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
 #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(=
nb)
 #else
-#define hotplug_memory_notifier(fn, pri)	(0)
+#define hotplug_memory_notifier(fn, pri)	({ 0; })
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
 #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
_

Patches currently in -mm which might be from vincent.stehle@laposte.net=
 are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
