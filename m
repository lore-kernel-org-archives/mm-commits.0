From: akpm@linux-foundation.org
Subject: - afs-support-the-cbprobeuuid-rpc-op.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:54 -0700
Message-ID: <200804300548.m3U5msfP029925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046AbYD3Ftk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     afs: support the CB.ProbeUuid RPC op
has been removed from the -mm tree.  Its filename was
     afs-support-the-cbprobeuuid-rpc-op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: support the CB.ProbeUuid RPC op
From: David Howells <dhowells@redhat.com>

Add support for the CB.ProbeUuid cache manager RPC op.  This allows a modern
OpenAFS server to quickly ask if the client has been rebooted.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/afs_cm.h    |    1 
 fs/afs/cmservice.c |  107 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff -puN fs/afs/afs_cm.h~afs-support-the-cbprobeuuid-rpc-op fs/afs/afs_cm.h
--- a/fs/afs/afs_cm.h~afs-support-the-cbprobeuuid-rpc-op
+++ a/fs/afs/afs_cm.h
@@ -24,6 +24,7 @@ enum AFS_CM_Operations {
 	CBGetXStatsVersion	= 209,	/* get version of extended statistics */
 	CBGetXStats		= 210,	/* get contents of extended statistics data */
 	CBInitCallBackState3	= 213,	/* initialise callback state, version 3 */
+	CBProbeUuid		= 214,	/* check the client hasn't rebooted */
 	CBTellMeAboutYourself	= 65538, /* get client capabilities */
 };
 
diff -puN fs/afs/cmservice.c~afs-support-the-cbprobeuuid-rpc-op fs/afs/cmservice.c
--- a/fs/afs/cmservice.c~afs-support-the-cbprobeuuid-rpc-op
+++ a/fs/afs/cmservice.c
@@ -26,6 +26,7 @@ static int afs_deliver_cb_init_call_back
 						struct sk_buff *, bool);
 static int afs_deliver_cb_probe(struct afs_call *, struct sk_buff *, bool);
 static int afs_deliver_cb_callback(struct afs_call *, struct sk_buff *, bool);
+static int afs_deliver_cb_probe_uuid(struct afs_call *, struct sk_buff *, bool);
 static int afs_deliver_cb_tell_me_about_yourself(struct afs_call *,
 						 struct sk_buff *, bool);
 static void afs_cm_destructor(struct afs_call *);
@@ -71,6 +72,16 @@ static const struct afs_call_type afs_SR
 };
 
 /*
+ * CB.ProbeUuid operation type
+ */
+static const struct afs_call_type afs_SRXCBProbeUuid = {
+	.name		= "CB.ProbeUuid",
+	.deliver	= afs_deliver_cb_probe_uuid,
+	.abort_to_error	= afs_abort_to_error,
+	.destructor	= afs_cm_destructor,
+};
+
+/*
  * CB.TellMeAboutYourself operation type
  */
 static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
@@ -393,6 +404,102 @@ static int afs_deliver_cb_probe(struct a
 }
 
 /*
+ * allow the fileserver to quickly find out if the fileserver has been rebooted
+ */
+static void SRXAFSCB_ProbeUuid(struct work_struct *work)
+{
+	struct afs_call *call = container_of(work, struct afs_call, work);
+	struct afs_uuid *r = call->request;
+
+	struct {
+		__be32	match;
+	} reply;
+
+	_enter("");
+
+
+	if (memcmp(r, &afs_uuid, sizeof(afs_uuid)) == 0)
+		reply.match = htonl(0);
+	else
+		reply.match = htonl(1);
+
+	afs_send_simple_reply(call, &reply, sizeof(reply));
+	_leave("");
+}
+
+/*
+ * deliver request data to a CB.ProbeUuid call
+ */
+static int afs_deliver_cb_probe_uuid(struct afs_call *call, struct sk_buff *skb,
+				     bool last)
+{
+	struct afs_uuid *r;
+	unsigned loop;
+	__be32 *b;
+	int ret;
+
+	_enter("{%u},{%u},%d", call->unmarshall, skb->len, last);
+
+	if (skb->len > 0)
+		return -EBADMSG;
+	if (!last)
+		return 0;
+
+	switch (call->unmarshall) {
+	case 0:
+		call->offset = 0;
+		call->buffer = kmalloc(11 * sizeof(__be32), GFP_KERNEL);
+		if (!call->buffer)
+			return -ENOMEM;
+		call->unmarshall++;
+
+	case 1:
+		_debug("extract UUID");
+		ret = afs_extract_data(call, skb, last, call->buffer,
+				       11 * sizeof(__be32));
+		switch (ret) {
+		case 0:		break;
+		case -EAGAIN:	return 0;
+		default:	return ret;
+		}
+
+		_debug("unmarshall UUID");
+		call->request = kmalloc(sizeof(struct afs_uuid), GFP_KERNEL);
+		if (!call->request)
+			return -ENOMEM;
+
+		b = call->buffer;
+		r = call->request;
+		r->time_low			= ntohl(b[0]);
+		r->time_mid			= ntohl(b[1]);
+		r->time_hi_and_version		= ntohl(b[2]);
+		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
+		r->clock_seq_low		= ntohl(b[4]);
+
+		for (loop = 0; loop < 6; loop++)
+			r->node[loop] = ntohl(b[loop + 5]);
+
+		call->offset = 0;
+		call->unmarshall++;
+
+	case 2:
+		_debug("trailer");
+		if (skb->len != 0)
+			return -EBADMSG;
+		break;
+	}
+
+	if (!last)
+		return 0;
+
+	call->state = AFS_CALL_REPLYING;
+
+	INIT_WORK(&call->work, SRXAFSCB_ProbeUuid);
+	schedule_work(&call->work);
+	return 0;
+}
+
+/*
  * allow the fileserver to ask about the cache manager's capabilities
  */
 static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

