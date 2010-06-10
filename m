From: akpm@linux-foundation.org
Subject: + blkdev-cgroup-whitelist-permission-fix.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:36:44 -0700
Message-ID: <201006102036.o5AKai6s022360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283Ab0FJUhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, berrange@redhat.com, hch@infradead.org, serue@us.ibm.com, vgoyal@redhat.com, viro@ZenIV.linux.org.uk


The patch titled
     blkdev: cgroup whitelist permission fix
has been added to the -mm tree.  Its filename is
     blkdev-cgroup-whitelist-permission-fix.patch

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
Subject: blkdev: cgroup whitelist permission fix
From: Chris Wright <chrisw@sous-sol.org>

The cgroup device whitelist code gets confused when trying to grant
permission to a disk partition that is not currently open.  Part of
blkdev_open() includes __blkdev_get() on the whole disk.  This simply
avoids the cgroup check for the whole disk case when opening a partition.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=589662

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/block_dev.c~blkdev-cgroup-whitelist-permission-fix fs/block_dev.c
--- a/fs/block_dev.c~blkdev-cgroup-whitelist-permission-fix
+++ a/fs/block_dev.c
@@ -1356,10 +1356,12 @@ static int __blkdev_get(struct block_dev
 	/*
 	 * hooks: /n/, see "layering violations".
 	 */
-	ret = devcgroup_inode_permission(bdev->bd_inode, perm);
-	if (ret != 0) {
-		bdput(bdev);
-		return ret;
+	if (!for_part) {
+		ret = devcgroup_inode_permission(bdev->bd_inode, perm);
+		if (ret != 0) {
+			bdput(bdev);
+			return ret;
+		}
 	}
 
 	lock_kernel();
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

blkdev-cgroup-whitelist-permission-fix.patch

