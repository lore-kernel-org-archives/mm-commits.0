From: akpm@linux-foundation.org
Subject: [merged] vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:12:41 -0700
Message-ID: <200908202012.n7KKCfbe015355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297AbZHTUNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, rlove@google.com, smfrench@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed
has been removed from the -mm tree.  Its filename was
     vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Robert Love <rlove@google.com>
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
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch

