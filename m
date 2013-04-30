From: akpm@linux-foundation.org
Subject: [merged] nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:08 -0700
Message-ID: <20130430190208.7936A5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:53635 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab3D3TCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:09 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88934qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nfsd: convert nfs4_alloc_stid() to use idr_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: nfsd: convert nfs4_alloc_stid() to use idr_alloc_cyclic()

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic
+++ a/fs/nfsd/nfs4state.c
@@ -326,7 +326,6 @@ static struct nfs4_stid *nfs4_alloc_stid
 kmem_cache *slab)
 {
 	struct idr *stateids = &cl->cl_stateids;
-	static int min_stateid = 0;
 	struct nfs4_stid *stid;
 	int new_id;
 
@@ -334,7 +333,7 @@ kmem_cache *slab)
 	if (!stid)
 		return NULL;
 
-	new_id = idr_alloc(stateids, stid, min_stateid, 0, GFP_KERNEL);
+	new_id = idr_alloc_cyclic(stateids, stid, 0, 0, GFP_KERNEL);
 	if (new_id < 0)
 		goto out_free;
 	stid->sc_client = cl;
@@ -353,10 +352,6 @@ kmem_cache *slab)
 	 * amount of time until an id is reused, by ensuring they always
 	 * "increase" (mod INT_MAX):
 	 */
