From: akpm@linux-foundation.org
Subject: + kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:27:09 -0700
Message-ID: <200704091927.l39JR9Qe021308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXDIT1i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, srinivasa@in.ibm.com


The patch titled
     Kprobes: The ON/OFF knob thru debugfs (update 2)
has been added to the -mm tree.  Its filename is
     kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix
+++ a/kernel/kprobes.c
@@ -574,10 +574,7 @@ static int __kprobes __register_kprobe(s
 			register_page_fault_notifier(&kprobe_page_fault_nb);
 
 		arch_arm_kprobe(p);
-	} else
-		printk("Kprobes are globally disabled. This kprobe [@ %p] "
-			"will be enabled with all other probes\n", p->addr);
-
+	}
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -928,6 +925,7 @@ static void __kprobes enable_all_kprobes
 	}
 
 	kprobe_enabled = true;
+	printk("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -948,6 +946,7 @@ static void __kprobes disable_all_kprobe
 		goto already_disabled;
 
 	kprobe_enabled = false;
+	printk("Kprobes globally disabled\n");
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-make-kprobesymbol_name-const.patch
kprobes-fix-sparse-null-warning.patch
kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix.patch
