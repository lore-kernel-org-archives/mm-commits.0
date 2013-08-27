From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-tiny-race-case-when-firing-callbacks.patch added to -mm tree
Date: Tue, 27 Aug 2013 13:54:34 -0700
Message-ID: <521d120a.kF9k7FMrs8vI5mcM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H0Uyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 16:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xuejiufei@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-fix-a-tiny-race-case-when-firing-callbacks.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,xuejiufei@huawei.com
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 13:54:34 -0700


The patch titled
     Subject: ocfs2: fix a tiny race case when firing callbacks
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-tiny-race-case-when-firing-callbacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-tiny-race-case-when-firing-callbacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-tiny-race-case-when-firing-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix a tiny race case when firing callbacks

In o2hb_shutdown_slot() and o2hb_check_slot(), since event is defined as
local, it is only valid during the call stack.  So the following tiny race
case may happen in a multi-volumes mounted environment:

o2hb-vol1                         o2hb-vol2
1) o2hb_shutdown_slot
allocate local event1
2) queue_node_event
add event1 to global o2hb_node_events
                                  3) o2hb_shutdown_slot
                                  allocate local event2
                                  4) queue_node_event
                                  add event2 to global o2hb_node_events
                                  5) o2hb_run_event_list
                                  delete event1 from o2hb_node_events
6) o2hb_run_event_list
event1 empty, return
7) o2hb_shutdown_slot
event1 lifecycle ends
                                  8) o2hb_fire_callbacks
                                  event1 is already *invalid*

This patch lets it wait on o2hb_callback_sem when another thread is firing
callbacks.  And for performance consideration, we only call
o2hb_run_event_list when there is an event queued.

Signed-off-by: Joyce <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-a-tiny-race-case-when-firing-callbacks fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-a-tiny-race-case-when-firing-callbacks
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -639,16 +639,9 @@ static void o2hb_fire_callbacks(struct o
 /* Will run the list in order until we process the passed event */
 static void o2hb_run_event_list(struct o2hb_node_event *queued_event)
 {
-	int empty;
 	struct o2hb_callback *hbcall;
 	struct o2hb_node_event *event;
 
-	spin_lock(&o2hb_live_lock);
-	empty = list_empty(&queued_event->hn_item);
-	spin_unlock(&o2hb_live_lock);
-	if (empty)
-		return;
-
 	/* Holding callback sem assures we don't alter the callback
 	 * lists when doing this, and serializes ourselves with other
 	 * processes wanting callbacks. */
@@ -707,6 +700,7 @@ static void o2hb_shutdown_slot(struct o2
 	struct o2hb_node_event event =
 		{ .hn_item = LIST_HEAD_INIT(event.hn_item), };
 	struct o2nm_node *node;
+	int queued = 0;
 
 	node = o2nm_get_node_by_num(slot->ds_node_num);
 	if (!node)
@@ -724,11 +718,13 @@ static void o2hb_shutdown_slot(struct o2
 
 			o2hb_queue_node_event(&event, O2HB_NODE_DOWN_CB, node,
 					      slot->ds_node_num);
+			queued = 1;
 		}
 	}
 	spin_unlock(&o2hb_live_lock);
 
-	o2hb_run_event_list(&event);
+	if (queued)
+		o2hb_run_event_list(&event);
 
 	o2nm_node_put(node);
 }
@@ -788,6 +784,7 @@ static int o2hb_check_slot(struct o2hb_r
 	unsigned int dead_ms = o2hb_dead_threshold * O2HB_REGION_TIMEOUT_MS;
 	unsigned int slot_dead_ms;
 	int tmp;
+	int queued = 0;
 
 	memcpy(hb_block, slot->ds_raw_block, reg->hr_block_bytes);
 
@@ -881,6 +878,7 @@ fire_callbacks:
 					      slot->ds_node_num);
 
 			changed = 1;
+			queued = 1;
 		}
 
 		list_add_tail(&slot->ds_live_item,
@@ -932,6 +930,7 @@ fire_callbacks:
 					      node, slot->ds_node_num);
 
 			changed = 1;
+			queued = 1;
 		}
 
 		/* We don't clear this because the node is still
@@ -947,7 +946,8 @@ fire_callbacks:
 out:
 	spin_unlock(&o2hb_live_lock);
 
-	o2hb_run_event_list(&event);
+	if (queued)
+		o2hb_run_event_list(&event);
 
 	if (node)
 		o2nm_node_put(node);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

fs-ocfs2-cluster-tcpc-fix-possible-null-pointer-dereferences.patch
ocfs2-clean-up-dead-code-in-ocfs2_acl_from_xattr.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch
ocfs2-adjust-code-style-for-o2net_handler_tree_lookup.patch
ocfs2-avoid-possible-null-pointer-dereference-in-o2net_accept_one.patch
ocfs2-fix-a-tiny-race-case-when-firing-callbacks.patch
ocfs2-cleanup-unused-variable-ip-in-dlmfs_get_root_inode.patch

