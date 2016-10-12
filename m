From: akpm@linux-foundation.org
Subject: [merged]
 autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:24:03 -0700
Message-ID: <57fe8dd3.OFN6KmyZJ1ptLgOW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33273 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755921AbcJLTYh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ikent@redhat.com, kusumi.tomohiro@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: add autofs_dev_ioctl_version() for AUTOFS_DEV_IOCTL_VERSION_CMD
has been removed from the -mm tree.  Its filename was
     autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: add autofs_dev_ioctl_version() for AUTOFS_DEV_IOCTL_VERSION_CMD

No functional changes, based on the following justification.

1. Make the code more consistent using the ioctl vector _ioctls[],
   rather than assigning NULL only for this ioctl command.
2. Remove goto done; for better maintainability in the long run.
3. The existing code is based on the fact that validate_dev_ioctl()
   sets ioctl version for any command, but AUTOFS_DEV_IOCTL_VERSION_CMD
   should explicitly set it regardless of the default behavior.

Link: http://lkml.kernel.org/r/20160812024846.12352.9885.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd
+++ a/fs/autofs4/dev-ioctl.c
@@ -172,6 +172,17 @@ static struct autofs_sb_info *autofs_dev
 	return sbi;
 }
 
+/* Return autofs dev ioctl version */
+static int autofs_dev_ioctl_version(struct file *fp,
+				    struct autofs_sb_info *sbi,
+				    struct autofs_dev_ioctl *param)
+{
+	/* This should have already been set. */
+	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
+	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
+	return 0;
+}
+
 /* Return autofs module protocol version */
 static int autofs_dev_ioctl_protover(struct file *fp,
 				     struct autofs_sb_info *sbi,
@@ -590,7 +601,8 @@ static ioctl_fn lookup_dev_ioctl(unsigne
 		int cmd;
 		ioctl_fn fn;
 	} _ioctls[] = {
-		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD), NULL},
+		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD),
+			 autofs_dev_ioctl_version},
 		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD),
 			 autofs_dev_ioctl_protover},
 		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD),
@@ -655,10 +667,6 @@ static int _autofs_dev_ioctl(unsigned in
 	if (err)
 		goto out;
 
-	/* The validate routine above always sets the version */
-	if (cmd == AUTOFS_DEV_IOCTL_VERSION_CMD)
-		goto done;
-
 	fn = lookup_dev_ioctl(cmd);
 	if (!fn) {
 		pr_warn("unknown command 0x%08x\n", command);
@@ -672,9 +680,11 @@ static int _autofs_dev_ioctl(unsigned in
 	/*
 	 * For obvious reasons the openmount can't have a file
 	 * descriptor yet. We don't take a reference to the
-	 * file during close to allow for immediate release.
+	 * file during close to allow for immediate release,
+	 * and the same for retrieving ioctl version.
 	 */
-	if (cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
+	if (cmd != AUTOFS_DEV_IOCTL_VERSION_CMD &&
+	    cmd != AUTOFS_DEV_IOCTL_OPENMOUNT_CMD &&
 	    cmd != AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD) {
 		fp = fget(param->ioctlfd);
 		if (!fp) {
@@ -707,7 +717,6 @@ cont:
 
 	if (fp)
 		fput(fp);
-done:
 	if (err >= 0 && copy_to_user(user, param, AUTOFS_DEV_IOCTL_SIZE))
 		err = -EFAULT;
 out:
_

Patches currently in -mm which might be from raven@themaw.net are


