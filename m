From: akpm@linux-foundation.org
Subject: + fs-move-exportfs-since-it-is-not-a-networking-filesystem.patch added to -mm tree
Date: Thu, 21 Oct 2010 16:52:25 -0700
Message-ID: <201010212352.o9LNqPgg012079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab0JUXwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 19:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, aelder@sgi.com, david@fromorbit.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fs: move exportfs since it is not a networking filesystem
has been added to the -mm tree.  Its filename is
     fs-move-exportfs-since-it-is-not-a-networking-filesystem.patch

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
Subject: fs: move exportfs since it is not a networking filesystem
From: Randy Dunlap <randy.dunlap@oracle.com>

Move the EXPORTFS kconfig symbol out of the NETWORK_FILESYSTEMS block
since it provides a library function that can be (and is) used by other
(non-network) filesystems.

This also eliminates a kconfig dependency warning:

warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/Kconfig~fs-move-exportfs-since-it-is-not-a-networking-filesystem fs/Kconfig
--- a/fs/Kconfig~fs-move-exportfs-since-it-is-not-a-networking-filesystem
+++ a/fs/Kconfig
@@ -47,6 +47,9 @@ source "fs/nilfs2/Kconfig"
 
 endif # BLOCK
 
+config EXPORTFS
+	tristate
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EMBEDDED
 	default y
@@ -221,9 +224,6 @@ config LOCKD_V4
 	depends on FILE_LOCKING
 	default y
 
-config EXPORTFS
-	tristate
