From: akpm@linux-foundation.org
Subject: + kprobes-support-probing-module-__init-function.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:29:00 -0800
Message-ID: <200811140029.mAE0T0Bw021537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYKNAfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:35:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com


The patch titled
     kprobes: support probing module __init function
has been added to the -mm tree.  Its filename is
     kprobes-support-probing-module-__init-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -674,6 +674,16 @@ int __kprobes register_kprobe(struct kpr
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
 
@@ -1070,19 +1080,24 @@ static int __kprobes kprobes_module_call
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
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

