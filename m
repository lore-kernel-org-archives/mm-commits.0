From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:26 -0700
Message-ID: <200707172304.l6HN4Qxd011802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934853AbXGQXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: fix NFSv4 filehandle size units confusion
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: fix NFSv4 filehandle size units confusion
From: "J. Bruce Fields" <bfields@fieldses.org>

NFS4_FHSIZE is measured in bytes, not 4-byte words, so much more space than
necessary is being allocated for struct nfs4_cb_recall.

I should have wondered why this structure was so much larger than it needed to
be!

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nfsd/state.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/nfsd/state.h~knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion include/linux/nfsd/state.h
--- a/include/linux/nfsd/state.h~knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion
+++ a/include/linux/nfsd/state.h
@@ -67,7 +67,7 @@ struct nfs4_cb_recall {
 	int			cbr_trunc;
 	stateid_t		cbr_stateid;
 	u32			cbr_fhlen;
-	u32			cbr_fhval[NFS4_FHSIZE];
+	char			cbr_fhval[NFS4_FHSIZE];
 	struct nfs4_delegation	*cbr_dp;
 };
 
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
git-vfs-lease-api.patch
