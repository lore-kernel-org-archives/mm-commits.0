From: akpm@linux-foundation.org
Subject: [merged] nilfs2-support-nfsv2-export.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:49:15 -0700
Message-ID: <5591af4b.bDkJbEOiwLjf8AB/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbbF2UtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: NILFS2: support NFSv2 export
has been removed from the -mm tree.  Its filename was
     nilfs2-support-nfsv2-export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: NILFS2: support NFSv2 export

The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as that
returned by encode_fh - it may be larger.

With NFSv2, the filehandle is fixed length, so it may appear longer than
expected and be zero-padded.

So we must test that fh_len is at least some value, not exactly equal to
it.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/namei.c~nilfs2-support-nfsv2-export fs/nilfs2/namei.c
--- a/fs/nilfs2/namei.c~nilfs2-support-nfsv2-export
+++ a/fs/nilfs2/namei.c
@@ -496,8 +496,7 @@ static struct dentry *nilfs_fh_to_dentry
 {
 	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
 
-	if ((fh_len != NILFS_FID_SIZE_NON_CONNECTABLE &&
-	     fh_len != NILFS_FID_SIZE_CONNECTABLE) ||
+	if (fh_len < NILFS_FID_SIZE_NON_CONNECTABLE ||
 	    (fh_type != FILEID_NILFS_WITH_PARENT &&
 	     fh_type != FILEID_NILFS_WITHOUT_PARENT))
 		return NULL;
@@ -510,7 +509,7 @@ static struct dentry *nilfs_fh_to_parent
 {
 	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
 
-	if (fh_len != NILFS_FID_SIZE_CONNECTABLE ||
+	if (fh_len < NILFS_FID_SIZE_CONNECTABLE ||
 	    fh_type != FILEID_NILFS_WITH_PARENT)
 		return NULL;
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch

