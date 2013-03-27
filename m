From: akpm@linux-foundation.org
Subject: + nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:22:17 -0700
Message-ID: <20130327202217.CD6A55A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63722 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3C0UWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:22:19 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so868948vcb.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:22:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, tj@kernel.org


The patch titled
     Subject: nfsd: convert nfs4_alloc_stid() to use idr_alloc_cyclic()
has been added to the -mm tree.  Its filename is
     nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: nfsd: convert nfs4_alloc_stid() to use idr_alloc_cyclic()

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic
+++ a/fs/nfsd/nfs4state.c
@@ -234,7 +234,6 @@ static struct nfs4_stid *nfs4_alloc_stid
 kmem_cache *slab)
 {
 	struct idr *stateids = &cl->cl_stateids;
-	static int min_stateid = 0;
 	struct nfs4_stid *stid;
 	int new_id;
 
@@ -242,7 +241,7 @@ kmem_cache *slab)
 	if (!stid)
 		return NULL;
 
-	new_id = idr_alloc(stateids, stid, min_stateid, 0, GFP_KERNEL);
+	new_id = idr_alloc_cyclic(stateids, stid, 0, 0, GFP_KERNEL);
 	if (new_id < 0)
 		goto out_free;
 	stid->sc_client = cl;
@@ -261,10 +260,6 @@ kmem_cache *slab)
 	 * amount of time until an id is reused, by ensuring they always
 	 * "increase" (mod INT_MAX):
 	 */
