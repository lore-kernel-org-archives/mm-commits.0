From: akpm@linux-foundation.org
Subject: [merged]
 autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:43:13 -0700
Message-ID: <20170911194313.-WMcDgPaZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdIKTnO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, tkusumi@tuxera.com


The patch titled
     Subject: autofs: remove unused AUTOFS_IOC_EXPIRE_DIRECT/INDIRECT
has been removed from the -mm tree.  Its filename was
     autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: remove unused AUTOFS_IOC_EXPIRE_DIRECT/INDIRECT

These are not used by either kernel or userspace, although
AUTOFS_IOC_EXPIRE_DIRECT once seems to have been used by userspace in
around 2006-2008, which was technically just an alias of the existing
ioctl AUTOFS_IOC_EXPIRE_MULTI.

ioctls for autofs are already complicated enough that they could be
removed unless these are staying here to be able to compile userspace code
of certain period of time from a decade ago.

Edit: raven@themaw.net
Yes, this is indeed very old and anything that still uses must
be updated becuase it will be using broken functionality.
End edit: raven@themaw.net

Link: http://lkml.kernel.org/r/150285067347.4670.11494624644273072003.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_fs4.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/uapi/linux/auto_fs4.h~autofs-remove-unused-autofs_ioc_expire_direct-indirect include/uapi/linux/auto_fs4.h
--- a/include/uapi/linux/auto_fs4.h~autofs-remove-unused-autofs_ioc_expire_direct-indirect
+++ a/include/uapi/linux/auto_fs4.h
@@ -155,8 +155,6 @@ enum {
 };
 
 #define AUTOFS_IOC_EXPIRE_MULTI    _IOW(AUTOFS_IOCTL, AUTOFS_IOC_EXPIRE_MULTI_CMD, int)
-#define AUTOFS_IOC_EXPIRE_INDIRECT AUTOFS_IOC_EXPIRE_MULTI
-#define AUTOFS_IOC_EXPIRE_DIRECT   AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_PROTOSUBVER     _IOR(AUTOFS_IOCTL, AUTOFS_IOC_PROTOSUBVER_CMD, int)
 #define AUTOFS_IOC_ASKUMOUNT       _IOR(AUTOFS_IOCTL, AUTOFS_IOC_ASKUMOUNT_CMD, int)
 
_

Patches currently in -mm which might be from tkusumi@tuxera.com are


