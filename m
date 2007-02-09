From: akpm@linux-foundation.org
Subject: + kprobes-list-all-active-probes-in-the-system-tidy.patch added to -mm tree
Date: Fri, 09 Feb 2007 00:11:15 -0800
Message-ID: <200702090811.l198BFBS008022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946203AbXBIILZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 03:11:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, srinivasa@in.ibm.com


The patch titled
     kprobes-list-all-active-probes-in-the-system-tidy
has been added to the -mm tree.  Its filename is
     kprobes-list-all-active-probes-in-the-system-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-bay-driver-warning-fix.patch
git-cifs-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-infiniband.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-backlight-acpi-fix.patch
git-backlight-asus-fix.patch
git-backlight-sony-fix.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
deprecate-sa_interrupt-and-friends.patch
git-gccbug-fixup.patch
