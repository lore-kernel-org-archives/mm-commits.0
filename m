From: akpm@linux-foundation.org
Subject: + rbtree-empty-nodes-have-no-color-fix.patch added to -mm tree
Date: Mon, 13 Aug 2012 15:16:21 -0700
Message-ID: <20120813221622.A28635C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40450 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab2HMWQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Aug 2012 18:16:24 -0400
Received: by eaac1 with SMTP id c1so200706eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Aug 2012 15:16:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, sage@inktank.com, walken@google.com


The patch titled
     Subject: rbtree-empty-nodes-have-no-color-fix
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
Subject: rbtree-empty-nodes-have-no-color-fix

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/ceph/osd_client.c: In function 'ceph_osdc_alloc_request':
net/ceph/osd_client.c:216:2: error: implicit declaration of function 'rb_in=
it_node' [-Werror=3Dimplicit-function-declaration]

Caused by commit 753b960e52b7 ("rbtree: empty nodes have no color") from
the akpm tree interacting with commit cd43045c2de6 ("libceph: initialize
rb, list nodes in ceph_osd_request") from the ceph tree.

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

linux-next.patch
rbtree-empty-nodes-have-no-color-fix.patch

