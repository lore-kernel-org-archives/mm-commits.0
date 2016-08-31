From: akpm@linux-foundation.org
Subject: + autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl.patch added to -mm tree
Date: Wed, 31 Aug 2016 14:14:54 -0700
Message-ID: <57c748ce.Hb9+Eao2ZEc/iCuc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbcHaVOz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 17:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: refactor ioctl fn vector in iookup_dev_ioctl()
has been added to the -mm tree.  Its filename is
     autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are

autofs-fix-typos-in-documentation-filesystems-autofs4txt.patch
autofs-drop-unnecessary-extern-in-autofs_ih.patch
autofs-test-autofs-versions-first-on-sb-initialization.patch
autofs-add-warn_on1-for-non-dir-link-inode-case.patch
autofs-use-autofs4_free_ino-to-kfree-dentry-data.patch
autofs-remove-obsolete-sb-fields.patch
autofs-dont-fail-to-free_dev_ioctlparam.patch
autofs-remove-autofs_devid_len.patch
autofs-fix-documentation-regarding-devid-on-ioctl.patch
autofs-update-struct-autofs_dev_ioctl-in-documentation.patch
autofs-fix-pr_debug-message.patch
autofs-fix-dev-ioctl-number-range-check-fix.patch
autofs-fix-print-format-for-ioctl-warning-message.patch
autofs-move-inclusion-of-linux-limitsh-to-uapi.patch
autofs-remove-possibly-misleading-define-debug.patch
autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl.patch

