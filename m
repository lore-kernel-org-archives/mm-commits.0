From: akpm@linux-foundation.org
Subject: - kprobes-fix-a-null-pointer-bug-in-register_kretprobe.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:54 -0800
Message-ID: <200803050746.m257ksZB021804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764377AbYCEHsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: fix a null pointer bug in register_kretprobe()
has been removed from the -mm tree.  Its filename was
     kprobes-fix-a-null-pointer-bug-in-register_kretprobe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: fix a null pointer bug in register_kretprobe()
From: Masami Hiramatsu <mhiramat@redhat.com>

Fix a bug in regiseter_kretprobe() which does not check rp->kp.symbol_name ==
NULL before calling kprobe_lookup_name.

For maintainability, this introduces kprobe_addr helper function which
resolves addr field.  It is used by register_kprobe and register_kretprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN kernel/kprobes.c~kprobes-fix-a-null-pointer-bug-in-register_kretprobe kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-fix-a-null-pointer-bug-in-register_kretprobe
+++ a/kernel/kprobes.c
@@ -498,27 +498,36 @@ static int __kprobes in_kprobes_function
 	return 0;
 }
 
+/*
+ * If we have a symbol_name argument, look it up and add the offset field
+ * to it. This way, we can specify a relative address to a symbol.
+ */
+static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
+{
+	kprobe_opcode_t *addr = p->addr;
+	if (p->symbol_name) {
+		if (addr)
+			return NULL;
+		kprobe_lookup_name(p->symbol_name, addr);
+	}
+
+	if (!addr)
+		return NULL;
+	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
+}
+
 static int __kprobes __register_kprobe(struct kprobe *p,
 	unsigned long called_from)
 {
 	int ret = 0;
 	struct kprobe *old_p;
 	struct module *probed_mod;
+	kprobe_opcode_t *addr;
 
-	/*
-	 * If we have a symbol_name argument look it up,
-	 * and add it to the address.  That way the addr
-	 * field can either be global or relative to a symbol.
-	 */
-	if (p->symbol_name) {
-		if (p->addr)
-			return -EINVAL;
-		kprobe_lookup_name(p->symbol_name, p->addr);
-	}
-
-	if (!p->addr)
+	addr = kprobe_addr(p);
+	if (!addr)
 		return -EINVAL;
-	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
+	p->addr = addr;
 
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr))
@@ -721,12 +730,12 @@ int __kprobes register_kretprobe(struct 
 	int ret = 0;
 	struct kretprobe_instance *inst;
 	int i;
-	void *addr = rp->kp.addr;
+	void *addr;
 
 	if (kretprobe_blacklist_size) {
-		if (addr == NULL)
-			kprobe_lookup_name(rp->kp.symbol_name, addr);
-		addr += rp->kp.offset;
+		addr = kprobe_addr(&rp->kp);
+		if (!addr)
+			return -EINVAL;
 
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
 			if (kretprobe_blacklist[i].addr == addr)
_

Patches currently in -mm which might be from mhiramat@redhat.com are


