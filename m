From: akpm@linux-foundation.org
Subject: + rbtree-empty-nodes-have-no-color-fix.patch added to -mm tree
Date: Tue, 31 Jul 2012 12:32:03 -0700
Message-ID: <20120731193203.A9B55100081@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35342 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2GaTcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 15:32:05 -0400
Received: by obbwc20 with SMTP id wc20so4701744obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 12:32:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, sage@inktank.com, walken@google.com


The patch titled
     Subject: libceph: remove rb_node initialisation
has been added to the -mm tree.  Its filename is
     rbtree-empty-nodes-have-no-color-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: libceph: remove rb_node initialisation

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sage Weil <sage@inktank.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ceph/osd_client.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN net/ceph/osd_client.c~rbtree-empty-nodes-have-no-color-fix net/ceph/osd_client.c
--- a/net/ceph/osd_client.c~rbtree-empty-nodes-have-no-color-fix
+++ a/net/ceph/osd_client.c
@@ -213,7 +213,6 @@ struct ceph_osd_request *ceph_osdc_alloc
 	kref_init(&req->r_kref);
 	init_completion(&req->r_completion);
 	init_completion(&req->r_safe_completion);
-	rb_init_node(&req->r_node);
 	INIT_LIST_HEAD(&req->r_unsafe_item);
 	INIT_LIST_HEAD(&req->r_linger_item);
 	INIT_LIST_HEAD(&req->r_linger_osd);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
rbtree-empty-nodes-have-no-color-fix.patch

