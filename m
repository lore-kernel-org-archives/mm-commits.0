From: akpm@linux-foundation.org
Subject: - kprobes-list-all-active-probes-in-the-system-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:22:10 -0800
Message-ID: <200702120722.l1C7MATw024689@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881AbXBLHW0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:22:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, srinivasa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes-list-all-active-probes-in-the-system-tidy
has been removed from the -mm tree.  Its filename was
     kprobes-list-all-active-probes-in-the-system-tidy.patch

This patch was dropped because it was folded into kprobes-list-all-active-probes-in-the-system.patch

------------------------------------------------------
Subject: kprobes-list-all-active-probes-in-the-system-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Srinivasa DS <srinivasa@in.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system-tidy kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system-tidy
+++ a/kernel/kprobes.c
@@ -836,12 +836,12 @@ static void __kprobes report_probe(struc
 		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
 }
 
-void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
 {
 	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
 }
 
-void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
 	if (*pos >= KPROBE_TABLE_SIZE)
@@ -849,12 +849,12 @@ void __kprobes *kprobe_seq_next(struct s
 	return pos;
 }
 
-void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+static void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
 {
 	/* Nothing to do */
 }
 
-int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -879,7 +879,7 @@ int __kprobes show_kprobe_addr(struct se
 	return 0;
 }
 
-struct seq_operations kprobes_seq_ops = {
+static struct seq_operations kprobes_seq_ops = {
 	.start = kprobe_seq_start,
 	.next  = kprobe_seq_next,
 	.stop  = kprobe_seq_stop,
@@ -916,10 +916,10 @@ static int __kprobes debugfs_kprobe_init
 	return 0;
 }
 
-module_init(debugfs_kprobe_init);
+late_initcall(debugfs_kprobe_init);
 #endif /* CONFIG_DEBUG_FS */
 
-__initcall(init_kprobes);
+module_init(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
@@ -928,4 +928,3 @@ EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(jprobe_return);
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
add-vm_insert_pfn.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
deprecate-sa_interrupt-and-friends.patch
