From: akpm@linux-foundation.org
Subject: - sgi-xp-eliminate-in-comments.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:57 -0700
Message-ID: <200807301916.m6UJGvg8011166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbYG3TYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: eliminate '>>>' in comments
has been removed from the -mm tree.  Its filename was
     sgi-xp-eliminate-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: eliminate '>>>' in comments
From: Dean Nelson <dcn@sgi.com>

Comments in /drivers/misc/sgi-xp has been using '>>>' as a means to draw
attention to something that needs to be done or considered.  To avoid
colliding with git rejects, '>>>' will now be replaced by '!!!' to
indicate something to do, and by '???' to indicate something to be
considered.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |   11 ++------
 drivers/misc/sgi-xp/xp_sn2.c        |   10 ++++----
 drivers/misc/sgi-xp/xp_uv.c         |    2 -
 drivers/misc/sgi-xp/xpc.h           |   14 +++++++----
 drivers/misc/sgi-xp/xpc_channel.c   |    2 -
 drivers/misc/sgi-xp/xpc_partition.c |    2 -
 drivers/misc/sgi-xp/xpc_sn2.c       |    8 +++---
 drivers/misc/sgi-xp/xpc_uv.c        |   32 +++++++++++++-------------
 drivers/misc/sgi-xp/xpnet.c         |    6 ++--
 9 files changed, 43 insertions(+), 44 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xp.h
@@ -21,7 +21,7 @@
 #include <asm/sn/arch.h>
 #endif
 
-/* >>> Add this #define to some linux header file some day. */
+/* ??? Add this #define to some linux header file some day? */
 #define BYTES_PER_WORD	sizeof(void *)
 
 #ifdef USE_DBUG_ON
@@ -65,18 +65,13 @@
  * other partition that is currently up. Over these channels, kernel-level
  * `users' can communicate with their counterparts on the other partitions.
  *
->>> The following described limitation of a max of eight channels possible
->>> pertains only to ia64-sn2. THIS ISN'T TRUE SINCE I'M PLANNING TO JUST
->>> TIE INTO THE EXISTING MECHANISM ONCE THE CHANNEL MESSAGES ARE RECEIVED.
->>> THE 128-BYTE CACHELINE PERFORMANCE ISSUE IS TIED TO IA64-SN2.
- *
  * If the need for additional channels arises, one can simply increase
  * XPC_MAX_NCHANNELS accordingly. If the day should come where that number
  * exceeds the absolute MAXIMUM number of channels possible (eight), then one
  * will need to make changes to the XPC code to accommodate for this.
  *
- * The absolute maximum number of channels possible is currently limited to
- * eight for performance reasons. The internal cross partition structures
+ * The absolute maximum number of channels possible is limited to eight for
+ * performance reasons on sn2 hardware. The internal cross partition structures
  * require sixteen bytes per channel, and eight allows all of this
  * interface-shared info to fit in one 128-byte cacheline.
  */
diff -puN drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xp_sn2.c
--- a/drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xp_sn2.c
@@ -87,11 +87,11 @@ xp_remote_memcpy_sn2(void *vdst, const v
 {
 	bte_result_t ret;
 	u64 pdst = ia64_tpa(vdst);
-	/* >>> What are the rules governing the src and dst addresses passed in?
-	 * >>> Currently we're assuming that dst is a virtual address and src
-	 * >>> is a physical address, is this appropriate? Can we allow them to
-	 * >>> be whatever and we make the change here without damaging the
-	 * >>> addresses?
+	/* ??? What are the rules governing the src and dst addresses passed in?
+	 * ??? Currently we're assuming that dst is a virtual address and src
+	 * ??? is a physical address, is this appropriate? Can we allow them to
+	 * ??? be whatever and we make the change here without damaging the
+	 * ??? addresses?
 	 */
 
 	/*
diff -puN drivers/misc/sgi-xp/xp_uv.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xp_uv.c
--- a/drivers/misc/sgi-xp/xp_uv.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -18,7 +18,7 @@
 static enum xp_retval
 xp_remote_memcpy_uv(void *vdst, const void *psrc, size_t len)
 {
-	/* >>> this function needs fleshing out */
+	/* !!! this function needs fleshing out */
 	return xpUnsupported;
 }
 
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -276,9 +276,12 @@ struct xpc_notify {
  * There is an array of these structures for each remote partition. It is
  * allocated at the time a partition becomes active. The array contains one
  * of these structures for each potential channel connection to that partition.
+ */
+
+/*
+ * The following is sn2 only.
  *
->>> sn2 only!!!
- * Each of these structures manages two message queues (circular buffers).
+ * Each channel structure manages two message queues (circular buffers).
  * They are allocated at the time a channel connection is made. One of
  * these message queues (local_msgqueue) holds the locally created messages
  * that are destined for the remote partition. The other of these message
@@ -345,6 +348,7 @@ struct xpc_notify {
  *	new messages, by the clearing of the message flags of the acknowledged
  *	messages.
  */
+
 struct xpc_channel_sn2 {
 
 	/* various flavors of local and remote Get/Put values */
@@ -359,7 +363,7 @@ struct xpc_channel_sn2 {
 };
 
 struct xpc_channel_uv {
-	/* >>> code is coming */
+	/* !!! code is coming */
 };
 
 struct xpc_channel {
@@ -500,7 +504,7 @@ xpc_any_msg_chctl_flags_set(union xpc_ch
 }
 
 /*
- * Manages channels on a partition basis. There is one of these structures
+ * Manage channels on a partition basis. There is one of these structures
  * for each partition (a partition will never utilize the structure that
  * represents itself).
  */
@@ -535,7 +539,7 @@ struct xpc_partition_sn2 {
 };
 
 struct xpc_partition_uv {
-	/* >>> code is coming */
+	/* !!! code is coming */
 };
 
 struct xpc_partition {
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -129,7 +129,7 @@ xpc_process_disconnect(struct xpc_channe
 
 	/* wake those waiting for notify completion */
 	if (atomic_read(&ch->n_to_notify) > 0) {
-		/* >>> we do callout while holding ch->lock */
+		/* we do callout while holding ch->lock, callout can't block */
 		xpc_notify_senders_of_disconnect(ch);
 	}
 
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -91,7 +91,7 @@ xpc_get_rsvd_page_pa(int nasid)
 		if (status != SALRET_MORE_PASSES)
 			break;
 
-		/* >>> L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
+		/* !!! L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
 		if (L1_CACHE_ALIGN(len) > buf_len) {
 			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -75,7 +75,7 @@ xpc_allow_IPI_ops_sn2(void)
 	int node;
 	int nasid;
 
-	/* >>> The following should get moved into SAL. */
+	/* !!! The following should get moved into SAL. */
 	if (is_shub2()) {
 		xpc_sh2_IPI_access0_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
@@ -118,7 +118,7 @@ xpc_disallow_IPI_ops_sn2(void)
 	int node;
 	int nasid;
 
-	/* >>> The following should get moved into SAL. */
+	/* !!! The following should get moved into SAL. */
 	if (is_shub2()) {
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
@@ -1360,7 +1360,7 @@ xpc_teardown_infrastructure_sn2(struct x
  * dst must be a cacheline aligned virtual address on this partition.
  * cnt must be cacheline sized
  */
-/* >>> Replace this function by call to xp_remote_memcpy() or bte_copy()? */
+/* ??? Replace this function by call to xp_remote_memcpy() or bte_copy()? */
 static enum xp_retval
 xpc_pull_remote_cachelines_sn2(struct xpc_partition *part, void *dst,
 			       const void *src, size_t cnt)
@@ -2242,7 +2242,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 		notify->key = key;
 		notify->type = notify_type;
 
-		/* >>> is a mb() needed here? */
+		/* ??? Is a mb() needed here? */
 
 		if (ch->flags & XPC_C_DISCONNECTING) {
 			/*
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -15,8 +15,8 @@
 
 #include <linux/kernel.h>
 
-/* >>> #include <gru/grukservices.h> */
-/* >>> uv_gpa() is defined in <gru/grukservices.h> */
+/* !!! #include <gru/grukservices.h> */
+/* !!! uv_gpa() is defined in <gru/grukservices.h> */
 #define uv_gpa(_a)		((unsigned long)_a)
 
 #include "xpc.h"
@@ -29,16 +29,16 @@ static void
 xpc_send_local_activate_IRQ_uv(struct xpc_partition *part)
 {
 	/*
-	 * >>> make our side think that the remote parition sent an activate
-	 * >>> message our way. Also do what the activate IRQ handler would
-	 * >>> do had one really been sent.
+	 * !!! Make our side think that the remote parition sent an activate
+	 * !!! message our way. Also do what the activate IRQ handler would
+	 * !!! do had one really been sent.
 	 */
 }
 
 static enum xp_retval
 xpc_rsvd_page_init_uv(struct xpc_rsvd_page *rp)
 {
-	/* >>> need to have established xpc_activate_mq earlier */
+	/* !!! need to have established xpc_activate_mq earlier */
 	rp->sn.activate_mq_gpa = uv_gpa(xpc_activate_mq);
 	return xpSuccess;
 }
@@ -46,7 +46,7 @@ xpc_rsvd_page_init_uv(struct xpc_rsvd_pa
 static void
 xpc_increment_heartbeat_uv(void)
 {
-	/* >>> send heartbeat msg to xpc_heartbeating_to_mask partids */
+	/* !!! send heartbeat msg to xpc_heartbeating_to_mask partids */
 }
 
 static void
@@ -59,7 +59,7 @@ xpc_heartbeat_init_uv(void)
 static void
 xpc_heartbeat_exit_uv(void)
 {
-	/* >>> send heartbeat_offline msg to xpc_heartbeating_to_mask partids */
+	/* !!! send heartbeat_offline msg to xpc_heartbeating_to_mask partids */
 }
 
 static void
@@ -70,9 +70,9 @@ xpc_request_partition_activation_uv(stru
 	struct xpc_partition *part = &xpc_partitions[partid];
 
 /*
- * >>> setup part structure with the bits of info we can glean from the rp
- * >>>	part->remote_rp_pa = remote_rp_pa;
- * >>>	part->sn.uv.activate_mq_gpa = remote_rp->sn.activate_mq_gpa;
+ * !!! Setup part structure with the bits of info we can glean from the rp:
+ * !!!	part->remote_rp_pa = remote_rp_pa;
+ * !!!	part->sn.uv.activate_mq_gpa = remote_rp->sn.activate_mq_gpa;
  */
 
 	xpc_send_local_activate_IRQ_uv(part);
@@ -91,7 +91,7 @@ xpc_request_partition_reactivation_uv(st
 static enum xp_retval
 xpc_setup_infrastructure_uv(struct xpc_partition *part)
 {
-	/* >>> this function needs fleshing out */
+	/* !!! this function needs fleshing out */
 	return xpUnsupported;
 }
 
@@ -102,28 +102,28 @@ xpc_setup_infrastructure_uv(struct xpc_p
 static void
 xpc_teardown_infrastructure_uv(struct xpc_partition *part)
 {
-	/* >>> this function needs fleshing out */
+	/* !!! this function needs fleshing out */
 	return;
 }
 
 static enum xp_retval
 xpc_make_first_contact_uv(struct xpc_partition *part)
 {
-	/* >>> this function needs fleshing out */
+	/* !!! this function needs fleshing out */
 	return xpUnsupported;
 }
 
 static u64
 xpc_get_chctl_all_flags_uv(struct xpc_partition *part)
 {
-	/* >>> this function needs fleshing out */
+	/* !!! this function needs fleshing out */
 	return 0UL;
 }
 
 static struct xpc_msg *
 xpc_get_deliverable_msg_uv(struct xpc_channel *ch)
 {
-	/* >>> this function needs fleshing out */
+	/* !!! this function needs fleshing out */
 	return NULL;
 }
 
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-eliminate-in-comments drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-eliminate-in-comments
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -229,9 +229,9 @@ xpnet_receive(short partid, int channel,
 
 		if (ret != xpSuccess) {
 			/*
-			 * >>> Need better way of cleaning skb.  Currently skb
-			 * >>> appears in_use and we can't just call
-			 * >>> dev_kfree_skb.
+			 * !!! Need better way of cleaning skb.  Currently skb
+			 * !!! appears in_use and we can't just call
+			 * !!! dev_kfree_skb.
 			 */
 			dev_err(xpnet, "xp_remote_memcpy(0x%p, 0x%p, 0x%hx) "
 				"returned error=0x%x\n", (void *)
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

