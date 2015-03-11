From: akpm@linux-foundation.org
Subject: + ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch added to -mm tree
Date: Wed, 11 Mar 2015 15:20:50 -0700
Message-ID: <5500bfc2.tjqcS8PfbnHh5psp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbbCKWUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dereferencing freed pointers in ocfs2_reflink()
has been added to the -mm tree.  Its filename is
     ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch
paride-fix-the-verbose-module-param.patch
hfsplus-add-missing-curly-braces-in-hfsplus_delete_cat.patch
memstick-mspro_block-add-missing-curly-braces.patch
linux-next.patch

