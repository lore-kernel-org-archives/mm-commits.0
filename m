From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch removed
 from -mm tree
Date: Wed, 12 Jul 2017 14:14:35 -0700
Message-ID: <5966913b.o+6Y4tEOM/D0qQQx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753354AbdGLVOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, abbotti@mev.co.uk, keescook@chromium.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: fix new warnings for container_of()
has been removed from the -mm tree.  Its filename was
     kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch

This patch was dropped because it was folded into kernelh-handle-pointers-to-arrays-better-in-container_of.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kernel.h: fix new warnings for container_of()

I see new warnings with gcc-7.0.1 with the modified container_of():

fs/f2fs/dir.c: In function 'F2FS_I':
fs/f2fs/f2fs.h:1122:385: note: found mismatched ssa struct pointer types: 'struct f2fs_inode_info' and 'struct inode'

This seems to happen for all structures that have a zero offset
between the member and the container structure, i.e. idential
pointers.

Reverting to an intermediate pointer avoids the warning, and using
a void pointer instead of the target type should also avoid
regressing on the previous patch again.

Fixes: mmotm ("kernel.h: handle pointers to arrays better in container_of()")
Link: http://lkml.kernel.org/r/20170620200940.90557-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernelh-handle-pointers-to-arrays-better-in-container_of-fix include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-handle-pointers-to-arrays-better-in-container_of-fix
+++ a/include/linux/kernel.h
@@ -856,10 +856,11 @@ static inline void ftrace_dump(enum ftra
  *
  */
 #define container_of(ptr, type, member) ({				\
+	void *__mptr = (void *)(ptr);					\
 	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
 			 !__same_type(*(ptr), void),			\
 			 "pointer type mismatch in container_of()");	\
-	((type *)((char *)(ptr) - offsetof(type, member))); })
+	((type *)(__mptr - offsetof(type, member))); })
 
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
_

Patches currently in -mm which might be from arnd@arndb.de are

kernelh-handle-pointers-to-arrays-better-in-container_of.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch

