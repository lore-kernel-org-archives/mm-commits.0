From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch added to -mm
 tree
Date: Mon, 11 May 2020 14:21:51 -0700
Message-ID: <20200511212151.JOwPzF5eZ%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgEKVVx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:21:53 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, davem@davemloft.net, gregkh@linuxfoundation.org, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com


The patch titled
     Subject: kernel/kprobes.c: convert to use DEFINE_SEQ_ATTRIBUTE macro
has been added to the -mm tree.  Its filename is
     kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 kernel/kprobes.c |   33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

--- a/kernel/kprobes.c~kernel-kprobes-convert-to-use-define_seq_attribute-macro
+++ a/kernel/kprobes.c
@@ -2398,24 +2398,14 @@ static int show_kprobe_addr(struct seq_f
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
@@ -2446,24 +2436,14 @@ static int kprobe_blacklist_seq_show(str
 	return 0;
 }
 
-static const struct seq_operations kprobe_blacklist_seq_ops = {
+static const struct seq_operations kprobe_blacklist_sops = {
 	.start = kprobe_blacklist_seq_start,
 	.next  = kprobe_blacklist_seq_next,
 	.stop  = kprobe_seq_stop,	/* Reuse void function */
 	.show  = kprobe_blacklist_seq_show,
 };
 
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
@@ -2622,13 +2602,12 @@ static int __init debugfs_kprobe_init(vo
 
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

seq_file-introduce-define_seq_attribute-helper-macro.patch
mm-vmstat-convert-to-use-define_seq_attribute-macro.patch
kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch
