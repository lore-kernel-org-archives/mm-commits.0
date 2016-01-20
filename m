From: akpm@linux-foundation.org
Subject: + reiserfs-fix-dereference-of-err_ptr.patch added to -mm tree
Date: Wed, 20 Jan 2016 12:57:49 -0800
Message-ID: <569ff4cd.bsYafFQ6UzDjrgUT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbcATU5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 15:57:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: fix dereference of ERR_PTR
has been added to the -mm tree.  Its filename is
     reiserfs-fix-dereference-of-err_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reiserfs-fix-dereference-of-err_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reiserfs-fix-dereference-of-err_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: reiserfs: fix dereference of ERR_PTR

reiserfs_iget() returns either NULL or error code in ERR_PTR.  And we were
only checking for NULL, so in case of some other error we will try to
dereference the ERR_PTR(-errno) thinking it to be a valid pointer.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~reiserfs-fix-dereference-of-err_ptr fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-fix-dereference-of-err_ptr
+++ a/fs/reiserfs/super.c
@@ -288,7 +288,7 @@ static int finish_unfinished(struct supe
 		pathrelse(&path);
 
 		inode = reiserfs_iget(s, &obj_key);
-		if (!inode) {
+		if (IS_ERR_OR_NULL(inode)) {
 			/*
 			 * the unlink almost completed, it just did not
 			 * manage to remove "save" link and release objectid
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

reiserfs-fix-dereference-of-err_ptr.patch

