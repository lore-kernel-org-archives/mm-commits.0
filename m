From: akpm@linux-foundation.org
Subject: + afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch added to -mm tree
Date: Wed, 02 Apr 2008 11:31:34 -0700
Message-ID: <200804021831.m32IVYpT028141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYDBSc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 14:32:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     afs: the AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself
has been added to the -mm tree.  Its filename is
     afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch

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
+	.name		= "CB.",
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

alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
git-unionfs.patch
remove-the-macro-get_personality.patch
asm-generic-add-node_to_cpumask_ptr-macro.patch
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
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
mutex-subsystem-synchro-test-module.patch

