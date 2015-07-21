From: akpm@linux-foundation.org
Subject: + ocfs2-do-not-log-twice-error-messages.patch added to -mm tree
Date: Tue, 21 Jul 2015 16:42:55 -0700
Message-ID: <55aed8ff.9LPcIHQyI9FJ7LIB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779AbbGUXm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 19:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not log twice error messages
has been added to the -mm tree.  Its filename is
     ocfs2-do-not-log-twice-error-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-do-not-log-twice-error-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-do-not-log-twice-error-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: do not log twice error messages

'o2hb_map_slot_data' and 'o2hb_populate_slot_data' are called from only
one place, in 'o2hb_region_dev_write'.  Return value is checked and
'mlog_errno' is called to log a message if it is not 0.

So there is no need to call 'mlog_errno' directly within these functions. 
This would result on logging the message twice.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-do-not-log-twice-error-messages fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-do-not-log-twice-error-messages
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1620,17 +1620,13 @@ static int o2hb_map_slot_data(struct o2h
 	struct o2hb_disk_slot *slot;
 
 	reg->hr_tmp_block = kmalloc(reg->hr_block_bytes, GFP_KERNEL);
-	if (reg->hr_tmp_block == NULL) {
-		mlog_errno(-ENOMEM);
+	if (reg->hr_tmp_block == NULL)
 		return -ENOMEM;
-	}
 
 	reg->hr_slots = kcalloc(reg->hr_blocks,
 				sizeof(struct o2hb_disk_slot), GFP_KERNEL);
-	if (reg->hr_slots == NULL) {
-		mlog_errno(-ENOMEM);
+	if (reg->hr_slots == NULL)
 		return -ENOMEM;
-	}
 
 	for(i = 0; i < reg->hr_blocks; i++) {
 		slot = &reg->hr_slots[i];
@@ -1646,17 +1642,13 @@ static int o2hb_map_slot_data(struct o2h
 
 	reg->hr_slot_data = kcalloc(reg->hr_num_pages, sizeof(struct page *),
 				    GFP_KERNEL);
-	if (!reg->hr_slot_data) {
-		mlog_errno(-ENOMEM);
+	if (!reg->hr_slot_data)
 		return -ENOMEM;
-	}
 
 	for(i = 0; i < reg->hr_num_pages; i++) {
 		page = alloc_page(GFP_KERNEL);
-		if (!page) {
-			mlog_errno(-ENOMEM);
+		if (!page)
 			return -ENOMEM;
-		}
 
 		reg->hr_slot_data[i] = page;
 
@@ -1688,10 +1680,8 @@ static int o2hb_populate_slot_data(struc
 	struct o2hb_disk_heartbeat_block *hb_block;
 
 	ret = o2hb_read_slots(reg, reg->hr_blocks);
-	if (ret) {
-		mlog_errno(ret);
+	if (ret)
 		goto out;
-	}
 
 	/* We only want to get an idea of the values initially in each
 	 * slot, so we do no verification - o2hb_check_slot will
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

ocfs2-do-not-log-twice-error-messages.patch
linux-next.patch

