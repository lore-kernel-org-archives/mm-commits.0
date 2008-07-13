From: akpm@linux-foundation.org
Subject: + sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:10:44 -0700
Message-ID: <200807130610.m6D6AiLi007350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbYGMGKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, steiner@sgi.com, tony.luck@intel.com


The patch titled
     sgi-xp: move xpc_check_remote_hb() to support both SN2 and UV
has been added to the -mm tree.  Its filename is
     sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: move xpc_check_remote_hb() to support both SN2 and UV
From: Dean Nelson <dcn@sgi.com>

Move xpc_check_remote_hb() so it can support both SN2 and UV.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h      |    2 
 drivers/misc/sgi-xp/xpc_main.c |   34 ++++++++++++++-
 drivers/misc/sgi-xp/xpc_sn2.c  |   70 ++++++++++---------------------
 3 files changed, 57 insertions(+), 49 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -632,7 +632,7 @@ extern void (*xpc_heartbeat_exit) (void)
 extern void (*xpc_increment_heartbeat) (void);
 extern void (*xpc_offline_heartbeat) (void);
 extern void (*xpc_online_heartbeat) (void);
-extern void (*xpc_check_remote_hb) (void);
+extern enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *);
 extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
 extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
 extern enum xp_retval (*xpc_allocate_msgqueues) (struct xpc_channel *);
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -178,7 +178,7 @@ void (*xpc_heartbeat_exit) (void);
 void (*xpc_increment_heartbeat) (void);
 void (*xpc_offline_heartbeat) (void);
 void (*xpc_online_heartbeat) (void);
-void (*xpc_check_remote_hb) (void);
+enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *part);
 
 enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
 void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
@@ -270,6 +270,38 @@ xpc_stop_hb_beater(void)
 }
 
 /*
+ * At periodic intervals, scan through all active partitions and ensure
+ * their heartbeat is still active.  If not, the partition is deactivated.
+ */
+static void
+xpc_check_remote_hb(void)
+{
+	struct xpc_partition *part;
+	short partid;
+	enum xp_retval ret;
+
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
+
+		if (xpc_exiting)
+			break;
+
+		if (partid == xp_partition_id)
+			continue;
+
+		part = &xpc_partitions[partid];
+
+		if (part->act_state == XPC_P_INACTIVE ||
+		    part->act_state == XPC_P_DEACTIVATING) {
+			continue;
+		}
+
+		ret = xpc_get_remote_heartbeat(part);
+		if (ret != xpSuccess)
+			XPC_DEACTIVATE_PARTITION(part, ret);
+	}
+}
+
+/*
  * This thread is responsible for nearly all of the partition
  * activation/deactivation.
  */
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -704,61 +704,37 @@ xpc_heartbeat_exit_sn2(void)
 	xpc_offline_heartbeat_sn2();
 }
 
-/*
- * At periodic intervals, scan through all active partitions and ensure
- * their heartbeat is still active.  If not, the partition is deactivated.
- */
-static void
-xpc_check_remote_hb_sn2(void)
+static enum xp_retval
+xpc_get_remote_heartbeat_sn2(struct xpc_partition *part)
 {
 	struct xpc_vars_sn2 *remote_vars;
-	struct xpc_partition *part;
-	short partid;
 	enum xp_retval ret;
 
 	remote_vars = (struct xpc_vars_sn2 *)xpc_remote_copy_buffer_sn2;
 
-	for (partid = 0; partid < XP_MAX_NPARTITIONS_SN2; partid++) {
-
-		if (xpc_exiting)
-			break;
-
-		if (partid == sn_partition_id)
-			continue;
-
-		part = &xpc_partitions[partid];
-
-		if (part->act_state == XPC_P_INACTIVE ||
-		    part->act_state == XPC_P_DEACTIVATING) {
-			continue;
-		}
-
-		/* pull the remote_hb cache line */
-		ret = xp_remote_memcpy(xp_pa(remote_vars),
-				       part->sn.sn2.remote_vars_pa,
-				       XPC_RP_VARS_SIZE);
-		if (ret != xpSuccess) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-			continue;
-		}
-
-		dev_dbg(xpc_part, "partid = %d, heartbeat = %ld, last_heartbeat"
-			" = %ld, heartbeat_offline = %ld, HB_mask[0] = 0x%lx\n",
-			partid, remote_vars->heartbeat, part->last_heartbeat,
-			remote_vars->heartbeat_offline,
-			remote_vars->heartbeating_to_mask[0]);
-
-		if (((remote_vars->heartbeat == part->last_heartbeat) &&
-		     (remote_vars->heartbeat_offline == 0)) ||
-		    !xpc_hb_allowed(sn_partition_id,
-				    &remote_vars->heartbeating_to_mask)) {
-
-			XPC_DEACTIVATE_PARTITION(part, xpNoHeartbeat);
-			continue;
-		}
+	/* pull the remote vars structure that contains the heartbeat */
+	ret = xp_remote_memcpy(xp_pa(remote_vars),
+			       part->sn.sn2.remote_vars_pa,
+			       XPC_RP_VARS_SIZE);
+	if (ret != xpSuccess)
+		return ret;
 
+	dev_dbg(xpc_part, "partid=%d, heartbeat=%ld, last_heartbeat=%ld, "
+		"heartbeat_offline=%ld, HB_mask[0]=0x%lx\n", XPC_PARTID(part),
+		remote_vars->heartbeat, part->last_heartbeat,
+		remote_vars->heartbeat_offline,
+		remote_vars->heartbeating_to_mask[0]);
+
+	if ((remote_vars->heartbeat == part->last_heartbeat &&
+	    remote_vars->heartbeat_offline == 0) ||
+	    !xpc_hb_allowed(sn_partition_id,
+			    &remote_vars->heartbeating_to_mask)) {
+		ret = xpNoHeartbeat;
+	} else {
 		part->last_heartbeat = remote_vars->heartbeat;
 	}
+
+	return ret;
 }
 
 /*
@@ -2416,7 +2392,7 @@ xpc_init_sn2(void)
 	xpc_online_heartbeat = xpc_online_heartbeat_sn2;
 	xpc_heartbeat_init = xpc_heartbeat_init_sn2;
 	xpc_heartbeat_exit = xpc_heartbeat_exit_sn2;
-	xpc_check_remote_hb = xpc_check_remote_hb_sn2;
+	xpc_get_remote_heartbeat = xpc_get_remote_heartbeat_sn2;
 
 	xpc_request_partition_activation = xpc_request_partition_activation_sn2;
 	xpc_request_partition_reactivation =
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-xp-define-is_shub-and-is_uv-macros.patch
sgi-xp-define-xpsalerror-reason-code.patch
sgi-xp-define-bytes_per_word.patch
sgi-xp-support-runtime-selection-of-xp_max_npartitions.patch
sgi-xp-create-a-common-xp_remote_memcpy-function.patch
sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware.patch
sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only.patch
sgi-xp-isolate-xpc_vars-structure-to-sn2-only.patch
sgi-xp-base-xpc_rsvd_pages-timestamp-on-jiffies.patch
sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify.patch
sgi-xp-isolate-activate-irqs-hardware-specific-components.patch
sgi-xp-isolate-additional-sn2-specific-code.patch
sgi-xp-separate-chctl_flags-from-xpcs-notify-irq.patch
sgi-xp-replace-amo_t-typedef-by-struct-amo.patch
sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only.patch
sgi-xp-enable-xpnet-to-handle-more-than-64-partitions.patch
sgi-xp-isolate-remote-copy-buffer-to-sn2-only.patch
sgi-xp-add-_sn2-suffix-to-a-few-variables.patch
sgi-xp-eliminate-in-comments.patch
sgi-xp-use-standard-bitops-macros-and-functions.patch
sgi-xp-add-jiffies-to-reserved-pages-timestamp-name.patch
sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch
sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch
sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch
sgi-xp-cleanup-naming-of-partition-defines.patch
sgi-xp-setup-the-activate-gru-message-queue.patch
sgi-xp-setup-the-notify-gru-message-queue.patch

