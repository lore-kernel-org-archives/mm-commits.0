From: akpm@linux-foundation.org
Subject: - pm-qos-remove-locks-around-blocking-notifier.patch removed from -mm tree
Date: Sun, 03 Feb 2008 20:02:39 -0800
Message-ID: <200802040402.m1442KHm012954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512AbYBDEEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:04:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, abelay@novell.com, arjan@infradead.org, lenb@kernel.org, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pm-qos-remove-locks-around-blocking-notifier
has been removed from the -mm tree.  Its filename was
     pm-qos-remove-locks-around-blocking-notifier.patch

This patch was dropped because it was folded into pm-qos-infrastructure-and-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-qos-remove-locks-around-blocking-notifier
From: mark gross <mgross@linux.intel.com>

Remove spin locking around all blocking notifier calls that can sleep.
I had to re-structure some of the code to avoid locking issues.

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pm_qos_params.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN kernel/pm_qos_params.c~pm-qos-remove-locks-around-blocking-notifier kernel/pm_qos_params.c
--- a/kernel/pm_qos_params.c~pm-qos-remove-locks-around-blocking-notifier
+++ a/kernel/pm_qos_params.c
@@ -135,13 +135,14 @@ static s32 min_compare(s32 v1, s32 v2)
 }
 
 
-
-/* assumes pm_qos_lock is held */
 static void update_target(int target)
 {
 	s32 extreme_value;
 	struct requirement_list *node;
+	unsigned long flags;
+	int call_notifier = 0;
 
+	spin_lock_irqsave(&pm_qos_lock, flags);
 	extreme_value = pm_qos_array[target]->default_value;
 	list_for_each_entry(node,
 			&pm_qos_array[target]->requirements.list, list) {
@@ -149,13 +150,16 @@ static void update_target(int target)
 				extreme_value, node->value);
 	}
 	if (pm_qos_array[target]->target_value != extreme_value) {
+		call_notifier = 1;
 		pm_qos_array[target]->target_value = extreme_value;
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
 			pm_qos_array[target]->target_value);
-		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
-			(unsigned long) pm_qos_array[target]->target_value,
-						NULL);
 	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	if (call_notifier)
+		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
+			(unsigned long) extreme_value, NULL);
 }
 
 static int register_pm_qos_misc(struct pm_qos_object *qos)
@@ -227,8 +231,8 @@ int pm_qos_add_requirement(int pm_qos_cl
 		spin_lock_irqsave(&pm_qos_lock, flags);
 		list_add(&dep->list,
 			&pm_qos_array[pm_qos_class]->requirements.list);
-		update_target(pm_qos_class);
 		spin_unlock_irqrestore(&pm_qos_lock, flags);
+		update_target(pm_qos_class);
 
 		return 0;
 	}
@@ -269,11 +273,10 @@ int pm_qos_update_requirement(int pm_qos
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
 		update_target(pm_qos_class);
 
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pm_qos_update_requirement);
@@ -303,9 +306,9 @@ void pm_qos_remove_requirement(int pm_qo
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
 		update_target(pm_qos_class);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
 
@@ -319,13 +322,10 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_requirem
  */
  int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
-	unsigned long flags;
 	int retval;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
 	retval = blocking_notifier_chain_register(
 			pm_qos_array[pm_qos_class]->notifiers, notifier);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
 }
@@ -341,13 +341,10 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
  */
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
-	unsigned long flags;
 	int retval;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
 	retval = blocking_notifier_chain_unregister(
 			pm_qos_array[pm_qos_class]->notifiers, notifier);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
 }
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-remove-locks-around-blocking-notifier.patch
latencyc-use-qos-infrastructure.patch
intel-iommu-pmen-support.patch
intel-iommu-pmen-support-fix.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
