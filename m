From: akpm@linux-foundation.org
Subject: + fix-for-ext2-reservation.patch added to -mm tree
Date: Thu, 12 Jul 2007 14:09:05 -0700
Message-ID: <200707122109.l6CL95xE003339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933798AbXGLVJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 17:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, cmm@us.ibm.com, hugh@veritas.com, mbligh@mbligh.org, val@nmt.edu


The patch titled
     Fix for ext2 reservation
has been added to the -mm tree.  Its filename is
     fix-for-ext2-reservation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix for ext2 reservation
From: Badari Pulavarty <pbadari@us.ibm.com>

Alexey Dobriyan reported ext2 discard reservation panic while ago
(http://lkml.org/lkml/2007/3/2/138).  If ext2_new_inode() fails for any
reason it would end up calling ext2_discard_reservation() (due to last
iput).  Normally, it does nothing since we don't have a reservation window
structure allocated.  But the NULL pointer check wouldn't work with slab
poisioning, and causes oops.

Fix is to initialize i_block_alloc_info to NULL in ext2_alloc_inode()
code instead of assuming that it would be NULL. Same fix already
exists in ext3 and ext4.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: Valerie Henson <val@nmt.edu>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/ext2/super.c~fix-for-ext2-reservation fs/ext2/super.c
--- a/fs/ext2/super.c~fix-for-ext2-reservation
+++ a/fs/ext2/super.c
@@ -147,6 +147,7 @@ static struct inode *ext2_alloc_inode(st
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
+	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
mm-fix-create_new_namespaces-return-value.patch
ext2-statfs-speed-up.patch
ext3-statfs-speed-up.patch
ext4-statfs-speed-up.patch
fix-for-ext2-reservation.patch
