From: akpm@linux-foundation.org
Subject: + mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:47:50 -0700
Message-ID: <20120815234751.30BE1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61916 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2HOXrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:47:53 -0400
Received: by faem1 with SMTP id m1so10772fae.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:47:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuah.khan@hp.com, cl@linux.com, penberg@kernel.org


The patch titled
     Subject: mm/slab_common.c: restructure kmem_cache_create() to move debug cache integrity checks into a new function
has been added to the -mm tree.  Its filename is
     mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.khan@hp.com>
Subject: mm/slab_common.c: restructure kmem_cache_create() to move debug cache integrity checks into a new function

kmem_cache_create() does cache integrity checks when CONFIG_DEBUG_VM is
defined.  These checks interspersed with the regular code path has lead to
compile time warnings when compiled without CONFIG_DEBUG_VM defined. 
Restructuring the code to move the integrity checks in to a new function
would eliminate the current compile warning problem and also will allow
for future changes to the debug only code to evolve without introducing
new warnings in the regular path.  This restructuring work is based on the
discussion in the following thread:

https://lkml.org/lkml/2012/7/13/424

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   90 ++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff -puN mm/slab_common.c~mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function
+++ a/mm/slab_common.c
@@ -23,6 +23,52 @@ enum slab_state slab_state;
 LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 
+#ifdef CONFIG_DEBUG_VM
+static int kmem_cache_sanity_check(const char *name, size_t size)
+{
+	struct kmem_cache *s = NULL;
+
+	if (!name || in_interrupt() || size < sizeof(void *) ||
+		size > KMALLOC_MAX_SIZE) {
+		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
+		return -EINVAL;
+	}
+
+	list_for_each_entry(s, &slab_caches, list) {
+		char tmp;
+		int res;
+
+		/*
+		 * This happens when the module gets unloaded and doesn't
+		 * destroy its slab cache and no-one else reuses the vmalloc
+		 * area of the module.  Print a warning.
+		 */
+		res = probe_kernel_address(s->name, tmp);
+		if (res) {
+			pr_err("Slab cache with size %d has lost its name\n",
+			       s->object_size);
+			continue;
+		}
+
+		if (!strcmp(s->name, name)) {
+			pr_err("%s (%s): Cache name already exists.\n",
+			       __func__, name);
+			dump_stack();
+			s = NULL;
+			return -EINVAL;
+		}
+	}
+
+	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
+	return 0;
+}
+#else
+static inline int kmem_cache_sanity_check(const char *name, size_t size)
+{
+	return 0;
+}
+#endif
+
 /*
  * kmem_cache_create - Create a cache.
  * @name: A string which is used in /proc/slabinfo to identify this cache.
@@ -53,48 +99,11 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *s = NULL;
 
-#ifdef CONFIG_DEBUG_VM
-	if (!name || in_interrupt() || size < sizeof(void *) ||
-		size > KMALLOC_MAX_SIZE) {
-		printk(KERN_ERR "kmem_cache_create(%s) integrity check"
-			" failed\n", name);
-		goto out;
-	}
-#endif
-
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 
-#ifdef CONFIG_DEBUG_VM
-	list_for_each_entry(s, &slab_caches, list) {
-		char tmp;
-		int res;
-
-		/*
-		 * This happens when the module gets unloaded and doesn't
-		 * destroy its slab cache and no-one else reuses the vmalloc
-		 * area of the module.  Print a warning.
-		 */
-		res = probe_kernel_address(s->name, tmp);
-		if (res) {
-			printk(KERN_ERR
-			       "Slab cache with size %d has lost its name\n",
-			       s->object_size);
-			continue;
-		}
-
-		if (!strcmp(s->name, name)) {
-			printk(KERN_ERR "kmem_cache_create(%s): Cache name"
-				" already exists.\n",
-				name);
-			dump_stack();
-			s = NULL;
-			goto oops;
-		}
-	}
