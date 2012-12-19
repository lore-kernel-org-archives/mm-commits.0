From: akpm@linux-foundation.org
Subject: [merged] ceph-fix-dentry-reference-leak-in-ceph_encode_fh.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:27 -0800
Message-ID: <20121219203928.3DF29200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:64942 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab2LSUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:30 -0500
Received: by mail-bk0-f73.google.com with SMTP id jf3so133759bkc.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tipecaml@gmail.com, sage@inktank.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ceph: fix dentry reference leak in ceph_encode_fh()
has been removed from the -mm tree.  Its filename was
     ceph-fix-dentry-reference-leak-in-ceph_encode_fh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyril Roelandt <tipecaml@gmail.com>
Subject: ceph: fix dentry reference leak in ceph_encode_fh()

dput() was not called in the error path.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
Cc: Sage Weil <sage@inktank.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/export.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ceph/export.c~ceph-fix-dentry-reference-leak-in-ceph_encode_fh fs/ceph/export.c
--- a/fs/ceph/export.c~ceph-fix-dentry-reference-leak-in-ceph_encode_fh
+++ a/fs/ceph/export.c
@@ -56,13 +56,15 @@ static int ceph_encode_fh(struct inode *
 	struct ceph_nfs_confh *cfh = (void *)rawfh;
 	int connected_handle_length = sizeof(*cfh)/4;
 	int handle_length = sizeof(*fh)/4;
-	struct dentry *dentry = d_find_alias(inode);
+	struct dentry *dentry;
 	struct dentry *parent;
 
 	/* don't re-export snaps */
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EINVAL;
 
+	dentry = d_find_alias(inode);
+
 	/* if we found an alias, generate a connectable fh */
 	if (*max_len >= connected_handle_length && dentry) {
 		dout("encode_fh %p connectable\n", dentry);
_

Patches currently in -mm which might be from tipecaml@gmail.com are

origin.patch

