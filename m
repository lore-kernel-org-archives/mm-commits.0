From: akpm@linux-foundation.org
Subject: + mm-slub-share-object_err-function.patch added to -mm tree
Date: Tue, 03 Feb 2015 15:05:06 -0800
Message-ID: <54d15422.DiDkfwSMIwoiR0sq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbbBCXFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: share object_err function
has been added to the -mm tree.  Its filename is
     mm-slub-share-object_err-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-share-object_err-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-share-object_err-function.patch

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
Subject: mm: slub: share object_err function

Remove static and add function declarations to linux/slub_def.h so it
could be used by kernel address sanitizer.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    3 +++
 mm/slub.c                |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~mm-slub-share-object_err-function include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-share-object_err-function
+++ a/include/linux/slub_def.h
@@ -126,4 +126,7 @@ static inline void *virt_to_obj(struct k
 	return (void *)x - ((x - slab_page) % s->size);
 }
 
+void object_err(struct kmem_cache *s, struct page *page,
+		u8 *object, char *reason);
+
 #endif /* _LINUX_SLUB_DEF_H */
diff -puN mm/slub.c~mm-slub-share-object_err-function mm/slub.c
--- a/mm/slub.c~mm-slub-share-object_err-function
+++ a/mm/slub.c
@@ -629,7 +629,7 @@ static void print_trailer(struct kmem_ca
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
linux-next.patch

