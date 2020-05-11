From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmstat-convert-to-use-define_seq_attribute-macro.patch added to -mm tree
Date: Mon, 11 May 2020 14:21:48 -0700
Message-ID: <20200511212148.MwcCgEo_V%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgEKVVv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:21:51 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, davem@davemloft.net, gregkh@linuxfoundation.org, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com


The patch titled
     Subject: mm/vmstat.c: convert to use DEFINE_SEQ_ATTRIBUTE macro
has been added to the -mm tree.  Its filename is
     mm-vmstat-convert-to-use-define_seq_attribute-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-convert-to-use-define_seq_attribute-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-convert-to-use-define_seq_attribute-macro.patch

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
Subject: mm/vmstat.c: convert to use DEFINE_SEQ_ATTRIBUTE macro

Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.

Link: http://lkml.kernel.org/r/20200509064031.181091-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-convert-to-use-define_seq_attribute-macro
+++ a/mm/vmstat.c
@@ -2055,24 +2055,14 @@ static int unusable_show(struct seq_file
 	return 0;
 }
 
-static const struct seq_operations unusable_op = {
+static const struct seq_operations unusable_sops = {
 	.start	= frag_start,
 	.next	= frag_next,
 	.stop	= frag_stop,
 	.show	= unusable_show,
 };
 
-static int unusable_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &unusable_op);
-}
-
-static const struct file_operations unusable_file_ops = {
-	.open		= unusable_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(unusable);
 
 static void extfrag_show_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
@@ -2107,24 +2097,14 @@ static int extfrag_show(struct seq_file
 	return 0;
 }
 
-static const struct seq_operations extfrag_op = {
+static const struct seq_operations extfrag_sops = {
 	.start	= frag_start,
 	.next	= frag_next,
 	.stop	= frag_stop,
 	.show	= extfrag_show,
 };
 
-static int extfrag_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &extfrag_op);
-}
-
-static const struct file_operations extfrag_file_ops = {
-	.open		= extfrag_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(extfrag);
 
 static int __init extfrag_debug_init(void)
 {
@@ -2133,10 +2113,10 @@ static int __init extfrag_debug_init(voi
 	extfrag_debug_root = debugfs_create_dir("extfrag", NULL);
 
 	debugfs_create_file("unusable_index", 0444, extfrag_debug_root, NULL,
-			    &unusable_file_ops);
+			    &unusable_fops);
 
 	debugfs_create_file("extfrag_index", 0444, extfrag_debug_root, NULL,
-			    &extfrag_file_ops);
+			    &extfrag_fops);
 
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

seq_file-introduce-define_seq_attribute-helper-macro.patch
mm-vmstat-convert-to-use-define_seq_attribute-macro.patch
kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch
