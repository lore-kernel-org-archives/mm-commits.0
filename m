From: akpm@linux-foundation.org
Subject: - kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:24:35 -0700
Message-ID: <200704302024.l3UKOZJ9014150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946772AbXD3UYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, srinivasa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: The ON/OFF knob thru debugfs (update 2)
has been removed from the -mm tree.  Its filename was
     kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch

This patch was dropped because it was folded into kprobes-the-on-off-knob-thru-debugfs-updated.patch

------------------------------------------------------
Subject: Kprobes: The ON/OFF knob thru debugfs (update 2)
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

o Remove verbose printk during registration with kprobes globally
  disabled
o Print out a message when kprobes are enabled/disabled globally

Signed-off-by: Ananth N Mavinakyanahalli <ananth@in.ibm.com>
Cc: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix
+++ a/kernel/kprobes.c
@@ -575,10 +575,7 @@ static int __kprobes __register_kprobe(s
 			register_page_fault_notifier(&kprobe_page_fault_nb);
 
 		arch_arm_kprobe(p);
-	} else
-		printk("Kprobes are globally disabled. This kprobe [@ %p] "
-			"will be enabled with all other probes\n", p->addr);
-
+	}
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -929,6 +926,7 @@ static void __kprobes enable_all_kprobes
 	}
 
 	kprobe_enabled = true;
+	printk("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -949,6 +947,7 @@ static void __kprobes disable_all_kprobe
 		goto already_disabled;
 
 	kprobe_enabled = false;
+	printk("Kprobes globally disabled\n");
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
_

Patches currently in -mm which might be from ananth@in.ibm.com are

git-powerpc.patch
kprobes-make-kprobesymbol_name-const.patch
kprobes-fix-sparse-null-warning.patch
kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
