From: akpm@linux-foundation.org
Subject: [merged] kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:22 -0700
Message-ID: <200904071907.n37J7MSR011276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759549AbZDGTt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     kprobes: rename kprobe_enabled to kprobes_all_disarmed
has been removed from the -mm tree.  Its filename was
     kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: rename kprobe_enabled to kprobes_all_disarmed
From: Masami Hiramatsu <mhiramat@redhat.com>

Rename kprobe_enabled to kprobes_all_disarmed and invert logic due to
avoiding naming confusion from per-probe disabling.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN kernel/kprobes.c~kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed
+++ a/kernel/kprobes.c
@@ -68,7 +68,7 @@ static struct hlist_head kprobe_table[KP
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
 /* NOTE: change this value only with kprobe_mutex held */
-static bool kprobe_enabled;
+static bool kprobes_all_disarmed;
 
 static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
@@ -598,7 +598,7 @@ static int __kprobes register_aggr_kprob
 		 * If the old_p has gone, its breakpoint has been disarmed.
 		 * We have to arm it again after preparing real kprobes.
 		 */
-		if (kprobe_enabled)
+		if (!kprobes_all_disarmed)
 			arch_arm_kprobe(ap);
 	}
 
@@ -709,7 +709,7 @@ int __kprobes register_kprobe(struct kpr
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (kprobe_enabled)
+	if (!kprobes_all_disarmed)
 		arch_arm_kprobe(p);
 
 out_unlock_text:
@@ -751,7 +751,7 @@ valid_p:
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled && !kprobe_gone(old_p)) {
+		if (!kprobes_all_disarmed && !kprobe_gone(old_p)) {
 			mutex_lock(&text_mutex);
 			arch_disarm_kprobe(p);
 			mutex_unlock(&text_mutex);
@@ -1190,8 +1190,8 @@ static int __init init_kprobes(void)
 		}
 	}
 
-	/* By default, kprobes are enabled */
-	kprobe_enabled = true;
+	/* By default, kprobes are armed */
+	kprobes_all_disarmed = false;
 
 	err = arch_init_kprobes();
 	if (!err)
@@ -1289,7 +1289,7 @@ static struct file_operations debugfs_kp
 	.release        = seq_release,
 };
 
-static void __kprobes enable_all_kprobes(void)
+static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -1298,8 +1298,8 @@ static void __kprobes enable_all_kprobes
 
 	mutex_lock(&kprobe_mutex);
 
-	/* If kprobes are already enabled, just return */
-	if (kprobe_enabled)
+	/* If kprobes are armed, just return */
+	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
 	mutex_lock(&text_mutex);
@@ -1311,7 +1311,7 @@ static void __kprobes enable_all_kprobes
 	}
 	mutex_unlock(&text_mutex);
 
-	kprobe_enabled = true;
+	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
 
 already_enabled:
@@ -1319,7 +1319,7 @@ already_enabled:
 	return;
 }
 
-static void __kprobes disable_all_kprobes(void)
+static void __kprobes disarm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -1328,11 +1328,11 @@ static void __kprobes disable_all_kprobe
 
 	mutex_lock(&kprobe_mutex);
 
-	/* If kprobes are already disabled, just return */
-	if (!kprobe_enabled)
+	/* If kprobes are already disarmed, just return */
+	if (kprobes_all_disarmed)
 		goto already_disabled;
 
-	kprobe_enabled = false;
+	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
 	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
@@ -1364,7 +1364,7 @@ static ssize_t read_enabled_file_bool(st
 {
 	char buf[3];
 
-	if (kprobe_enabled)
+	if (!kprobes_all_disarmed)
 		buf[0] = '1';
 	else
 		buf[0] = '0';
@@ -1387,12 +1387,12 @@ static ssize_t write_enabled_file_bool(s
 	case 'y':
 	case 'Y':
 	case '1':
-		enable_all_kprobes();
+		arm_all_kprobes();
 		break;
 	case 'n':
 	case 'N':
 	case '0':
-		disable_all_kprobes();
+		disarm_all_kprobes();
 		break;
 	}
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

