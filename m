From: akpm@linux-foundation.org
Subject: +
 kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch added to -mm tree
Date: Tue, 20 Jun 2017 13:41:19 -0700
Message-ID: <5949886f.fWKhjUcRjdaJRtEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751767AbdFTUlU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 16:41:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, abbotti@mev.co.uk, keescook@chromium.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: fix new warnings for container_of()
has been added to the -mm tree.  Its filename is
     kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernelh-handle-pointers-to-arrays-better-in-container_of-fix include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-handle-pointers-to-arrays-better-in-container_of-fix
+++ a/include/linux/kernel.h
@@ -852,10 +852,11 @@ static inline void ftrace_dump(enum ftra
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

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch
kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch

