From: akpm@osdl.org
Subject: - nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:01 -0800
Message-ID: <200612082011.kB8KB1iw002870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58982 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946562AbWLHULG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     NFS2: Calculate 'w' a bit later in nfsaclsvc_encode_getaclres()
has been removed from the -mm tree.  Its filename was
     nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NFS2: Calculate 'w' a bit later in nfsaclsvc_encode_getaclres()
From: Jesper Juhl <jesper.juhl@gmail.com>

NFS2: Calculate 'w' a bit later in nfsaclsvc_encode_getaclres()
      This is a small performance optimization since we can return before
      needing 'w'. It also saves a few bytes of .text :
      Before:
           text    data     bss     dec     hex filename
           2406     212       0    2618     a3a fs/nfsd/nfs2acl.o
      After:
           text    data     bss     dec     hex filename
           2400     212       0    2612     a34 fs/nfsd/nfs2acl.o

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs2acl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/nfsd/nfs2acl.c~nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres fs/nfsd/nfs2acl.c
--- a/fs/nfsd/nfs2acl.c~nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres
+++ a/fs/nfsd/nfs2acl.c
@@ -222,12 +222,10 @@ static int nfsaclsvc_encode_getaclres(st
 {
 	struct dentry *dentry = resp->fh.fh_dentry;
 	struct inode *inode = dentry->d_inode;
-	int w = nfsacl_size(
-		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
-		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 	struct kvec *head = rqstp->rq_res.head;
 	unsigned int base;
 	int n;
+	int w;
 
 	if (dentry == NULL || dentry->d_inode == NULL)
 		return 0;
@@ -239,7 +237,9 @@ static int nfsaclsvc_encode_getaclres(st
 		return 0;
 	base = (char *)p - (char *)head->iov_base;
 
-	rqstp->rq_res.page_len = w;
+	rqstp->rq_res.page_len = w = nfsacl_size(
+		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
+		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 	while (w > 0) {
 		if (!rqstp->rq_respages[rqstp->rq_resused++])
 			return 0;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch
nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
git-acpi.patch
nfs-kill-obsolete-nfs_paranoia.patch
be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev.patch
debug-shared-irqs.patch

