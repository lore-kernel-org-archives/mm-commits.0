From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-initialize-earlier.patch added to -mm tree
Date: Wed, 20 May 2020 16:31:19 -0700
Message-ID: <20200520233119.ChBVu2bfy%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgETXbW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 19:31:22 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, ziy@nvidia.com


The patch titled
     Subject: padata: initialize earlier
has been added to the -mm tree.  Its filename is
     padata-initialize-earlier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/padata-initialize-earlier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/padata-initialize-earlier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: padata: initialize earlier

padata will soon initialize the system's struct pages in parallel, so it
needs to be ready by page_alloc_init_late().

The error return from padata_driver_init() triggers an initcall warning,
so add a warning to padata_init() to avoid silent failure.

Link: http://lkml.kernel.org/r/20200520182645.1658949-3-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Robert Elliott <elliott@hpe.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/padata.h |    6 ++++++
 init/main.c            |    2 ++
 kernel/padata.c        |   17 ++++++++---------
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/include/linux/padata.h~padata-initialize-earlier
+++ a/include/linux/padata.h
@@ -164,6 +164,12 @@ struct padata_instance {
 #define	PADATA_INVALID	4
 };
 
+#ifdef CONFIG_PADATA
+extern void __init padata_init(void);
+#else
+static inline void __init padata_init(void) {}
+#endif
+
 extern struct padata_instance *padata_alloc_possible(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
--- a/init/main.c~padata-initialize-earlier
+++ a/init/main.c
@@ -94,6 +94,7 @@
 #include <linux/rodata_test.h>
 #include <linux/jump_label.h>
 #include <linux/mem_encrypt.h>
+#include <linux/padata.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1482,6 +1483,7 @@ static noinline void __init kernel_init_
 	smp_init();
 	sched_init_smp();
 
+	padata_init();
 	page_alloc_init_late();
 	/* Initialize page ext after all struct pages are initialized. */
 	page_ext_init();
--- a/kernel/padata.c~padata-initialize-earlier
+++ a/kernel/padata.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
 
 #define MAX_OBJ_NUM 1000
 
@@ -1050,26 +1049,26 @@ void padata_free_shell(struct padata_she
 }
 EXPORT_SYMBOL(padata_free_shell);
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static __init int padata_driver_init(void)
+void __init padata_init(void)
 {
+#ifdef CONFIG_HOTPLUG_CPU
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
 				      padata_cpu_online, NULL);
 	if (ret < 0)
-		return ret;
+		goto err;
 	hp_online = ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_PADATA_DEAD, "padata:dead",
 				      NULL, padata_cpu_dead);
 	if (ret < 0) {
 		cpuhp_remove_multi_state(hp_online);
-		return ret;
+		goto err;
 	}
-	return 0;
-}
-module_init(padata_driver_init);
 
+	return;
+err:
+	pr_warn("padata: initialization failed\n");
 #endif
+}
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
padata-remove-exit-routine.patch
padata-initialize-earlier.patch
padata-allocate-work-structures-for-parallel-jobs-from-a-pool.patch
padata-add-basic-support-for-multithreaded-jobs.patch
mm-parallelize-deferred_init_memmap.patch
mm-make-deferred-inits-max-threads-arch-specific.patch
padata-document-multithreaded-jobs.patch
