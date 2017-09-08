From: akpm@linux-foundation.org
Subject: [patch 102/126] autofs: remove unused
 AUTOFS_IOC_EXPIRE_DIRECT/INDIRECT
Date: Fri, 08 Sep 2017 16:16:34 -0700
Message-ID: <20170908231634.08BZg2ssk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757210AbdIHXQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, raven@themaw.net, tkusumi@tuxera.com, torvalds@linux-foundation.org

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
