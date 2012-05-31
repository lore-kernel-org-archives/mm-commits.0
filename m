From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch removed from -mm tree
Date: Thu, 31 May 2012 16:16:51 -0700
Message-ID: <20120531231651.99CBFA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:49416 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2EaXQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:16:52 -0400
Received: by vbnl22 with SMTP id l22so161069vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:16:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: use correct gfp flags in msg_insert
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch

This patch was dropped because it was folded into ipc-mqueue-improve-performance-of-send-recv.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: ipc/mqueue: use correct gfp flags in msg_insert

msg_insert() tries to allocate using GFP_KERNEL, while in both cases when
it's called, it's coming from an atomic context.  Introduced by 7dd7edf
("ipc/mqueue: improve performance of send/recv").

Use GFP_ATOMIC instead.

Also, fix up coding style in the kzalloc while we're there.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert
+++ a/ipc/mqueue.c
@@ -133,7 +133,7 @@ static int msg_insert(struct msg_msg *ms
 		else
 			p = &(*p)->rb_right;
 	}
-	leaf = kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
+	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
 	if (!leaf)
 		return -ENOMEM;
 	rb_init_node(&leaf->rb_node);
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
locking-add-kern_cont-when-needed-to-self-test.patch
isdn-add-missing-kern_cont.patch
ipc-mqueue-improve-performance-of-send-recv.patch

