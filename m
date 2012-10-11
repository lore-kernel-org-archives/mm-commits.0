From: akpm@linux-foundation.org
Subject: + mm-memcg-make-mem_cgroup_out_of_memory-static.patch added to -mm tree
Date: Thu, 11 Oct 2012 14:23:17 -0700
Message-ID: <20121011212318.152CC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51582 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2JKVXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 17:23:20 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so142193eek.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 14:23:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     Subject: mm, memcg: make mem_cgroup_out_of_memory() static
has been added to the -mm tree.  Its filename is
     mm-memcg-make-mem_cgroup_out_of_memory-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: make mem_cgroup_out_of_memory() static

mem_cgroup_out_of_memory() is only referenced from within file scope, so
it can be marked static.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 --
 mm/memcontrol.c     |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~mm-memcg-make-mem_cgroup_out_of_memory-static include/linux/oom.h
--- a/include/linux/oom.h~mm-memcg-make-mem_cgroup_out_of_memory-static
+++ a/include/linux/oom.h
@@ -56,8 +56,6 @@ extern void check_panic_on_oom(enum oom_
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
-extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order);
 
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
diff -puN mm/memcontrol.c~mm-memcg-make-mem_cgroup_out_of_memory-static mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-make-mem_cgroup_out_of_memory-static
+++ a/mm/memcontrol.c
@@ -1465,8 +1465,8 @@ static u64 mem_cgroup_get_limit(struct m
 	return min(limit, memsw);
 }
 
-void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			      int order)
+static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				     int order)
 {
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
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
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch

