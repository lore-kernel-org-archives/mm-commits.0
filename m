From: akpm@linux-foundation.org
Subject: + hfsplus-implement-functionality-of-journal-log-wrapping.patch
 added to -mm tree
Date: Tue, 04 Feb 2014 14:33:41 -0800
Message-ID: <52f16ac5.QTVRjaxvEwEKje7u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936016AbaBDWdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-functionality-of-journal-log-wrapping.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:33:41 -0800


The patch titled
     Subject: hfsplus: implement functionality of journal log wrapping
has been added to the -mm tree.  Its filename is
     hfsplus-implement-functionality-of-journal-log-wrapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-functionality-of-journal-log-wrapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-functionality-of-journal-log-wrapping.patch

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

