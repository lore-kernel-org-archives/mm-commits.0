From: akpm@linux-foundation.org
Subject: [alternative-merged] drm-fix-build-error-in-include-drm-ttm-ttm_memoryh.patch removed from -mm tree
Date: Mon, 21 Dec 2009 17:01:49 -0800
Message-ID: <200912220101.nBM11oAS007072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbZLVBCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 20:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: fix build error in include/drm/ttm/ttm_memory.h
has been removed from the -mm tree.  Its filename was
     drm-fix-build-error-in-include-drm-ttm-ttm_memoryh.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix build error in include/drm/ttm/ttm_memory.h
From: Ralf Baechle <ralf@linux-mips.org>

include/drm/ttm/ttm_memory.h uses struct page * without having included
the required headers or a forward declaration resulting in the following
build error for mtx1_defconfig on Linus' master branch, possibly others:

  CC [M]  drivers/gpu/drm/ttm/ttm_memory.o
In file included from drivers/gpu/drm/ttm/ttm_memory.c:28:
include/drm/ttm/ttm_memory.h:154: warning: `struct page' declared inside parameter list
include/drm/ttm/ttm_memory.h:154: warning: its scope is only this definition or declaration, which is probably not what you want
include/drm/ttm/ttm_memory.h:156: warning: `struct page' declared inside parameter list
drivers/gpu/drm/ttm/ttm_memory.c:537: error: conflicting types for `ttm_mem_global_alloc_page'
include/drm/ttm/ttm_memory.h:152: note: previous declaration of `ttm_mem_global_alloc_page' was here
drivers/gpu/drm/ttm/ttm_memory.c:560: error: conflicting types for `ttm_mem_global_free_page'
include/drm/ttm/ttm_memory.h:155: note: previous declaration of `ttm_mem_global_free_page' was here

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
@@ -144,6 +144,8 @@ static inline void ttm_mem_unregister_sh
 	spin_unlock(&glob->lock);
 }
 
+struct page;
+
 extern int ttm_mem_global_init(struct ttm_mem_global *glob);
 extern void ttm_mem_global_release(struct ttm_mem_global *glob);
 extern int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
_

Patches currently in -mm which might be from ralf@linux-mips.org are

mm-make-totalhigh_pages-unsigned-long.patch
linux-next.patch
drm-fix-build-error-in-include-drm-ttm-ttm_memoryh.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
lib-add-support-for-lzo-compressed-kernels.patch
arm-add-support-for-lzo-compressed-kernels.patch
x86-add-support-for-lzo-compressed-kernels.patch
add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

