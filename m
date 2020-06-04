From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 094/127] mm/vmstat.c: convert to use
 DEFINE_SEQ_ATTRIBUTE macro
Date: Thu, 04 Jun 2020 16:51:08 -0700
Message-ID: <20200604235108.xRDuWhNRu%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgFDXvM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:51:12 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com, davem@davemloft.net, gregkh@linuxfoundation.org, linux-mm@kvack.org, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com

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
@@ -2069,24 +2069,14 @@ static int unusable_show(struct seq_file
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
@@ -2121,24 +2111,14 @@ static int extfrag_show(struct seq_file
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
