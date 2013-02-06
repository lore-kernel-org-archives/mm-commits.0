From: akpm@linux-foundation.org
Subject: + nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:37:31 -0800
Message-ID: <20130206232913.EAA475A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:45350 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3BFX3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 18:29:14 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so215669ghb.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 15:29:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, tj@kernel.org


The patch titled
     
has been added to the -mm tree.  Its filename is
     nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Subject: nfsd: idr_destroy() no longer needs idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop reference to idr_remove_all().

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-idr_destroy-no-longer-needs-idr_remove_all fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-idr_destroy-no-longer-needs-idr_remove_all
+++ a/fs/nfsd/nfs4state.c
@@ -1060,7 +1060,6 @@ free_client(struct nfs4_client *clp)
 	}
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
-	idr_remove_all(&clp->cl_stateids);
 	idr_destroy(&clp->cl_stateids);
 	kfree(clp);
 }
_

Patches currently in -mm which might be from bfields@fieldses.org are

linux-next.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

