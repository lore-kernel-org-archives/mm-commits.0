From: akpm@linux-foundation.org
Subject: + ceph-fix-dentry-reference-leak-in-ceph_encode_fh.patch added to -mm tree
Date: Tue, 20 Nov 2012 15:22:12 -0800
Message-ID: <20121120232213.0600920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46101 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2KTXWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 18:22:15 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so431047wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 15:22:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tipecaml@gmail.com, sage@inktank.com


The patch titled
     Subject: ceph: fix dentry reference leak in ceph_encode_fh()
has been added to the -mm tree.  Its filename is
     ceph-fix-dentry-reference-leak-in-ceph_encode_fh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ceph-fix-dentry-reference-leak-in-ceph_encode_fh.patch
coccinelle-add-api-d_find_aliascocci.patch

