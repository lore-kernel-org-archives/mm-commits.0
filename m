From: akpm@linux-foundation.org
Subject: + fs-ufs-superc-remove-unnecessary-casting.patch added to -mm
 tree
Date: Fri, 02 Jan 2015 14:20:43 -0800
Message-ID: <54a719bb.erJGfzm+iW497SXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbABWUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/super.c: remove unnecessary casting
has been added to the -mm tree.  Its filename is
     fs-ufs-superc-remove-unnecessary-casting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-superc-remove-unnecessary-casting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-superc-remove-unnecessary-casting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/super.c: remove unnecessary casting

Fix the following coccinelle warning:
fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
allocation function to (struct ufs_inode_info *) is useless.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-remove-unnecessary-casting fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-remove-unnecessary-casting
+++ a/fs/ufs/super.c
@@ -1415,9 +1415,11 @@ static struct kmem_cache * ufs_inode_cac
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
 	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
+
+	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
+
 	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
fs-ufs-superc-remove-unnecessary-casting.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
linux-next.patch

