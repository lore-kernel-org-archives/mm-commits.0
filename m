From: akpm@linux-foundation.org
Subject: + autofs-move-inclusion-of-linux-limitsh-to-uapi.patch added to
 -mm tree
Date: Thu, 11 Aug 2016 20:07:32 -0700
Message-ID: <57ad3d74.Sjor+B5sLlw7xYEq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbcHLDRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: move inclusion of linux/limits.h to uapi
has been added to the -mm tree.  Its filename is
     autofs-move-inclusion-of-linux-limitsh-to-uapi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-move-inclusion-of-linux-limitsh-to-uapi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-move-inclusion-of-linux-limitsh-to-uapi.patch

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
Subject: autofs: move inclusion of linux/limits.h to uapi

linux/limits.h should be included by uapi instead of linux/auto_fs.h
so as not to cause compile error in userspace.

 # cat << EOF > ./test1.c
 > #include <stdio.h>
 > #include <linux/auto_fs.h>
 > int main(void) {
 >     return 0;
 > }
 > EOF
 # gcc -Wall -g ./test1.c
 In file included from ./test1.c:2:0:
 /usr/include/linux/auto_fs.h:54:12: error: 'NAME_MAX' undeclared here (not in a function)
   char name[NAME_MAX+1];
             ^

Link: http://lkml.kernel.org/r/20160812024856.12352.24092.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/auto_fs.h      |    1 -
 include/uapi/linux/auto_fs.h |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/auto_fs.h~autofs-move-inclusion-of-linux-limitsh-to-uapi include/linux/auto_fs.h
--- a/include/linux/auto_fs.h~autofs-move-inclusion-of-linux-limitsh-to-uapi
+++ a/include/linux/auto_fs.h
@@ -10,7 +10,6 @@
 #define _LINUX_AUTO_FS_H
 
 #include <linux/fs.h>
-#include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <uapi/linux/auto_fs.h>
 #endif /* _LINUX_AUTO_FS_H */
diff -puN include/uapi/linux/auto_fs.h~autofs-move-inclusion-of-linux-limitsh-to-uapi include/uapi/linux/auto_fs.h
--- a/include/uapi/linux/auto_fs.h~autofs-move-inclusion-of-linux-limitsh-to-uapi
+++ a/include/uapi/linux/auto_fs.h
@@ -12,6 +12,7 @@
 #define _UAPI_LINUX_AUTO_FS_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 #ifndef __KERNEL__
 #include <sys/ioctl.h>
 #endif /* __KERNEL__ */
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
autofs-fix-print-format-for-ioctl-warning-message.patch
autofs-move-inclusion-of-linux-limitsh-to-uapi.patch

