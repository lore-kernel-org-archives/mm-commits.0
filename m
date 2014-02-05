From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-implement-functionality-of-journal-log-wrapping.patch removed from
 -mm tree
Date: Wed, 05 Feb 2014 15:49:17 -0800
Message-ID: <52f2cdfd.VmOAeXG5kZ7EEgsQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaBEXtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-implement-functionality-of-journal-log-wrapping.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:17 -0800


The patch titled
     Subject: hfsplus: implement functionality of journal log wrapping
has been removed from the -mm tree.  Its filename was
     hfsplus-implement-functionality-of-journal-log-wrapping.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: implement functionality of journal log wrapping

The journal log is a circular buffer.  Thereby, journal log's content can
be splitted by journal end on two parts in some situations.  When reading
or writing the journal buffer, the I/O operation must stop at the end of
the journal buffer and resume (wrap around) immediately following the
journal header.

This patch implements functionality of wrapping of journal log for such
situation. Namely, it means setting of "start" field of journal
header by journal header size value.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/journal.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN fs/hfsplus/journal.c~hfsplus-implement-functionality-of-journal-log-wrapping fs/hfsplus/journal.c
--- a/fs/hfsplus/journal.c~hfsplus-implement-functionality-of-journal-log-wrapping
+++ a/fs/hfsplus/journal.c
@@ -290,6 +290,36 @@ static inline bool need_to_wrap_journal(
 	return (cur_off + req_size) > JOURNAL_SIZE(jh);
 }
 
+static inline void __hfsplus_wrap_journal(struct super_block *sb)
+{
+	struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+
+	jnl->jh->start = jnl->jh->jhdr_size;
+}
+
+/* Return rest bytes of binfo or blhdr from the journal begin */
+static inline u32 hfsplus_wrap_journal(struct super_block *sb,
+					u64 cur_off, u32 req_size)
+{
+	struct hfsplus_journal *jnl = HFSPLUS_SB(sb)->jnl;
+	struct hfsplus_journal_header *jh = jnl->jh;
+	u32 used_bytes;
+	u32 rest_bytes;
+
+	hfs_dbg(JOURNAL, "cur_off %llu, req_size %u, JOURNAL_SIZE(jh) %llu\n",
+		cur_off, req_size, JOURNAL_SIZE(jh));
+
+	BUG_ON(cur_off > JOURNAL_SIZE(jh));
+	BUG_ON((cur_off + req_size) < JOURNAL_SIZE(jh));
+
+	used_bytes = JOURNAL_SIZE(jh) - cur_off;
+	rest_bytes = req_size - used_bytes;
+
+	__hfsplus_wrap_journal(sb);
+
+	return rest_bytes;
+}
+
 static void hfsplus_deinit_block_list_desc(struct hfsplus_blist_desc *desc);
 
 static int hfsplus_init_block_list_desc(struct super_block *sb,
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-implement-functionality-of-transactions-block-check.patch
hfsplus-implement-replay-transactions-block-functionality.patch
hfsplus-implement-replay-journal-functionality.patch
hfsplus-implement-replay-journal-functionality-fix.patch
hfsplus-integrate-journal-replay-support-into-driver.patch

