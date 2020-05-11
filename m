From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 seq_file-introduce-define_seq_attribute-helper-macro.patch added to -mm
 tree
Date: Mon, 11 May 2020 14:21:45 -0700
Message-ID: <20200511212145.iDMy9f-kX%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgEKVVr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:21:47 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, davem@davemloft.net, gregkh@linuxfoundation.org, mhiramat@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com


The patch titled
     Subject: include/linux/seq_file.h: introduce DEFINE_SEQ_ATTRIBUTE() helper macro
has been added to the -mm tree.  Its filename is
     seq_file-introduce-define_seq_attribute-helper-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq_file-introduce-define_seq_attribute-helper-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq_file-introduce-define_seq_attribute-helper-macro.patch

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
Subject: include/linux/seq_file.h: introduce DEFINE_SEQ_ATTRIBUTE() helper macro

Patch series "seq_file: Introduce DEFINE_SEQ_ATTRIBUTE() helper macro".

As discussed in
https://lore.kernel.org/lkml/20191129222310.GA3712618@kroah.com/, we could
introduce a new helper macro to reduce losts of boilerplate code, vmstat
and kprobes is the example which covert to use it, if this is accepted, I
will send out more cleanups.


This patch (of 3):

Introduce DEFINE_SEQ_ATTRIBUTE() helper macro to decrease code duplication.

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
+			struct seq_file *seq_f = file->private_data;	\
+			seq_f->private = inode->i_private;		\
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

seq_file-introduce-define_seq_attribute-helper-macro.patch
mm-vmstat-convert-to-use-define_seq_attribute-macro.patch
kernel-kprobes-convert-to-use-define_seq_attribute-macro.patch
