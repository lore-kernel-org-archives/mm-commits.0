From: akpm@linux-foundation.org
Subject: [merged] ocfs2-do-not-log-twice-error-messages.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:04 -0700
Message-ID: <55ef229c.DYRELKvRKRQow7M4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbIHSCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not log twice error messages
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-log-twice-error-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1619,17 +1619,13 @@ static int o2hb_map_slot_data(struct o2h
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
@@ -1645,17 +1641,13 @@ static int o2hb_map_slot_data(struct o2h
 
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
 
@@ -1687,10 +1679,8 @@ static int o2hb_populate_slot_data(struc
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


