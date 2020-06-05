From: akpm@linux-foundation.org
Subject: [merged]
 kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:19:49 -0700
Message-ID: <20200605201949.4f76_sAA3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgFEUTu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, davem@davemloft.net, gregkh@linuxfoundation.org, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com


The patch titled
     Subject: kernel/kprobes.c: convert to use DEFINE_SEQ_ATTRIBUTE macro
has been removed from the -mm tree.  Its filename was
     kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kernel/kprobes.c: convert to use DEFINE_SEQ_ATTRIBUTE macro

Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.

Link: http://lkml.kernel.org/r/20200509064031.181091-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

--- a/kernel/kprobes.c~kernel-kprobes-convert-to-use-define_seq_attribute-macro
+++ a/kernel/kprobes.c
@@ -2475,24 +2475,14 @@ static int show_kprobe_addr(struct seq_f
 	return 0;
 }
 
-static const struct seq_operations kprobes_seq_ops = {
+static const struct seq_operations kprobes_sops = {
 	.start = kprobe_seq_start,
 	.next  = kprobe_seq_next,
 	.stop  = kprobe_seq_stop,
 	.show  = show_kprobe_addr
 };
 
-static int kprobes_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &kprobes_seq_ops);
-}
-
-static const struct file_operations debugfs_kprobes_operations = {
-	.open           = kprobes_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(kprobes);
 
 /* kprobes/blacklist -- shows which functions can not be probed */
 static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
@@ -2529,24 +2519,13 @@ static void kprobe_blacklist_seq_stop(st
 	mutex_unlock(&kprobe_mutex);
 }
 
-static const struct seq_operations kprobe_blacklist_seq_ops = {
+static const struct seq_operations kprobe_blacklist_sops = {
 	.start = kprobe_blacklist_seq_start,
 	.next  = kprobe_blacklist_seq_next,
 	.stop  = kprobe_blacklist_seq_stop,
 	.show  = kprobe_blacklist_seq_show,
 };
-
-static int kprobe_blacklist_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &kprobe_blacklist_seq_ops);
-}
-
-static const struct file_operations debugfs_kprobe_blacklist_ops = {
-	.open           = kprobe_blacklist_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(kprobe_blacklist);
 
 static int arm_all_kprobes(void)
 {
@@ -2705,13 +2684,12 @@ static int __init debugfs_kprobe_init(vo
 
 	dir = debugfs_create_dir("kprobes", NULL);
 
-	debugfs_create_file("list", 0400, dir, NULL,
-			    &debugfs_kprobes_operations);
+	debugfs_create_file("list", 0400, dir, NULL, &kprobes_fops);
 
 	debugfs_create_file("enabled", 0600, dir, &value, &fops_kp);
 
 	debugfs_create_file("blacklist", 0400, dir, NULL,
-			    &debugfs_kprobe_blacklist_ops);
+			    &kprobe_blacklist_fops);
 
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are
