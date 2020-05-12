From: akpm@linux-foundation.org
Subject: + drm-remove-drm-specific-kmap_atomic-code-fix.patch
 added to -mm tree
Date: Tue, 12 May 2020 13:58:08 -0700
Message-ID: <20200512205808.Nsd4NvvBD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgELU6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 May 2020 16:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ira.weiny@intel.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: drm: vmwgfx: include linux/highmem.h
has been added to the -mm tree.  Its filename is
     drm-remove-drm-specific-kmap_atomic-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-remove-drm-specific-kmap_atomic-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-remove-drm-specific-kmap_atomic-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drm: vmwgfx: include linux/highmem.h

In order to call kmap_atomic() etc, we need to include linux/highmem.h:

drivers/gpu/drm/vmwgfx/vmwgfx_blit.c: In function 'vmw_bo_cpu_blit_line':
drivers/gpu/drm/vmwgfx/vmwgfx_blit.c:377:4: error: implicit declaration of function 'kunmap_atomic'; did you mean 'in_atomic'? [-Werror=implicit-function-declaration]
  377 |    kunmap_atomic(d->src_addr);
      |    ^~~~~~~~~~~~~
      |    in_atomic
drivers/gpu/drm/vmwgfx/vmwgfx_blit.c:391:5: error: implicit declaration of function 'kmap_atomic_prot' [-Werror=implicit-function-declaration]
  391 |     kmap_atomic_prot(d->dst_pages[dst_page],
      |     ^~~~~~~~~~~~~~~~
drivers/gpu/drm/vmwgfx/vmwgfx_blit.c:390:16: warning: assignment to 'u8 *' {aka 'unsigned char *'} from 'int' makes pointer from integer without a cast [-Wint-conversion]
  390 |    d->dst_addr =
      |                ^
drivers/gpu/drm/vmwgfx/vmwgfx_blit.c:403:16: warning: assignment to 'u8 *' {aka 'unsigned char *'} from 'int' makes pointer from integer without a cast [-Wint-conversion]
  403 |    d->src_addr =
      |                ^

Link: http://lkml.kernel.org/r/20200508220150.649044-1-arnd@arndb.de
Fixes: 46385a895322 ("drm: remove drm specific kmap_atomic code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c~drm-remove-drm-specific-kmap_atomic-code-fix
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_blit.c
@@ -27,6 +27,7 @@
  **************************************************************************/
 
 #include "vmwgfx_drv.h"
+#include <linux/highmem.h>
 
 /*
  * Template that implements find_first_diff() for a generic
_

Patches currently in -mm which might be from arnd@arndb.de are

arm64-add-support-for-folded-p4d-page-tables-fix.patch
drm-remove-drm-specific-kmap_atomic-code-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
