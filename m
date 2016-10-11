From: akpm@linux-foundation.org
Subject: [patch 048/102] autofs: refactor ioctl fn vector in
 iookup_dev_ioctl()
Date: Tue, 11 Oct 2016 13:53:19 -0700
Message-ID: <57fd513f.dUhssxiF4oOkp1HL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37983 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbcJKUxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, raven@themaw.net

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: refactor ioctl fn vector in iookup_dev_ioctl()

cmd part of this struct is the same as an index of itself within
_ioctls[]. In fact this cmd is unused, so we can drop this part.

Link: http://lkml.kernel.org/r/20160831033414.9910.66697.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |   49 ++++++++++++---------------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl
+++ a/fs/autofs4/dev-ioctl.c
@@ -597,42 +597,25 @@ out:
 
 static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
 {
-	static struct {
-		int cmd;
-		ioctl_fn fn;
-	} _ioctls[] = {
-		{cmd_idx(AUTOFS_DEV_IOCTL_VERSION_CMD),
-			 autofs_dev_ioctl_version},
-		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOVER_CMD),
-			 autofs_dev_ioctl_protover},
-		{cmd_idx(AUTOFS_DEV_IOCTL_PROTOSUBVER_CMD),
-			 autofs_dev_ioctl_protosubver},
-		{cmd_idx(AUTOFS_DEV_IOCTL_OPENMOUNT_CMD),
-			 autofs_dev_ioctl_openmount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_CLOSEMOUNT_CMD),
-			 autofs_dev_ioctl_closemount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_READY_CMD),
-			 autofs_dev_ioctl_ready},
-		{cmd_idx(AUTOFS_DEV_IOCTL_FAIL_CMD),
-			 autofs_dev_ioctl_fail},
-		{cmd_idx(AUTOFS_DEV_IOCTL_SETPIPEFD_CMD),
-			 autofs_dev_ioctl_setpipefd},
-		{cmd_idx(AUTOFS_DEV_IOCTL_CATATONIC_CMD),
-			 autofs_dev_ioctl_catatonic},
-		{cmd_idx(AUTOFS_DEV_IOCTL_TIMEOUT_CMD),
-			 autofs_dev_ioctl_timeout},
-		{cmd_idx(AUTOFS_DEV_IOCTL_REQUESTER_CMD),
-			 autofs_dev_ioctl_requester},
-		{cmd_idx(AUTOFS_DEV_IOCTL_EXPIRE_CMD),
-			 autofs_dev_ioctl_expire},
-		{cmd_idx(AUTOFS_DEV_IOCTL_ASKUMOUNT_CMD),
-			 autofs_dev_ioctl_askumount},
-		{cmd_idx(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD),
-			 autofs_dev_ioctl_ismountpoint}
+	static ioctl_fn _ioctls[] = {
+		autofs_dev_ioctl_version,
+		autofs_dev_ioctl_protover,
+		autofs_dev_ioctl_protosubver,
+		autofs_dev_ioctl_openmount,
+		autofs_dev_ioctl_closemount,
+		autofs_dev_ioctl_ready,
+		autofs_dev_ioctl_fail,
+		autofs_dev_ioctl_setpipefd,
+		autofs_dev_ioctl_catatonic,
+		autofs_dev_ioctl_timeout,
+		autofs_dev_ioctl_requester,
+		autofs_dev_ioctl_expire,
+		autofs_dev_ioctl_askumount,
+		autofs_dev_ioctl_ismountpoint,
 	};
 	unsigned int idx = cmd_idx(cmd);
 
-	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx].fn;
+	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx];
 }
 
 /* ioctl dispatcher */
_
