From: akpm@linux-foundation.org
Subject: [merged] autofs-move-inclusion-of-linux-limitsh-to-uapi.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:24:08 -0700
Message-ID: <57fe8dd8.paURDdhfVb1e43HR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755989AbcJLTYh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: move inclusion of linux/limits.h to uapi
has been removed from the -mm tree.  Its filename was
     autofs-move-inclusion-of-linux-limitsh-to-uapi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


