From: akpm@linux-foundation.org
Subject: + cpuhotplug-remove-cpu_hotplug_init.patch added to -mm tree
Date: Wed, 18 Feb 2009 15:44:54 -0800
Message-ID: <200902182344.n1INistx029828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbZBRXpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 18:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, ego@in.ibm.com, rusty@rustcorp.com.au


The patch titled
     cpuhotplug: remove cpu_hotplug_init()
has been added to the -mm tree.  Its filename is
     cpuhotplug-remove-cpu_hotplug_init.patch

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
