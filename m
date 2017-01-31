From: akpm@linux-foundation.org
Subject: + autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch added to -mm tree
Date: Tue, 31 Jan 2017 15:48:04 -0800
Message-ID: <58912234.B6thMB9sD2PGEWdh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbdAaX5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 18:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE definition
has been added to the -mm tree.  Its filename is
     autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

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
Subject: autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE definition

This macro is already defined in uapi header.  Also use this macro where
possible.

Link: http://lkml.kernel.org/r/148577166656.9801.10322423666945951186.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c              |    2 --
 include/uapi/linux/auto_dev-ioctl.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-remove-duplicated-autofs_dev_ioctl_size-definition fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-remove-duplicated-autofs_dev_ioctl_size-definition
+++ a/fs/autofs4/dev-ioctl.c
@@ -38,8 +38,6 @@
  * which have been left busy at at service shutdown.
  */
 
-#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
-
 typedef int (*ioctl_fn)(struct file *, struct autofs_sb_info *,
 			struct autofs_dev_ioctl *);
 
diff -puN include/uapi/linux/auto_dev-ioctl.h~autofs-remove-duplicated-autofs_dev_ioctl_size-definition include/uapi/linux/auto_dev-ioctl.h
--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-remove-duplicated-autofs_dev_ioctl_size-definition
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -113,10 +113,10 @@ struct autofs_dev_ioctl {
 
 static inline void init_autofs_dev_ioctl(struct autofs_dev_ioctl *in)
 {
-	memset(in, 0, sizeof(struct autofs_dev_ioctl));
+	memset(in, 0, AUTOFS_DEV_IOCTL_SIZE);
 	in->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
 	in->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
-	in->size = sizeof(struct autofs_dev_ioctl);
+	in->size = AUTOFS_DEV_IOCTL_SIZE;
 	in->ioctlfd = -1;
 }
 
_

Patches currently in -mm which might be from tkusumi@tuxera.com are

autofs-remove-wrong-comment.patch
autofs-fix-typo-in-documentation.patch
autofs-fix-wrong-ioctl-documentation-regarding-devid.patch
autofs-update-ioctl-documentation-regarding-struct-autofs_dev_ioctl.patch
autofs-add-command-enum-macros-for-root-dir-ioctls.patch
autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

