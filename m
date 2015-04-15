From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:08:16 -0700
Message-ID: <552eb720.HMqdZnx31DxV6jPN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbDOTIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dereferencing freed pointers in ocfs2_reflink()
has been removed from the -mm tree.  Its filename was
     ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: dereferencing freed pointers in ocfs2_reflink()

The code at the "out" label assumes that "default_acl" and "acl" are NULL,
but actually the pointers can be NULL, unitialized, or freed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink
+++ a/fs/ocfs2/refcounttree.c
@@ -4276,7 +4276,7 @@ static int ocfs2_reflink(struct dentry *
 	error = posix_acl_create(dir, &mode, &default_acl, &acl);
 	if (error) {
 		mlog_errno(error);
-		goto out;
+		return error;
 	}
 
 	error = ocfs2_create_inode_in_orphan(dir, mode,
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
posix_acl-make-posix_acl_create-safer-and-cleaner.patch
paride-fix-the-verbose-module-param.patch
nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch
hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch

