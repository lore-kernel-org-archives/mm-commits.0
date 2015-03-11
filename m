From: akpm@linux-foundation.org
Subject: + lib-add-huge-i-o-map-capability-interfaces-fix.patch added to
 -mm tree
Date: Wed, 11 Mar 2015 13:02:07 -0700
Message-ID: <55009f3f.0valhuvh8k8zyjnd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbCKUCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, fengguang.wu@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: Fix undefined ioremap_huge_init when CONFIG_MMU is not set
has been added to the -mm tree.  Its filename is
     lib-add-huge-i-o-map-capability-interfaces-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-huge-i-o-map-capability-interfaces-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-huge-i-o-map-capability-interfaces-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: Fix undefined ioremap_huge_init when CONFIG_MMU is not set

Fix a build error, undefined reference to ioremap_huge_init, when
CONFIG_MMU is not defined on linux-next and -mm tree.

lib/ioremap.o is not linked to the kernel when CONFIG_MMU is not
defined.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |    5 +++--
 lib/ioremap.c      |    1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/io.h~lib-add-huge-i-o-map-capability-interfaces-fix include/linux/io.h
--- a/include/linux/io.h~lib-add-huge-i-o-map-capability-interfaces-fix
+++ a/include/linux/io.h
@@ -38,11 +38,12 @@ static inline int ioremap_page_range(uns
 }
 #endif
 
-void __init ioremap_huge_init(void);
-
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+void __init ioremap_huge_init(void);
 int arch_ioremap_pud_supported(void);
 int arch_ioremap_pmd_supported(void);
+#else
+static inline void ioremap_huge_init(void) { }
 #endif
 
 /*
diff -puN lib/ioremap.c~lib-add-huge-i-o-map-capability-interfaces-fix lib/ioremap.c
--- a/lib/ioremap.c~lib-add-huge-i-o-map-capability-interfaces-fix
+++ a/lib/ioremap.c
@@ -46,7 +46,6 @@ static inline int ioremap_pmd_enabled(vo
 }
 
 #else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
-void __init ioremap_huge_init(void) { }
 static inline int ioremap_pud_enabled(void) { return 0; }
 static inline int ioremap_pmd_enabled(void) { return 0; }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
lib-add-huge-i-o-map-capability-interfaces-fix.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch
linux-next.patch

