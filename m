From: akpm@linux-foundation.org
Subject: +
 kasan-module-move-module_align-macro-into-linux-moduleloaderh.patch added
 to -mm tree
Date: Mon, 02 Mar 2015 14:19:22 -0800
Message-ID: <54f4e1ea.mw+p0V0a/VlaW8VN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbbCBWTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, module: move MODULE_ALIGN macro into <linux/moduleloader.h>
has been added to the -mm tree.  Its filename is
     kasan-module-move-module_align-macro-into-linux-moduleloaderh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-module-move-module_align-macro-into-linux-moduleloaderh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-module-move-module_align-macro-into-linux-moduleloaderh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan, module: move MODULE_ALIGN macro into <linux/moduleloader.h>

include/linux/moduleloader.h is more suitable place for this macro.
Also change alignment to PAGE_SIZE for CONFIG_KASAN=n as such
alignment already assumed in several places.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h        |    4 ----
 include/linux/moduleloader.h |    8 ++++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/kasan.h~kasan-module-move-module_align-macro-into-linux-moduleloaderh include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-module-move-module_align-macro-into-linux-moduleloaderh
+++ a/include/linux/kasan.h
@@ -50,15 +50,11 @@ void kasan_krealloc(const void *object,
 void kasan_slab_alloc(struct kmem_cache *s, void *object);
 void kasan_slab_free(struct kmem_cache *s, void *object);
 
-#define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
-
 int kasan_module_alloc(void *addr, size_t size);
 void kasan_free_shadow(const struct vm_struct *vm);
 
 #else /* CONFIG_KASAN */
 
-#define MODULE_ALIGN 1
-
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
 
 static inline void kasan_enable_current(void) {}
diff -puN include/linux/moduleloader.h~kasan-module-move-module_align-macro-into-linux-moduleloaderh include/linux/moduleloader.h
--- a/include/linux/moduleloader.h~kasan-module-move-module_align-macro-into-linux-moduleloaderh
+++ a/include/linux/moduleloader.h
@@ -84,4 +84,12 @@ void module_arch_cleanup(struct module *
 
 /* Any cleanup before freeing mod->module_init */
 void module_arch_freeing_init(struct module *mod);
+
+#ifdef CONFIG_KASAN
+#include <linux/kasan.h>
+#define MODULE_ALIGN (PAGE_SIZE << KASAN_SHADOW_SCALE_SHIFT)
+#else
+#define MODULE_ALIGN PAGE_SIZE
+#endif
+
 #endif
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

kasan-module-vmalloc-rework-shadow-allocation-for-modules.patch
kasan-module-move-module_align-macro-into-linux-moduleloaderh.patch
arm-factor-out-mmap-aslr-into-mmap_rnd.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-move-randomize_et_dyn-into-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
linux-next.patch

