From: akpm@linux-foundation.org
Subject: [merged] autofs-fix-documentation-regarding-devid-on-ioctl.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:55 -0700
Message-ID: <57fe8dcb.7frUy2FneKMntZwj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756021AbcJLTYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix Documentation regarding devid on ioctl
has been removed from the -mm tree.  Its filename was
     autofs-fix-documentation-regarding-devid-on-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: fix Documentation regarding devid on ioctl

The explanation on how ioctl handles devid seems incorrect.  Userspace who
calls this ioctl has no input regarding devid, and ioctl implementation
retrieves devid via superblock.

Link: http://lkml.kernel.org/r/20160812024825.12352.13486.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/autofs4-mount-control.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/autofs4-mount-control.txt~autofs-fix-documentation-regarding-devid-on-ioctl Documentation/filesystems/autofs4-mount-control.txt
--- a/Documentation/filesystems/autofs4-mount-control.txt~autofs-fix-documentation-regarding-devid-on-ioctl
+++ a/Documentation/filesystems/autofs4-mount-control.txt
@@ -323,9 +323,8 @@ mount on the given path dentry.
 
 The call requires an initialized struct autofs_dev_ioctl with the path
 field set to the mount point in question and the size field adjusted
-appropriately as well as the arg1 field set to the device number of the
-containing autofs mount. Upon return the struct field arg1 contains the
-uid and arg2 the gid.
+appropriately. Upon return the struct field arg1 contains the uid and
+arg2 the gid.
 
 When reconstructing an autofs mount tree with active mounts we need to
 re-connect to mounts that may have used the original process uid and
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


