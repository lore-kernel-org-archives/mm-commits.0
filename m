From: akpm@linux-foundation.org
Subject: + ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch added to -mm
 tree
Date: Thu, 21 Jan 2016 16:01:50 -0800
Message-ID: <56a1716e.7gmmQsx0EZzs27/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAVABv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 19:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: don't negotiate if last hb fail
has been added to the -mm tree.  Its filename is
     ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: don't negotiate if last hb fail

Sometimes io error is returned when storage is down for a while.  Like for
iscsi device, stroage is made offline when session timeout, and this will
make all io return -EIO.  For this case, nodes shouldn't do negotiate
timeout but should fence self.  So let nodes fence self when
o2hb_do_disk_heartbeat return an error, this is the same behavior with
o2hb without negotiate timer.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-dont-negotiate-if-last-hb-fail fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-dont-negotiate-if-last-hb-fail
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -284,6 +284,9 @@ struct o2hb_region {
 	/* Message key for negotiate timeout message. */
 	unsigned int		hr_key;
 	struct list_head	hr_handler_list;
+
+	/* last hb status, 0 for success, other value for error. */
+	int			hr_last_hb_status;
 };
 
 struct o2hb_bio_wait_ctxt {
@@ -397,6 +400,12 @@ static void o2hb_nego_timeout(struct wor
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int master_node, i, ret;
 
+	/* don't negotiate timeout if last hb failed since it is very
+	 * possible io failed. Should let write timeout fence self.
+	 */
+	if (reg->hr_last_hb_status)
+		return;
+
 	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
@@ -1230,6 +1239,7 @@ static int o2hb_thread(void *data)
 		before_hb = ktime_get_real();
 
 		ret = o2hb_do_disk_heartbeat(reg);
+		reg->hr_last_hb_status = ret;
 
 		after_hb = ktime_get_real();
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

