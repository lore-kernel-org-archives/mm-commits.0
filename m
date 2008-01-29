From: akpm@linux-foundation.org
Subject: + fuse-fix-attribute-caching-after-create.patch added to -mm tree
Date: Tue, 29 Jan 2008 12:31:44 -0800
Message-ID: <200801292031.m0TKVn9p003148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYA2UcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 15:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix attribute caching after create
has been added to the -mm tree.  Its filename is
     fuse-fix-attribute-caching-after-create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix attribute caching after create
From: Miklos Szeredi <mszeredi@suse.cz>

Invalidate attributes on create, since st_ctime is updated.  Reported by
Szabolcs Szakacsits.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fuse/dir.c~fuse-fix-attribute-caching-after-create fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-attribute-caching-after-create
+++ a/fs/fuse/dir.c
@@ -416,6 +416,7 @@ static int fuse_create_open(struct inode
 	fuse_put_request(fc, forget_req);
 	d_instantiate(entry, inode);
 	fuse_change_entry_timeout(entry, &outentry);
+	fuse_invalidate_attr(dir);
 	file = lookup_instantiate_filp(nd, entry, generic_file_open);
 	if (IS_ERR(file)) {
 		ff->fh = outopen.fh;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
