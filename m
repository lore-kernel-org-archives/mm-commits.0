From: akpm@linux-foundation.org
Subject: + ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch added to -mm tree
Date: Mon, 14 May 2012 16:54:22 -0700
Message-ID: <20120514235423.1A447A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:41297 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab2ENXyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 May 2012 19:54:24 -0400
Received: by yhgm50 with SMTP id m50so832763yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 14 May 2012 16:54:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au


The patch titled
     Subject: ipc/mqueue: use correct gfp flags in msg_insert
has been added to the -mm tree.  Its filename is
     ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: ipc/mqueue: use correct gfp flags in msg_insert

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
fs-proc-fix-abba-deadlock-in-case-of-execution-attempt-of-map_files-entries.patch
locking-add-kern_cont-when-needed-to-self-test.patch
x86-nmi-add-missing-kern_cont-to-nmi-selftest.patch
isdn-add-missing-kern_cont.patch
isdn-add-missing-kern_cont-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch

