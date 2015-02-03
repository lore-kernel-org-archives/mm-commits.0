From: akpm@linux-foundation.org
Subject: + mm-slub-introduce-virt_to_obj-function.patch added to -mm tree
Date: Tue, 03 Feb 2015 15:05:03 -0800
Message-ID: <54d1541f.ZbTU1EUg6mqro++b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbbBCXFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:05:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: introduce virt_to_obj function
has been added to the -mm tree.  Its filename is
     mm-slub-introduce-virt_to_obj-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-introduce-virt_to_obj-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-introduce-virt_to_obj-function.patch

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
Subject: mm: slub: introduce virt_to_obj function

virt_to_obj takes kmem_cache address, address of slab page, address x
pointing somewhere inside slab object, and returns address of the
beginning of object.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
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
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/slub_def.h~mm-slub-introduce-virt_to_obj-function include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-introduce-virt_to_obj-function
+++ a/include/linux/slub_def.h
@@ -110,4 +110,20 @@ static inline void sysfs_slab_remove(str
 }
 #endif
 
+
+/**
+ * virt_to_obj - returns address of the beginning of object.
+ * @s: object's kmem_cache
+ * @slab_page: address of slab page
+ * @x: address within object memory range
+ *
+ * Returns address of the beginning of object
+ */
+static inline void *virt_to_obj(struct kmem_cache *s,
+				const void *slab_page,
+				const void *x)
+{
+	return (void *)x - ((x - slab_page) % s->size);
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
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

