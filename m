From: akpm@linux-foundation.org
Subject: - fix-for-ext2-reservation.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:49:32 -0700
Message-ID: <200710162249.l9GMnWxA021828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315AbXJPWuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, cmm@us.ibm.com, hugh@veritas.com, mbligh@mbligh.org, val@nmt.edu, mm-commits@vger.kernel.org


The patch titled
     Fix for ext2 reservation
has been removed from the -mm tree.  Its filename was
     fix-for-ext2-reservation.patch

This patch was dropped because it was folded into ext2-reservations.patch

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
 1 file changed, 1 insertion(+)

diff -puN fs/ext2/super.c~fix-for-ext2-reservation fs/ext2/super.c
--- a/fs/ext2/super.c~fix-for-ext2-reservation
+++ a/fs/ext2/super.c
@@ -149,6 +149,7 @@ static struct inode *ext2_alloc_inode(st
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
+	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
aio-account-i-o-wait-time-properly.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch
powerpc-add-scaled-time-accounting-speedup.patch
