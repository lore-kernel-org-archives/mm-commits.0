From: akpm@linux-foundation.org
Subject: +
 mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
 added to -mm tree
Date: Wed, 03 Sep 2014 12:40:52 -0700
Message-ID: <54076ec4.SXX1dzKOV7x8UJki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbaICTkx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 15:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix kmemcheck.c build errors
has been added to the -mm tree.  Its filename is
     mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix kmemcheck.c build errors

Add header files to fix kmemcheck.c build errors:

../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type

../mm/slab.h: In function 'cache_from_obj':
../mm/slab.h:283:2: error: implicit declaration of function 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemcheck.c |    1 +
 mm/slab.h      |    2 ++
 2 files changed, 3 insertions(+)

diff -puN mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2 mm/kmemcheck.c
--- a/mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2
+++ a/mm/kmemcheck.c
@@ -2,6 +2,7 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include "slab.h"
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
diff -puN mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2 mm/slab.h
--- a/mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2
+++ a/mm/slab.h
@@ -268,6 +268,8 @@ static inline void memcg_uncharge_slab(s
 }
 #endif
 
+#include <linux/memcontrol.h>
+
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
kernel-add-support-for-kernel-restart-handler-call-chain.patch
power-restart-call-machine_restart-instead-of-arm_pm_restart.patch
arm64-support-restart-through-restart-handler-call-chain.patch
arm-support-restart-through-restart-handler-call-chain.patch
watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch
watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
arm-arm64-unexport-restart-handlers.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch
maintainers-linaro-mm-sig-is-moderated.patch
autofs-the-documentation-i-wanted-to-read.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

