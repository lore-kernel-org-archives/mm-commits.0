From: akpm@linux-foundation.org
Subject: - kprobes-support-probing-module-__init-function.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:13 -0800
Message-ID: <200901072218.n07MIDv6017760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762169AbZAGWTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: support probing module __init function
has been removed from the -mm tree.  Its filename was
     kprobes-support-probing-module-__init-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: support probing module __init function
From: Masami Hiramatsu <mhiramat@redhat.com>

Allow kprobes to probe module __init routines.  When __init functions are
freed, kprobes which probe those functions are set to "Gone" flag.  These
"Gone" probes are disarmed from the code and never be enabled.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN kernel/kprobes.c~kprobes-support-probing-module-__init-function kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-support-probing-module-__init-function
+++ a/kernel/kprobes.c
@@ -677,6 +677,16 @@ int __kprobes register_kprobe(struct kpr
 			preempt_enable();
 			return -EINVAL;
 		}
+		/*
+		 * If the module freed .init.text, we couldn't insert
+		 * kprobes in there.
+		 */
+		if (within_module_init((unsigned long)p->addr, probed_mod) &&
+		    probed_mod->state != MODULE_STATE_COMING) {
+			module_put(probed_mod);
+			preempt_enable();
+			return -EINVAL;
+		}
 	}
 	preempt_enable();
 
@@ -1073,19 +1083,24 @@ static int __kprobes kprobes_module_call
 	struct hlist_node *node;
 	struct kprobe *p;
 	unsigned int i;
+	int checkcore = (val == MODULE_STATE_GOING);
 
-	if (val != MODULE_STATE_GOING)
+	if (val != MODULE_STATE_GOING && val != MODULE_STATE_LIVE)
 		return NOTIFY_DONE;
 
 	/*
-	 * module .text section will be freed. We need to
-	 * disable kprobes which have been inserted in the section.
+	 * When MODULE_STATE_GOING was notified, both of module .text and
+	 * .init.text sections would be freed. When MODULE_STATE_LIVE was
+	 * notified, only .init.text section would be freed. We need to
+	 * disable kprobes which have been inserted in the sections.
 	 */
 	mutex_lock(&kprobe_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
-			if (within_module_core((unsigned long)p->addr, mod)) {
+			if (within_module_init((unsigned long)p->addr, mod) ||
+			    (checkcore &&
+			     within_module_core((unsigned long)p->addr, mod))) {
 				/*
 				 * The vaddr this probe is installed will soon
 				 * be vfreed buy not synced to disk. Hence,
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

