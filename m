From: akpm@linux-foundation.org
Subject: + drm-fix-build-error-in-include-drm-ttm-ttm_memoryh.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:00:14 -0800
Message-ID: <200912032200.nB3M0EBH024303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbZLCWBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:01:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, airlied@linux.ie


The patch titled
     drm: fix build error in include/drm/ttm/ttm_memory.h
has been added to the -mm tree.  Its filename is
     drm-fix-build-error-in-include-drm-ttm-ttm_memoryh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix build error in include/drm/ttm/ttm_memory.h
From: Ralf Baechle <ralf@linux-mips.org>

include/drm/ttm/ttm_memory.h uses struct page * without having included
the required headers or a forward declaration resulting in the following
build error for mtx1_defconfig on Linus' master branch, possibly others:

  CC [M]  drivers/gpu/drm/ttm/ttm_memory.o
In file included from /home/ralf/src/linux/linux-mips/drivers/gpu/drm/ttm/ttm_memory.c:28:
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:154: warning: `struct page' declared inside parameter list
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:154: warning: its scope is only this definition or declaration, which is probably not what you want
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:156: warning: `struct page' declared inside parameter list
/home/ralf/src/linux/linux-mips/drivers/gpu/drm/ttm/ttm_memory.c:537: error: conflicting types for `ttm_mem_global_alloc_page'
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:152: note: previous declaration of `ttm_mem_global_alloc_page' was here
/home/ralf/src/linux/linux-mips/drivers/gpu/drm/ttm/ttm_memory.c:560: error: conflicting types for `ttm_mem_global_free_page'
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:155: note: previous declaration of `ttm_mem_global_free_page' was here
make[6]: *** [drivers/gpu/drm/ttm/ttm_memory.o] Error 1
make[5]: *** [drivers/gpu/drm/ttm] Error 2
make[4]: *** [drivers/gpu/drm] Error 2
make[3]: *** [drivers/gpu] Error 2
make[2]: *** [drivers] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Fixed by adding a forward declaration.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/ttm/ttm_memory.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/drm/ttm/ttm_memory.h~drm-fix-build-error-in-include-drm-ttm-ttm_memoryh include/drm/ttm/ttm_memory.h
--- a/include/drm/ttm/ttm_memory.h~drm-fix-build-error-in-include-drm-ttm-ttm_memoryh
+++ a/include/drm/ttm/ttm_memory.h
@@ -143,6 +143,8 @@ static inline void ttm_mem_unregister_sh
 	spin_unlock(&glob->lock);
 }
 
+struct page;
+
 extern int ttm_mem_global_init(struct ttm_mem_global *glob);
 extern void ttm_mem_global_release(struct ttm_mem_global *glob);
 extern int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-next.patch
mm-make-totalhigh_pages-unsigned-long.patch
drm-fix-build-error-in-include-drm-ttm-ttm_memoryh.patch
lib-add-support-for-lzo-compressed-kernels.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
arm-add-support-for-lzo-compressed-kernels.patch
arm-add-support-for-lzo-compressed-kernels-fix.patch
x86-add-support-for-lzo-compressed-kernels.patch
add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

