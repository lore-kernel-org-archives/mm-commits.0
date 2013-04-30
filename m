From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-warnings.patch added to -mm tree
Date: Tue, 30 Apr 2013 12:29:36 -0700
Message-ID: <20130430192936.6FD3331C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48791 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496Ab3D3T3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:29:37 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so90957ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:29:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vincent.stehle@laposte.net, rientjes@google.com


The patch titled
     Subject: memory hotplug: fix warnings
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memory-hotplug-fix-warnings.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
