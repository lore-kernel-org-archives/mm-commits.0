From: akpm@linux-foundation.org
Subject: + ecryptfs-no-path_release-after-path_lookup-error.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:33:59 -0800
Message-ID: <200702272034.l1RKY3YC027532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbXB0UhQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:37:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dmonakhov@openvz.org


The patch titled
     eCryptfs: no path_release() after path_lookup() error
has been added to the -mm tree.  Its filename is
     ecryptfs-no-path_release-after-path_lookup-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: no path_release() after path_lookup() error
From: Michael Halcrow <mhalcrow@us.ibm.com>

Dmitriy Monakhov wrote:
> if path_lookup() return non zero code we don't have to worry about
> 'nd' parameter, but ecryptfs_read_super does path_release(&nd) after
> path_lookup has failed, and dentry counter becomes negative

Do not do a path_release after a path_lookup error.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-no-path_release-after-path_lookup-error fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-no-path_release-after-path_lookup-error
+++ a/fs/ecryptfs/main.c
@@ -487,7 +487,7 @@ static int ecryptfs_read_super(struct su
 	rc = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
-		goto out_free;
+		goto out;
 	}
 	lower_root = nd.dentry;
 	if (!lower_root->d_inode) {
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-resolve-lower-page-unlocking-problem.patch
ecryptfs-set-o_largefile-when-opening-lower-file.patch
ecryptfs-remove-unnecessary-flush_dcache_page.patch
ecryptfs-no-path_release-after-path_lookup-error.patch
git-unionfs.patch
ecryptfs-handles-aop_truncated_page-better.patch
