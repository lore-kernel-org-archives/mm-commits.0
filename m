From: akpm@linux-foundation.org
Subject: + autofs-fix-wrong-ioctl-documentation-regarding-devid.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 15:47:58 -0800
Message-ID: <5891222e.r7RVMLji8Jrrpyc/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdAaX5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 18:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix wrong ioctl documentation regarding devid
has been added to the -mm tree.  Its filename is
     autofs-fix-wrong-ioctl-documentation-regarding-devid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-wrong-ioctl-documentation-regarding-devid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-wrong-ioctl-documentation-regarding-devid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: fix wrong ioctl documentation regarding devid

This is the same as d8732841 except that it's a different file.  A caller
has no devid input, and devid is obtained via superblock.

Link: http://lkml.kernel.org/r/148577165119.9801.16967562019122274820.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/autofs4.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/autofs4.txt~autofs-fix-wrong-ioctl-documentation-regarding-devid Documentation/filesystems/autofs4.txt
--- a/Documentation/filesystems/autofs4.txt~autofs-fix-wrong-ioctl-documentation-regarding-devid
+++ a/Documentation/filesystems/autofs4.txt
@@ -457,9 +457,8 @@ Commands are:
     daemon.
 - **AUTOFS_DEV_IOCTL_REQUESTER_CMD**: `path` should be a
     name within the filesystem that has been auto-mounted on.
-    arg1 is the dev number of the underlying autofs.  On successful
-    return, `arg1` and `arg2` will be the UID and GID of the process
-    which triggered that mount.
+    On successful return, `arg1` and `arg2` will be the UID and GID
+    of the process which triggered that mount.
 
 - **AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD**: Check if path is a
     mountpoint of a particular type - see separate documentation for
_

Patches currently in -mm which might be from tkusumi@tuxera.com are

autofs-remove-wrong-comment.patch
autofs-fix-typo-in-documentation.patch
autofs-fix-wrong-ioctl-documentation-regarding-devid.patch
autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl.patch
autofs-add-command-enum-macros-for-root-dir-ioctls.patch
autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

