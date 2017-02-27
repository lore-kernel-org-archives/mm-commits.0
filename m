From: akpm@linux-foundation.org
Subject: [patch 08/78] autofs: fix wrong ioctl documentation regarding
 devid
Date: Mon, 27 Feb 2017 14:27:05 -0800
Message-ID: <58b4a7b9.hcFClPj6MIMhI2df%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbdB0W3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tkusumi@tuxera.com, raven@themaw.net

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
