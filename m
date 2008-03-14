From: akpm@linux-foundation.org
Subject: + struct-export_operations-adjust-comments-to-match-current-members.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:05:38 -0700
Message-ID: <200803142005.m2EK5dgM017019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759461AbYCNUGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:06:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marc.c.dionne@gmail.com, dhowells@redhat.com, hch@lst.de


The patch titled
     struct export_operations: adjust comments to match current members
has been added to the -mm tree.  Its filename is
     struct-export_operations-adjust-comments-to-match-current-members.patch

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
Subject: struct export_operations: adjust comments to match current members
From: "Marc Dionne" <marc.c.dionne@gmail.com>

The comments in the definition of struct export_operations don't match the
current members.

Add a comment for the 2 new functions and remove 2 comments for unused ones.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/exportfs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/exportfs.h~struct-export_operations-adjust-comments-to-match-current-members include/linux/exportfs.h
--- a/include/linux/exportfs.h~struct-export_operations-adjust-comments-to-match-current-members
+++ a/include/linux/exportfs.h
@@ -49,11 +49,11 @@ struct fid {
 
 /**
  * struct export_operations - for nfsd to communicate with file systems
- * @decode_fh:      decode a file handle fragment and return a &struct dentry
  * @encode_fh:      encode a file handle fragment from a dentry
+ * @fh_to_dentry:   find the implied object and get a dentry for it
+ * @fh_to_parent:   find the implied object's parent and get a dentry for it
  * @get_name:       find the name for a given inode in a given directory
  * @get_parent:     find the parent of a given directory
- * @get_dentry:     find a dentry for the inode given a file handle sub-fragment
  *
  * See Documentation/filesystems/Exporting for details on how to use
  * this interface correctly.
_

Patches currently in -mm which might be from marc.c.dionne@gmail.com are

struct-export_operations-adjust-comments-to-match-current-members.patch

