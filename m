From: akpm@linux-foundation.org
Subject: - pm_qos-spelling-fixes.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:14 -0700
Message-ID: <200808062057.m76KvEHM014752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759023AbYHFU5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@hughsie.com, mgross@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     pm_qos: spelling fixes
has been removed from the -mm tree.  Its filename was
     pm_qos-spelling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm_qos: spelling fixes
From: Richard Hughes <richard@hughsie.com>

A documentation cleanup patch.  With a minor tweak to clarify units for
kbs.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: mark gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/pm_qos_interface.txt |    7 ++++++-
 include/linux/pm_qos_params.h            |    2 +-
 kernel/pm_qos_params.c                   |   16 ++++++++--------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff -puN Documentation/power/pm_qos_interface.txt~pm_qos-spelling-fixes Documentation/power/pm_qos_interface.txt
--- a/Documentation/power/pm_qos_interface.txt~pm_qos-spelling-fixes
+++ a/Documentation/power/pm_qos_interface.txt
@@ -1,4 +1,4 @@
-PM quality of Service interface.
+PM Quality Of Service Interface.
 
 This interface provides a kernel and user mode interface for registering
 performance expectations by drivers, subsystems and user space applications on
@@ -7,6 +7,11 @@ one of the parameters.
 Currently we have {cpu_dma_latency, network_latency, network_throughput} as the
 initial set of pm_qos parameters.
 
+Each parameters have defined units:
+ * latency: usec
+ * timeout: usec
+ * throughput: kbs (kilo bit / sec)
+
 The infrastructure exposes multiple misc device nodes one per implemented
 parameter.  The set of parameters implement is defined by pm_qos_power_init()
 and pm_qos_params.h.  This is done because having the available parameters
diff -puN include/linux/pm_qos_params.h~pm_qos-spelling-fixes include/linux/pm_qos_params.h
--- a/include/linux/pm_qos_params.h~pm_qos-spelling-fixes
+++ a/include/linux/pm_qos_params.h
@@ -1,6 +1,6 @@
 /* interface for the pm_qos_power infrastructure of the linux kernel.
  *
- * Mark Gross
+ * Mark Gross <mgross@linux.intel.com>
  */
 #include <linux/list.h>
 #include <linux/notifier.h>
diff -puN kernel/pm_qos_params.c~pm_qos-spelling-fixes kernel/pm_qos_params.c
--- a/kernel/pm_qos_params.c~pm_qos-spelling-fixes
+++ a/kernel/pm_qos_params.c
@@ -24,7 +24,7 @@
  * requirement that the application has is cleaned up when closes the file
  * pointer or exits the pm_qos_object will get an opportunity to clean up.
  *
- * mark gross mgross@linux.intel.com
+ * Mark Gross <mgross@linux.intel.com>
  */
 
 #include <linux/pm_qos_params.h>
@@ -211,8 +211,8 @@ EXPORT_SYMBOL_GPL(pm_qos_requirement);
  * @value: defines the qos request
  *
  * This function inserts a new entry in the pm_qos_class list of requested qos
- * performance charactoistics.  It recomputes the agregate QoS expectations for
- * the pm_qos_class of parrameters.
+ * performance characteristics.  It recomputes the aggregate QoS expectations
+ * for the pm_qos_class of parameters.
  */
 int pm_qos_add_requirement(int pm_qos_class, char *name, s32 value)
 {
@@ -250,10 +250,10 @@ EXPORT_SYMBOL_GPL(pm_qos_add_requirement
  * @name: identifies the request
  * @value: defines the qos request
  *
- * Updates an existing qos requierement for the pm_qos_class of parameters along
+ * Updates an existing qos requirement for the pm_qos_class of parameters along
  * with updating the target pm_qos_class value.
  *
- * If the named request isn't in the lest then no change is made.
+ * If the named request isn't in the list then no change is made.
  */
 int pm_qos_update_requirement(int pm_qos_class, char *name, s32 new_value)
 {
@@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(pm_qos_update_requirem
  * @pm_qos_class: identifies which list of qos request to us
  * @name: identifies the request
  *
- * Will remove named qos request from pm_qos_class list of parrameters and
+ * Will remove named qos request from pm_qos_class list of parameters and
  * recompute the current target value for the pm_qos_class.
  */
 void pm_qos_remove_requirement(int pm_qos_class, char *name)
@@ -319,7 +319,7 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirem
  * @notifier: notifier block managed by caller.
  *
  * will register the notifier into a notification chain that gets called
- * uppon changes to the pm_qos_class target value.
+ * upon changes to the pm_qos_class target value.
  */
  int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
@@ -338,7 +338,7 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
  * @notifier: notifier block to be removed.
  *
  * will remove the notifier from the notification chain that gets called
- * uppon changes to the pm_qos_class target value.
+ * upon changes to the pm_qos_class target value.
  */
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
_

Patches currently in -mm which might be from richard@hughsie.com are


