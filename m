From: akpm@linux-foundation.org
Subject: + afs-support-the-cbprobeuuid-rpc-op.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:27:53 -0700
Message-ID: <200804280227.m3S2Rr5A003457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760510AbYD1C3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:29:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     afs: support the CB.ProbeUuid RPC op
has been added to the -mm tree.  Its filename is
     afs-support-the-cbprobeuuid-rpc-op.patch

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
mm-nommuc-return-0-from-kobjsize-with-invalid-objects.patch
remove-the-macro-get_personality.patch
fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
afs-support-the-cbprobeuuid-rpc-op.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mutex-subsystem-synchro-test-module.patch

