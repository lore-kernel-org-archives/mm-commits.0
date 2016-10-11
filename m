From: akpm@linux-foundation.org
Subject: [folded-merged] autofs-fix-dev-ioctl-number-range-check-fix.patch removed from -mm tree
Date: Tue, 11 Oct 2016 13:36:41 -0700
Message-ID: <57fd4d59.3zA3rhKKyNz1momA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbcJKUgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix "fix dev ioctl number range check"
has been removed from the -mm tree.  Its filename was
     autofs-fix-dev-ioctl-number-range-check-fix.patch

This patch was dropped because it was folded into autofs-fix-dev-ioctl-number-range-check.patch

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: fix "fix dev ioctl number range check"

102a340f had a typo that made the count macro negative (-13).
The acutal check used by ioctl is ((cmd - cmd_first) > COUNT),
so it needs to be positive (13).

* 102a340f is a commit in linux-next which hasn't been merged
to mainline upstream.

Link: http://lkml.kernel.org/r/20160831033420.9910.16809.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/autofs_i.h~autofs-fix-dev-ioctl-number-range-check-fix fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-fix-dev-ioctl-number-range-check-fix
+++ a/fs/autofs4/autofs_i.h
@@ -21,7 +21,7 @@
 
 #define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
 #define AUTOFS_DEV_IOCTL_IOC_COUNT \
-	(AUTOFS_DEV_IOCTL_VERSION_CMD - AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD)
+	(AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD - AUTOFS_DEV_IOCTL_VERSION_CMD)
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
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
autofs-fix-dev-ioctl-number-range-check.patch
autofs-fix-print-format-for-ioctl-warning-message.patch
autofs-move-inclusion-of-linux-limitsh-to-uapi.patch
autofs-remove-possibly-misleading-define-debug.patch
autofs-refactor-ioctl-fn-vector-in-iookup_dev_ioctl.patch

