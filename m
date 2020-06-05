From: akpm@linux-foundation.org
Subject: [merged]
 seq_file-introduce-define_seq_attribute-helper-macro.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:19:44 -0700
Message-ID: <20200605201944._DMyHvMWM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgFEUTp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, davem@davemloft.net, gregkh@linuxfoundation.org, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com


The patch titled
     Subject: include/linux/seq_file.h: introduce DEFINE_SEQ_ATTRIBUTE() helper macro
has been removed from the -mm tree.  Its filename was
     seq_file-introduce-define_seq_attribute-helper-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: include/linux/seq_file.h: introduce DEFINE_SEQ_ATTRIBUTE() helper macro

Patch series "seq_file: Introduce DEFINE_SEQ_ATTRIBUTE() helper macro".

As discussed in
https://lore.kernel.org/lkml/20191129222310.GA3712618@kroah.com/, we could
introduce a new helper macro to reduce losts of boilerplate code, vmstat
and kprobes is the example which covert to use it, if this is accepted, I
will send out more cleanups.


This patch (of 3):

Introduce DEFINE_SEQ_ATTRIBUTE() helper macro to decrease code duplication.

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/20200509064031.181091-1-wangkefeng.wang@huawei.com
Link: http://lkml.kernel.org/r/20200509064031.181091-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_file.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/include/linux/seq_file.h~seq_file-introduce-define_seq_attribute-helper-macro
+++ a/include/linux/seq_file.h
@@ -145,6 +145,25 @@ void *__seq_open_private(struct file *,
 int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
 
+#define DEFINE_SEQ_ATTRIBUTE(__name)					\
+static int __name ## _open(struct inode *inode, struct file *file)	\
+{									\
+	int ret = seq_open(file, &__name ## _sops);			\
+	if (!ret && inode->i_private) {					\
+		struct seq_file *seq_f = file->private_data;		\
+		seq_f->private = inode->i_private;			\
+	}								\
+	return ret;							\
+}									\
+									\
+static const struct file_operations __name ## _fops = {			\
+	.owner		= THIS_MODULE,					\
+	.open		= __name ## _open,				\
+	.read		= seq_read,					\
+	.llseek		= seq_lseek,					\
+	.release	= seq_release,					\
+}
+
 #define DEFINE_SHOW_ATTRIBUTE(__name)					\
 static int __name ## _open(struct inode *inode, struct file *file)	\
 {									\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are
