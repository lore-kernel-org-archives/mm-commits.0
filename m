From: akpm@osdl.org
Subject: - nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:03 -0800
Message-ID: <200612082011.kB8KB3el002873@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946568AbWLHULJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     NFS3: Calculate 'w' a bit later in nfs3svc_encode_getaclres()
has been removed from the -mm tree.  Its filename was
     nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NFS3: Calculate 'w' a bit later in nfs3svc_encode_getaclres()
From: Jesper Juhl <jesper.juhl@gmail.com>

NFS3: Calculate 'w' a bit later in nfs3svc_encode_getaclres()
      This is a small performance optimization since we can return before
      needing 'w'. It also saves a few bytes of .text :
      Before:
           text    data     bss     dec     hex filename
           1632     140       0    1772     6ec fs/nfsd/nfs3acl.o
      After:
           text    data     bss     dec     hex filename
           1624     140       0    1764     6e4 fs/nfsd/nfs3acl.o

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs3acl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/nfs3acl.c~nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres fs/nfsd/nfs3acl.c
--- a/fs/nfsd/nfs3acl.c~nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres
+++ a/fs/nfsd/nfs3acl.c
@@ -171,19 +171,19 @@ static int nfs3svc_encode_getaclres(stru
 	p = nfs3svc_encode_post_op_attr(rqstp, p, &resp->fh);
 	if (resp->status == 0 && dentry && dentry->d_inode) {
 		struct inode *inode = dentry->d_inode;
-		int w = nfsacl_size(
-			(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
-			(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 		struct kvec *head = rqstp->rq_res.head;
 		unsigned int base;
 		int n;
+		int w;
 
 		*p++ = htonl(resp->mask);
 		if (!xdr_ressize_check(rqstp, p))
 			return 0;
 		base = (char *)p - (char *)head->iov_base;
 
-		rqstp->rq_res.page_len = w;
+		rqstp->rq_res.page_len = w = nfsacl_size(
+			(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
+			(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 		while (w > 0) {
 			if (!rqstp->rq_respages[rqstp->rq_resused++])
 				return 0;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
git-acpi.patch
nfs-kill-obsolete-nfs_paranoia.patch
be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev.patch
debug-shared-irqs.patch

