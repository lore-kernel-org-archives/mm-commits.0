From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-drop-dst-nil-validation-in-copy_msg.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:57 -0800
Message-ID: <5640fe85.jX27lPOlrPmoIK6A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbKIUN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,msg: drop dst nil validation in copy_msg
has been removed from the -mm tree.  Its filename was
     ipcmsg-drop-dst-nil-validation-in-copy_msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,msg: drop dst nil validation in copy_msg

d0edd8528362 ("ipc: convert invalid scenarios to use WARN_ON") relaxed the
nil dst parameter check, originally being a full BUG_ON.  However, this
check seems quite unnecessary when the only purpose is for
ceckpoint/restore (MSG_COPY flag):

o The copy variable is set initially to nil, apparently as a way of
  ensuring that prepare_copy is previously called.  Which is in fact done,
  unconditionally at the beginning of do_msgrcv.

o There is no concurrency with 'copy' (stack allocated in do_msgrcv).

Furthermore, any errors in 'copy' (and thus prepare_copy/copy_msg) should
always handled by IS_ERR() family.  Therefore remove this check altogether
as it can never occur with the current users.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN ipc/msgutil.c~ipcmsg-drop-dst-nil-validation-in-copy_msg ipc/msgutil.c
--- a/ipc/msgutil.c~ipcmsg-drop-dst-nil-validation-in-copy_msg
+++ a/ipc/msgutil.c
@@ -123,7 +123,6 @@ struct msg_msg *copy_msg(struct msg_msg
 	size_t len = src->m_ts;
 	size_t alen;
 
-	WARN_ON(dst == NULL);
 	if (src->m_ts > dst->m_ts)
 		return ERR_PTR(-EINVAL);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are


