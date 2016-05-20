From: akpm@linux-foundation.org
Subject: [patch 021/117] kernel/padata.c: hide unused functions
Date: Thu, 19 May 2016 17:09:59 -0700
Message-ID: <573e55d7.phX9UV9aJpcqy9CE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbcETAKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, rcochran@linutronix.de, steffen.klassert@secunet.com

From: Arnd Bergmann <arnd@arndb.de>
Subject: kernel/padata.c: hide unused functions

A recent cleanup removed some exported functions that were not used
anywhere, which in turn exposed the fact that some other functions in the
same file are only used in some configurations.

We now get a warning about them when CONFIG_HOTPLUG_CPU is disabled:

kernel/padata.c:670:12: error: '__padata_remove_cpu' defined but not used [-Werror=unused-function]
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
            ^~~~~~~~~~~~~~~~~~~
kernel/padata.c:650:12: error: '__padata_add_cpu' defined but not used [-Werror=unused-function]
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)

This rearranges the code so the __padata_remove_cpu/__padata_add_cpu
functions are within the #ifdef that protects the code that calls them.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 4ba6d78c671e ("kernel/padata.c: removed unused code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <rcochran@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |   74 +++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff -puN kernel/padata.c~kernel-padata-hide-unused-functions kernel/padata.c
--- a/kernel/padata.c~kernel-padata-hide-unused-functions
+++ a/kernel/padata.c
@@ -647,6 +647,43 @@ out:
 }
 EXPORT_SYMBOL(padata_set_cpumask);
 
+/**
+ * padata_start - start the parallel processing
+ *
+ * @pinst: padata instance to start
+ */
+int padata_start(struct padata_instance *pinst)
+{
+	int err = 0;
+
+	mutex_lock(&pinst->lock);
+
+	if (pinst->flags & PADATA_INVALID)
+		err = -EINVAL;
+
+	 __padata_start(pinst);
+
+	mutex_unlock(&pinst->lock);
+
+	return err;
+}
+EXPORT_SYMBOL(padata_start);
+
+/**
+ * padata_stop - stop the parallel processing
+ *
+ * @pinst: padata instance to stop
+ */
+void padata_stop(struct padata_instance *pinst)
+{
+	mutex_lock(&pinst->lock);
+	__padata_stop(pinst);
+	mutex_unlock(&pinst->lock);
+}
+EXPORT_SYMBOL(padata_stop);
+
+#ifdef CONFIG_HOTPLUG_CPU
+
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd;
@@ -726,43 +763,6 @@ int padata_remove_cpu(struct padata_inst
 }
 EXPORT_SYMBOL(padata_remove_cpu);
 
-/**
- * padata_start - start the parallel processing
- *
- * @pinst: padata instance to start
- */
-int padata_start(struct padata_instance *pinst)
-{
-	int err = 0;
-
-	mutex_lock(&pinst->lock);
-
-	if (pinst->flags & PADATA_INVALID)
-		err =-EINVAL;
-
-	 __padata_start(pinst);
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_start);
-
-/**
- * padata_stop - stop the parallel processing
- *
- * @pinst: padata instance to stop
- */
-void padata_stop(struct padata_instance *pinst)
-{
-	mutex_lock(&pinst->lock);
-	__padata_stop(pinst);
-	mutex_unlock(&pinst->lock);
-}
-EXPORT_SYMBOL(padata_stop);
-
-#ifdef CONFIG_HOTPLUG_CPU
