From: akpm@linux-foundation.org
Subject: + ipcmsg-drop-dst-nil-validation-in-copy_msg.patch added to -mm
 tree
Date: Thu, 15 Oct 2015 12:40:46 -0700
Message-ID: <5620013e.88iz4gVpG9/qkj4Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbJOTkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,msg: drop dst nil validation in copy_msg
has been added to the -mm tree.  Its filename is
     ipcmsg-drop-dst-nil-validation-in-copy_msg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmsg-drop-dst-nil-validation-in-copy_msg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmsg-drop-dst-nil-validation-in-copy_msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmacache-inline-vmacache_valid_mm.patch
ipcmsg-drop-dst-nil-validation-in-copy_msg.patch

