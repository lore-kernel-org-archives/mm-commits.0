From: akpm@linux-foundation.org
Subject: - kprobes-prevent-probing-of-preempt_schedule.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:08 -0700
Message-ID: <200804282156.m3SLu8kB018189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936751AbYD1V41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivasa@in.ibm.com, ananth@in.ibm.com, haveblue@us.ibm.com, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: prevent probing of preempt_schedule()
has been removed from the -mm tree.  Its filename was
     kprobes-prevent-probing-of-preempt_schedule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: prevent probing of preempt_schedule()
From: Srinivasa Ds <srinivasa@in.ibm.com>

Prohibit users from probing preempt_schedule().  One way of prohibiting the
user from probing functions is by marking such functions with __kprobes.  But
this method doesn't work for those functions, which are already marked to
different section like preempt_schedule() (belongs to __sched section).  So we
use blacklist approach to refuse user from probing these functions.

In blacklist approach we populate the blacklisted function's starting address
and its size in kprobe_blacklist structure.  Then we verify the user specified
address against start and end of the blacklisted function.  So any attempt to
register probe on blacklisted functions will be rejected.

[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    7 +++++
 kernel/kprobes.c        |   52 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff -puN include/linux/kprobes.h~kprobes-prevent-probing-of-preempt_schedule include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-prevent-probing-of-preempt_schedule
+++ a/include/linux/kprobes.h
@@ -173,6 +173,13 @@ struct kretprobe_blackpoint {
 	const char *name;
 	void *addr;
 };
+
+struct kprobe_blackpoint {
+	const char *name;
+	unsigned long start_addr;
+	unsigned long range;
+};
+
 extern struct kretprobe_blackpoint kretprobe_blacklist[];
 
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
diff -puN kernel/kprobes.c~kprobes-prevent-probing-of-preempt_schedule kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-prevent-probing-of-preempt_schedule
+++ a/kernel/kprobes.c
@@ -72,6 +72,18 @@ DEFINE_MUTEX(kprobe_mutex);		/* Protects
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 
+/*
+ * Normally, functions that we'd want to prohibit kprobes in, are marked
+ * __kprobes. But, there are cases where such functions already belong to
+ * a different section (__sched for preempt_schedule)
+ *
+ * For such cases, we now have a blacklist
+ */
+struct kprobe_blackpoint kprobe_blacklist[] = {
+	{"preempt_schedule",},
+	{NULL}    /* Terminator */
+};
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -492,9 +504,22 @@ static int __kprobes register_aggr_kprob
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
+	struct kprobe_blackpoint *kb;
+
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
+	/*
+	 * If there exists a kprobe_blacklist, verify and
+	 * fail any probe registration in the prohibited area
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		if (kb->start_addr) {
+			if (addr >= kb->start_addr &&
+			    addr < (kb->start_addr + kb->range))
+				return -EINVAL;
+		}
+	}
 	return 0;
 }
 
@@ -811,6 +836,11 @@ void __kprobes unregister_kretprobe(stru
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
+	unsigned long offset = 0, size = 0;
+	char *modname, namebuf[128];
+	const char *symbol_name;
+	void *addr;
+	struct kprobe_blackpoint *kb;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -819,6 +849,28 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}
 
+	/*
+	 * Lookup and populate the kprobe_blacklist.
+	 *
+	 * Unlike the kretprobe blacklist, we'll need to determine
+	 * the range of addresses that belong to the said functions,
+	 * since a kprobe need not necessarily be at the beginning
+	 * of a function.
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		kprobe_lookup_name(kb->name, addr);
+		if (!addr)
+			continue;
+
+		kb->start_addr = (unsigned long)addr;
+		symbol_name = kallsyms_lookup(kb->start_addr,
+				&size, &offset, &modname, namebuf);
+		if (!symbol_name)
+			kb->range = 0;
+		else
+			kb->range = size;
+	}
+
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

origin.patch

