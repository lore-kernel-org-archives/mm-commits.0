From: akpm@linux-foundation.org
Subject: [patch 045/102] autofs: move inclusion of linux/limits.h to uapi
Date: Tue, 11 Oct 2016 13:53:10 -0700
Message-ID: <57fd5136.BqtVWW+tAgfxNrcZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37972 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753100AbcJKUxM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, ikent@redhat.com

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
