From: akpm@linux-foundation.org
Subject: [merged] memcg-kmem-fix-build-error-when-config_inet-is-disabled.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:22 -0700
Message-ID: <20121011205922.B57B9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54259 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab2JKU7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:24 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so270416qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, fengguang.wu@intel.com, glommer@parallels.com, mhocko@suse.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, kmem: fix build error when CONFIG_INET is disabled
has been removed from the -mm tree.  Its filename was
     memcg-kmem-fix-build-error-when-config_inet-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: memcg, kmem: fix build error when CONFIG_INET is disabled

Commit e1aab161e013 ("socket: initial cgroup code.") causes a build error
when CONFIG_INET is disabled in Linus' tree:

net/built-in.o: In function `sk_update_clone':
net/core/sock.c:1336: undefined reference to `sock_update_memcg'

sock_update_memcg() is only defined when CONFIG_INET is enabled, so fix it
by defining the dummy function without this option.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-kmem-fix-build-error-when-config_inet-is-disabled include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-kmem-fix-build-error-when-config_inet-is-disabled
+++ a/include/linux/memcontrol.h
@@ -396,7 +396,7 @@ enum {
 };
 
 struct sock;
-#ifdef CONFIG_MEMCG_KMEM
+#if defined(CONFIG_INET) && defined(CONFIG_MEMCG_KMEM)
 void sock_update_memcg(struct sock *sk);
 void sock_release_memcg(struct sock *sk);
 #else
@@ -406,6 +406,6 @@ static inline void sock_update_memcg(str
 static inline void sock_release_memcg(struct sock *sk)
 {
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_INET && CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-slab-release-slab_mutex-earlier-in-kmem_cache_destroy.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

