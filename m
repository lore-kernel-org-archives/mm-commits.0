From: akpm@linux-foundation.org
Subject: + sgi-xp-use-lockdep_assert_held.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:39:02 -0700
Message-ID: <20120329213902.CA4C0A05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:50823 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933245Ab2C2VjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2012 17:39:06 -0400
Received: by laai8 with SMTP id i8so149511laa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:39:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, holt@sgi.com


The patch titled
     Subject: sgi-xp: use lockdep_assert_held()
has been added to the -mm tree.  Its filename is
     sgi-xp-use-lockdep_assert_held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sgi-xp: use lockdep_assert_held()

!spin_is_locked() is always true on a UP build, so it cannot be used for
assertions.  Replace with lockdep_assert_held().

I realize UP builds are not very likely for this driver, but it's still
better to fix it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_channel.c |    6 +++---
 drivers/misc/sgi-xp/xpc_sn2.c     |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-use-lockdep_assert_held drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-use-lockdep_assert_held
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -28,7 +28,7 @@ xpc_process_connect(struct xpc_channel *
 {
 	enum xp_retval ret;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (!(ch->flags & XPC_C_OPENREQUEST) ||
 	    !(ch->flags & XPC_C_ROPENREQUEST)) {
@@ -82,7 +82,7 @@ xpc_process_disconnect(struct xpc_channe
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	u32 channel_was_connected = (ch->flags & XPC_C_WASCONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (!(ch->flags & XPC_C_DISCONNECTING))
 		return;
@@ -758,7 +758,7 @@ xpc_disconnect_channel(const int line, s
 {
 	u32 channel_was_connected = (ch->flags & XPC_C_CONNECTED);
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))
 		return;
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-use-lockdep_assert_held drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-use-lockdep_assert_held
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -1674,7 +1674,7 @@ xpc_teardown_msg_structures_sn2(struct x
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	ch_sn2->remote_msgqueue_pa = 0;
 
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-use-lockdep_assert_held drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-use-lockdep_assert_held
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -1181,7 +1181,7 @@ xpc_teardown_msg_structures_uv(struct xp
 {
 	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
 
-	DBUG_ON(!spin_is_locked(&ch->lock));
+	lockdep_assert_held(&ch->lock);
 
 	kfree(ch_uv->cached_notify_gru_mq_desc);
 	ch_uv->cached_notify_gru_mq_desc = NULL;
_
Subject: Subject: sgi-xp: use lockdep_assert_held()

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
brlocks-lglocks-cleanups.patch
block-use-lockdep_assert_held-for-queue-locking.patch
sgi-xp-use-lockdep_assert_held.patch
drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked.patch
xfs-fix-lock-assert-on-up.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
futex-use-lockdep_assert_held-for-lock-checking.patch
drivers-net-irda-sir_devc-remove-spin_is_locked.patch
drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch
include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch
checkpatch-check-for-spin_is_locked.patch

