From: akpm@linux-foundation.org
Subject: - afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:52 -0700
Message-ID: <200804300548.m3U5mq1x029921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758816AbYD3Ftu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs: the AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself
has been removed from the -mm tree.  Its filename was
     afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: the AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself
From: David Howells <dhowells@redhat.com>

The AFS RxRPC op CBGetCapabilities is actually CBTellMeAboutYourself.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/afs_cm.h    |    2 +-
 fs/afs/cmservice.c |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/afs/afs_cm.h~afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself fs/afs/afs_cm.h
--- a/fs/afs/afs_cm.h~afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself
+++ a/fs/afs/afs_cm.h
@@ -24,7 +24,7 @@ enum AFS_CM_Operations {
 	CBGetXStatsVersion	= 209,	/* get version of extended statistics */
 	CBGetXStats		= 210,	/* get contents of extended statistics data */
 	CBInitCallBackState3	= 213,	/* initialise callback state, version 3 */
-	CBGetCapabilities	= 65538, /* get client capabilities */
+	CBTellMeAboutYourself	= 65538, /* get client capabilities */
 };
 
 #define AFS_CAP_ERROR_TRANSLATION	0x1
diff -puN fs/afs/cmservice.c~afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself fs/afs/cmservice.c
--- a/fs/afs/cmservice.c~afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself
+++ a/fs/afs/cmservice.c
@@ -26,8 +26,8 @@ static int afs_deliver_cb_init_call_back
 						struct sk_buff *, bool);
 static int afs_deliver_cb_probe(struct afs_call *, struct sk_buff *, bool);
 static int afs_deliver_cb_callback(struct afs_call *, struct sk_buff *, bool);
-static int afs_deliver_cb_get_capabilities(struct afs_call *, struct sk_buff *,
-					   bool);
+static int afs_deliver_cb_tell_me_about_yourself(struct afs_call *,
+						 struct sk_buff *, bool);
 static void afs_cm_destructor(struct afs_call *);
 
 /*
@@ -71,11 +71,11 @@ static const struct afs_call_type afs_SR
 };
 
 /*
- * CB.GetCapabilities operation type
+ * CB.TellMeAboutYourself operation type
  */
-static const struct afs_call_type afs_SRXCBGetCapabilites = {
-	.name		= "CB.GetCapabilities",
-	.deliver	= afs_deliver_cb_get_capabilities,
+static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
+	.name		= "CB.TellMeAboutYourself",
+	.deliver	= afs_deliver_cb_tell_me_about_yourself,
 	.abort_to_error	= afs_abort_to_error,
 	.destructor	= afs_cm_destructor,
 };
@@ -103,8 +103,8 @@ bool afs_cm_incoming_call(struct afs_cal
 	case CBProbe:
 		call->type = &afs_SRXCBProbe;
 		return true;
-	case CBGetCapabilities:
-		call->type = &afs_SRXCBGetCapabilites;
+	case CBTellMeAboutYourself:
+		call->type = &afs_SRXCBTellMeAboutYourself;
 		return true;
 	default:
 		return false;
@@ -395,7 +395,7 @@ static int afs_deliver_cb_probe(struct a
 /*
  * allow the fileserver to ask about the cache manager's capabilities
  */
-static void SRXAFSCB_GetCapabilities(struct work_struct *work)
+static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 {
 	struct afs_interface *ifs;
 	struct afs_call *call = container_of(work, struct afs_call, work);
@@ -456,10 +456,10 @@ static void SRXAFSCB_GetCapabilities(str
 }
 
 /*
- * deliver request data to a CB.GetCapabilities call
+ * deliver request data to a CB.TellMeAboutYourself call
  */
-static int afs_deliver_cb_get_capabilities(struct afs_call *call,
-					   struct sk_buff *skb, bool last)
+static int afs_deliver_cb_tell_me_about_yourself(struct afs_call *call,
+						 struct sk_buff *skb, bool last)
 {
 	_enter(",{%u},%d", skb->len, last);
 
@@ -471,7 +471,7 @@ static int afs_deliver_cb_get_capabiliti
 	/* no unmarshalling required */
 	call->state = AFS_CALL_REPLYING;
 
-	INIT_WORK(&call->work, SRXAFSCB_GetCapabilities);
+	INIT_WORK(&call->work, SRXAFSCB_TellMeAboutYourself);
 	schedule_work(&call->work);
 	return 0;
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

