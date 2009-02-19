From: akpm@linux-foundation.org
Subject: [merged] cpuhotplug-remove-cpu_hotplug_init.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:18:02 -0800
Message-ID: <200902191918.n1JJI2Qo016443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbZBSTS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, ego@in.ibm.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpuhotplug: remove cpu_hotplug_init()
has been removed from the -mm tree.  Its filename was
     cpuhotplug-remove-cpu_hotplug_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuhotplug: remove cpu_hotplug_init()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

We can do all this at compile time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    5 -----
 init/main.c         |    1 -
 kernel/cpu.c        |   11 +++--------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff -puN include/linux/cpu.h~cpuhotplug-remove-cpu_hotplug_init include/linux/cpu.h
--- a/include/linux/cpu.h~cpuhotplug-remove-cpu_hotplug_init
+++ a/include/linux/cpu.h
@@ -69,7 +69,6 @@ static inline void unregister_cpu_notifi
 
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
-extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
@@ -84,10 +83,6 @@ static inline void unregister_cpu_notifi
 {
 }
 
-static inline void cpu_hotplug_init(void)
-{
-}
-
 static inline void cpu_maps_update_begin(void)
 {
 }
diff -puN init/main.c~cpuhotplug-remove-cpu_hotplug_init init/main.c
--- a/init/main.c~cpuhotplug-remove-cpu_hotplug_init
+++ a/init/main.c
@@ -650,7 +650,6 @@ asmlinkage void __init start_kernel(void
 	page_cgroup_init();
 	mem_init();
 	enable_debug_pagealloc();
-	cpu_hotplug_init();
 	kmem_cache_init();
 	kmemtrace_init();
 	kmemleak_init();
diff -puN kernel/cpu.c~cpuhotplug-remove-cpu_hotplug_init kernel/cpu.c
--- a/kernel/cpu.c~cpuhotplug-remove-cpu_hotplug_init
+++ a/kernel/cpu.c
@@ -34,14 +34,9 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
-} cpu_hotplug;
