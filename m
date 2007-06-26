From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:21 -0700
Message-ID: <200706260346.l5Q3kL7e017623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbXFZDqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: fix NFSv4 filehandle size units confusion
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
