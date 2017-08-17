From: akpm@linux-foundation.org
Subject: + autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch
 added to -mm tree
Date: Thu, 17 Aug 2017 15:47:48 -0700
Message-ID: <59961d14.KV4APoBxZ+41f3ZP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQWru (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove unused AUTOFS_IOC_EXPIRE_DIRECT/INDIRECT
has been added to the -mm tree.  Its filename is
     autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch

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

autofs-remove-unused-autofs_ioc_expire_direct-indirect.patch
autofs-non-functional-header-inclusion-cleanup.patch
autofs-use-autofs_dev_ioctl_size.patch
autofs-drop-wrong-comment.patch
autofs-use-unsigned-int-long-instead-of-uint-ulong-for-ioctl-args.patch

