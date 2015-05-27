From: akpm@linux-foundation.org
Subject: + nilfs2-support-nfsv2-export.patch added to -mm tree
Date: Wed, 27 May 2015 14:09:17 -0700
Message-ID: <5566327d.jx+KL/Aspzd5kIWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbE0VJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 17:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: NILFS2: support NFSv2 export
has been added to the -mm tree.  Its filename is
     nilfs2-support-nfsv2-export.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-support-nfsv2-export.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-support-nfsv2-export.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-support-nfsv2-export.patch
linux-next.patch

