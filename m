From: akpm@linux-foundation.org
Subject: [merged]
 autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:49:48 -0800
Message-ID: <58b5e26c.NDcSLdL86VhIpn+w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: update ioctl documentation regarding struct autofs_dev_ioctl
has been removed from the -mm tree.  Its filename was
     autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: update ioctl documentation regarding struct autofs_dev_ioctl

This is the same as bf72eda5 except that it's a different file.  Sync
documentation with changes made by 730c9eec in 2009.

Link: http://lkml.kernel.org/r/148577165630.9801.6081791213151121657.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/autofs4-mount-control.txt |    1 
 Documentation/filesystems/autofs4.txt               |   32 ++++++----
 2 files changed, 22 insertions(+), 11 deletions(-)

diff -puN Documentation/filesystems/autofs4-mount-control.txt~autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl Documentation/filesystems/autofs4-mount-control.txt
--- a/Documentation/filesystems/autofs4-mount-control.txt~autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl
+++ a/Documentation/filesystems/autofs4-mount-control.txt
@@ -179,6 +179,7 @@ struct autofs_dev_ioctl {
 				 * including this struct */
 	__s32 ioctlfd;          /* automount command fd */
 
+	/* Command parameters */
 	union {
 		struct args_protover		protover;
 		struct args_protosubver		protosubver;
diff -puN Documentation/filesystems/autofs4.txt~autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl Documentation/filesystems/autofs4.txt
--- a/Documentation/filesystems/autofs4.txt~autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl
+++ a/Documentation/filesystems/autofs4.txt
@@ -425,8 +425,20 @@ Each ioctl is passed a pointer to an `au
                                          * including this struct */
                 __s32 ioctlfd;          /* automount command fd */
 
-                __u32 arg1;             /* Command parameters */
-                __u32 arg2;
+		/* Command parameters */
+		union {
+			struct args_protover		protover;
+			struct args_protosubver		protosubver;
+			struct args_openmount		openmount;
+			struct args_ready		ready;
+			struct args_fail		fail;
+			struct args_setpipefd		setpipefd;
+			struct args_timeout		timeout;
+			struct args_requester		requester;
+			struct args_expire		expire;
+			struct args_askumount		askumount;
+			struct args_ismountpoint	ismountpoint;
+		};
 
                 char path[0];
         };
@@ -446,24 +458,22 @@ Commands are:
     set version numbers.
 - **AUTOFS_DEV_IOCTL_OPENMOUNT_CMD**: return an open file descriptor
     on the root of an autofs filesystem.  The filesystem is identified
-    by name and device number, which is stored in `arg1`.  Device
-    numbers for existing filesystems can be found in
+    by name and device number, which is stored in `openmount.devid`.
+    Device numbers for existing filesystems can be found in
     `/proc/self/mountinfo`.
 - **AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD**: same as `close(ioctlfd)`.
 - **AUTOFS_DEV_IOCTL_SETPIPEFD_CMD**: if the filesystem is in
     catatonic mode, this can provide the write end of a new pipe
-    in `arg1` to re-establish communication with a daemon.  The
-    process group of the calling process is used to identify the
+    in `setpipefd.pipefd` to re-establish communication with a daemon.
+    The process group of the calling process is used to identify the
     daemon.
 - **AUTOFS_DEV_IOCTL_REQUESTER_CMD**: `path` should be a
     name within the filesystem that has been auto-mounted on.
-    On successful return, `arg1` and `arg2` will be the UID and GID
-    of the process which triggered that mount.
-
+    On successful return, `requester.uid` and `requester.gid` will be
+    the UID and GID of the process which triggered that mount.
 - **AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD**: Check if path is a
     mountpoint of a particular type - see separate documentation for
     details.
