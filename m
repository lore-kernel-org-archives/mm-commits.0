From: akpm@linux-foundation.org
Subject: + vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch added to -mm tree
Date: Mon, 10 Aug 2009 21:42:33 -0700
Message-ID: <200908110442.n7B4gXFf005962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbZHKLy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, smfrench@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed
has been added to the -mm tree.  Its filename is
     vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed
From: Jeff Layton <jlayton@redhat.com>
DESC
vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed
DESC

get_sb_pseudo sets s_maxbytes to ~0ULL which becomes negative when cast to
a signed value.  Fix it to use MAX_LFS_FILESIZE which casts properly to a
positive signed value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Steve French <smfrench@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/libfs.c~vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed fs/libfs.c
--- a/fs/libfs.c~vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed
+++ a/fs/libfs.c
@@ -217,7 +217,7 @@ int get_sb_pseudo(struct file_system_typ
 		return PTR_ERR(s);
 
 	s->s_flags = MS_NOUSER;
-	s->s_maxbytes = ~0ULL;
+	s->s_maxbytes = MAX_LFS_FILESIZE;
 	s->s_blocksize = PAGE_SIZE;
 	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch

