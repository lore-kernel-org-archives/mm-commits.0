From: akpm@linux-foundation.org
Subject: + __generic_block_fiemap-fix-for-files-bigger-than-4gb.patch added to -mm tree
Date: Wed, 28 Oct 2009 23:01:17 -0700
Message-ID: <200910290601.n9T61HVS026509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361AbZJ2GBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Oct 2009 02:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mh@glandium.org, jbacik@redhat.com, mfasheh@suse.com, sandeen@sgi.com, swhiteho@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     __generic_block_fiemap(): fix for files bigger than 4GB
has been added to the -mm tree.  Its filename is
     __generic_block_fiemap-fix-for-files-bigger-than-4gb.patch

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
Subject: __generic_block_fiemap(): fix for files bigger than 4GB
From: Mike Hommey <mh@glandium.org>

Because of an integer overflow on start_blk, various kind of wrong results
would be returned by the generic_block_fiemap() handler, such as no
extents when there is a 4GB+ hole at the beginning of the file, or wrong
fe_logical when an extent starts after the first 4GB.

Signed-off-by: Mike Hommey <mh@glandium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@sgi.com>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ioctl.c~__generic_block_fiemap-fix-for-files-bigger-than-4gb fs/ioctl.c
--- a/fs/ioctl.c~__generic_block_fiemap-fix-for-files-bigger-than-4gb
+++ a/fs/ioctl.c
@@ -254,7 +254,7 @@ int __generic_block_fiemap(struct inode 
 			   u64 len, get_block_t *get_block)
 {
 	struct buffer_head tmp;
-	unsigned int start_blk;
+	unsigned long long start_blk;
 	long long length = 0, map_len = 0;
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = FIEMAP_EXTENT_MERGED;
_

Patches currently in -mm which might be from mh@glandium.org are

__generic_block_fiemap-fix-for-files-bigger-than-4gb.patch

