From: akpm@linux-foundation.org
Subject: +
 mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch added to -mm tree
Date: Thu, 09 Apr 2015 12:37:55 -0700
Message-ID: <5526d513.RLEcz5Tp5LRtA0jy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbbDITh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 15:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: add missing include
has been added to the -mm tree.  Its filename is
     mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch

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
Subject: mempool: add missing include

This is a fix^3 for the mempool poisoning patch, which introduces
a compile-time error on some ARM randconfig builds:

mm/mempool.c: In function 'check_element':
mm/mempool.c:65:16: error: implicit declaration of function 'kmap_atomic' [-Werror=implicit-function-declaration]
   void *addr = kmap_atomic((struct page *)element);

The problem is clearly the missing declaration, and including
linux/highmem.h fixes it.

Fixes: a3db5a8463b0db ("mm, mempool: poison elements backed by page allocator fix fix")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix mm/mempool.c
--- a/mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix
+++ a/mm/mempool.c
@@ -11,6 +11,7 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/highmem.h>
 #include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
ocfs2-use-64bit-variables-to-track-heartbeat-time.patch
mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch
documentation-bindings-add-abraconabx80x.patch
rtc-add-rtc-abx80x-a-driver-for-the-abracon-ab-x80x-i2c-rtc.patch
seccomp-allow-compat-sigreturn-overrides.patch
linux-next.patch
powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch
maintainers-add-mediatek-soc-mailing-list.patch

