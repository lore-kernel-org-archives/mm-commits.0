From: akpm@linux-foundation.org
Subject: - make-common-helpers-for-seq_files-that-work-with-list_head-s.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:03 -0700
Message-ID: <200707132232.l6DMW39s024969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348AbXGMWdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, davem@davemloft.net, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make common helpers for seq_files that work with list_heads
has been removed from the -mm tree.  Its filename was
     make-common-helpers-for-seq_files-that-work-with-list_head-s.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make common helpers for seq_files that work with list_heads
From: Pavel Emelianov <xemul@sw.ru>

Many places in kernel use seq_file API to iterate over a regular list_head. 
The code for such iteration is identical in all the places, so it's worth
introducing a common helpers.

This makes code about 300 lines smaller:

The first version of this patch made the helper functions static inline
in the seq_file.h header. This patch moves them to the fs/seq_file.c as
Andrew proposed. The vmlinux .text section sizes are as follows:

2.6.22-rc1-mm1:              0x001794d5
with the previous version:   0x00179505
with this patch:             0x00179135

The config file used was make allnoconfig with the "y" inclusion of all
the possible options to make the files modified by the patch compile plus
drivers I have on the test node.


This patch:

Many places in kernel use seq_file API to iterate over a regular list_head. 
The code for such iteration is identical in all the places, so it's worth
introducing a common helpers.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   34 ++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |   11 +++++++++++
 2 files changed, 45 insertions(+)

diff -puN fs/seq_file.c~make-common-helpers-for-seq_files-that-work-with-list_head-s fs/seq_file.c
--- a/fs/seq_file.c~make-common-helpers-for-seq_files-that-work-with-list_head-s
+++ a/fs/seq_file.c
@@ -447,3 +447,37 @@ int seq_puts(struct seq_file *m, const c
 	return -1;
 }
 EXPORT_SYMBOL(seq_puts);
+
+struct list_head *seq_list_start(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh;
+
+	list_for_each(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+
+EXPORT_SYMBOL(seq_list_start);
+
+struct list_head *seq_list_start_head(struct list_head *head, loff_t pos)
+{
+	if (!pos)
+		return head;
+
+	return seq_list_start(head, pos - 1);
+}
+
+EXPORT_SYMBOL(seq_list_start_head);
+
+struct list_head *seq_list_next(void *v, struct list_head *head, loff_t *ppos)
+{
+	struct list_head *lh;
+
+	lh = ((struct list_head *)v)->next;
+	++*ppos;
+	return lh == head ? NULL : lh;
+}
+
+EXPORT_SYMBOL(seq_list_next);
diff -puN include/linux/seq_file.h~make-common-helpers-for-seq_files-that-work-with-list_head-s include/linux/seq_file.h
--- a/include/linux/seq_file.h~make-common-helpers-for-seq_files-that-work-with-list_head-s
+++ a/include/linux/seq_file.h
@@ -50,5 +50,16 @@ int seq_release_private(struct inode *, 
 
 #define SEQ_START_TOKEN ((void *)1)
 
+/*
+ * Helpers for iteration over list_head-s in seq_files
+ */
+
+extern struct list_head *seq_list_start(struct list_head *head,
+		loff_t pos);
+extern struct list_head *seq_list_start_head(struct list_head *head,
+		loff_t pos);
+extern struct list_head *seq_list_next(void *v, struct list_head *head,
+		loff_t *ppos);
+
 #endif
 #endif
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-afs-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
