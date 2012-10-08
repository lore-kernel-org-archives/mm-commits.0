From: akpm@linux-foundation.org
Subject: [folded-dropped] rbtree-empty-nodes-have-no-color-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:05:04 -0700
Message-ID: <20121008230505.87E7920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40356 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2JHXFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:05:07 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so294836wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:05:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, sage@inktank.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree-empty-nodes-have-no-color-fix
has been removed from the -mm tree.  Its filename was
     rbtree-empty-nodes-have-no-color-fix.patch

This patch was dropped because it was folded into rbtree-empty-nodes-have-no-color.patch

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
@@ -221,7 +221,6 @@ struct ceph_osd_request *ceph_osdc_alloc
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
rbtree-empty-nodes-have-no-color.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch

