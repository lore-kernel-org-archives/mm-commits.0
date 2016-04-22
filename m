From: akpm@linux-foundation.org
Subject: + kernel-padata-hide-unused-functions.patch added to -mm tree
Date: Fri, 22 Apr 2016 13:16:00 -0700
Message-ID: <571a8680.xxDma78IqdfceV1Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbcDVUQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:16:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, rcochran@linutronix.de, steffen.klassert@secunet.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/padata.c: hide unused functions
has been added to the -mm tree.  Its filename is
     kernel-padata-hide-unused-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-padata-hide-unused-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-padata-hide-unused-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -674,6 +674,43 @@ out:
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
+		err =-EINVAL;
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
@@ -789,43 +826,6 @@ int padata_remove_cpu(struct padata_inst
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
