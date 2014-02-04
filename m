From: akpm@linux-foundation.org
Subject: + hfsplus-introduce-descriptor-of-block-list-buffer.patch added
 to -mm tree
Date: Tue, 04 Feb 2014 14:33:38 -0800
Message-ID: <52f16ac2.woHDuZ68pvjTuOed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936012AbaBDWdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-introduce-descriptor-of-block-list-buffer.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:38 -0800


The patch titled
     Subject: hfsplus: introduce descriptor of block list buffer
has been added to the -mm tree.  Its filename is
     hfsplus-introduce-descriptor-of-block-list-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-introduce-descriptor-of-block-list-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-introduce-descriptor-of-block-list-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: introduce descriptor of block list buffer

Lis (binfo array) can have size from 4KB till 16KB.  Thereby, block list
can be placed in several file system blocks.

This patch introduces special structure that it incapsulates all necessary
details and buffer's pointers for passing through binfo array, check binfo
and replay transactions' blocks.

Also, the patch implements functions that initialize and deinitialize
hfsplus_blist_desc structure.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |   68 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-introduce-descriptor-of-block-list-buffer fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-introduce-descriptor-of-block-list-buffer
+++ a/fs/hfsplus/journal.c
@@ -50,6 +50,30 @@
 	(le32_to_cpu(((struct hfsplus_journal_header *)(jh))->jhdr_size))
 
 /*
+ * struct hfsplus_blist_desc - descriptor of block list buffer
+ * @start_sec: start sector of block list
+ * @cur_sec: current sector of block list
+ * @cur_index: start block index for current sector
+ * @available_bytes: how many bytes of block list does contain buffer?
+ * @blist_buf: buffer for current part of block list
+ * @binfo: pointer on binfo[0]
+ * @blhdr: cached copy of block list header
+ * @src_buf: pointer on source block in journal buffer
+ * @dst_buf: pointer on buffer for destination block
+ */
+struct hfsplus_blist_desc {
+	sector_t start_sec;
+	sector_t cur_sec;
+	u16 cur_index;
+	size_t available_bytes;
+	void *blist_buf;
+	struct hfsplus_block_info *binfo;
+	struct hfsplus_blhdr blhdr;
+	void *src_buf;
+	void *dst_buf;
+};
+
+/*
  * We want at least 8 megs of journal for each 100 gigs of
  * disk space.  We cap the size at 512 megs (64x default), unless
  * the allocation block size is larger, in which case we use one
@@ -227,6 +251,50 @@ static int hfsplus_create_journal(struct
 	return 0;
 }
 
+static void hfsplus_deinit_block_list_desc(struct hfsplus_blist_desc *desc);
+
+static int hfsplus_init_block_list_desc(struct super_block *sb,
+					struct hfsplus_blist_desc *desc)
+{
+	int err;
+
+	memset((void *)desc, 0, sizeof(*desc));
+
+	desc->blist_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (unlikely(!desc->blist_buf)) {
+		pr_err("unable to allocate blist_buf\n");
+		err = -ENOMEM;
+		goto failed_init;
+	}
+
+	desc->src_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (unlikely(!desc->src_buf)) {
+		pr_err("unable to allocate src_buf\n");
+		err = -ENOMEM;
+		goto failed_init;
+	}
+
+	desc->dst_buf = kmalloc(hfsplus_min_io_size(sb), GFP_KERNEL);
+	if (unlikely(!desc->dst_buf)) {
+		pr_err("unable to allocate dst_buf\n");
+		err = -ENOMEM;
+		goto failed_init;
+	}
+
+	return 0;
+
+failed_init:
+	hfsplus_deinit_block_list_desc(desc);
+	return err;
+}
+
+static void hfsplus_deinit_block_list_desc(struct hfsplus_blist_desc *desc)
+{
+	kfree(desc->blist_buf);
+	kfree(desc->src_buf);
+	kfree(desc->dst_buf);
+}
+
 static inline
 bool hfsplus_journal_empty(struct hfsplus_journal_header *jh)
 {
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-necessary-declarations-for-journal-replay.patch
hfsplus-rework-hfsplus_submit_bio-method.patch
hfsplus-implement-init-destroy-journal-object-functionality.patch
hfsplus-implement-functionality-for-hfsplus_journal_need_init-flag.patch
hfsplus-implement-norecovery-mount-option-support.patch
hfsplus-fix-remount-issue.patch
hfsplus-implement-check-consistency-of-journal-log-file.patch
hfsplus-introduce-descriptor-of-block-list-buffer.patch
hfsplus-implement-get-and-verify-block-list-header-functionality.patch
hfsplus-implement-functionality-of-getting-transactions-block-info.patch
hfsplus-implement-functionality-of-journal-log-wrapping.patch
hfsplus-implement-functionality-of-transactions-block-check.patch
hfsplus-implement-replay-transactions-block-functionality.patch
hfsplus-implement-replay-journal-functionality.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

