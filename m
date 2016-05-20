From: akpm@linux-foundation.org
Subject: [merged] kernel-padata-hide-unused-functions.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:03:13 -0700
Message-ID: <573f7b91.PQN5TJD2G4tLRnWD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcETVDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, rcochran@linutronix.de, steffen.klassert@secunet.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/padata.c: hide unused functions
has been removed from the -mm tree.  Its filename was
     kernel-padata-hide-unused-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
