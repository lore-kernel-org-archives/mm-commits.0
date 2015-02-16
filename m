From: akpm@linux-foundation.org
Subject: [merged] mm-util-add-kstrdup_const.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:35 -0800
Message-ID: <54e24fe7.CyGp5sOZUy5e1axi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbBPUQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util: add kstrdup_const
has been removed from the -mm tree.  Its filename was
     mm-util-add-kstrdup_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: mm/util: add kstrdup_const

kstrdup() is often used to duplicate strings where neither source neither
destination will be ever modified.  In such case we can just reuse the
source instead of duplicating it.  The problem is that we must be sure
that the source is non-modifiable and its life-time is long enough.

I suspect the good candidates for such strings are strings located in
kernel .rodata section, they cannot be modifed because the section is
read-only and their life-time is equal to kernel life-time.

This small patchset proposes alternative version of kstrdup -
kstrdup_const, which returns source string if it is located in .rodata
otherwise it fallbacks to kstrdup.  To verify if the source is in .rodata
function checks if the address is between sentinels __start_rodata,
__end_rodata.  I guess it should work with all architectures.

The main patch is accompanied by four patches constifying kstrdup for
cases where situtation described above happens frequently.

I have tested the patchset on mobile platform (exynos4210-trats) and it
saves 3272 string allocations.  Since minimal allocation is 32 or 64 bytes
depending on Kconfig options the patchset saves respectively about 100KB
or 200KB of memory.

Stats from tested platform show that the main offender is sysfs:

By caller:
  2260 __kernfs_new_node
    631 clk_register+0xc8/0x1b8
    318 clk_register+0x34/0x1b8
      51 kmem_cache_create
      12 alloc_vfsmnt

By string (with count >= 5):
    883 power
    876 subsystem
    135 parameters
    132 device
     61 iommu_group
    ...

This patch (of 5):

Add an alternative version of kstrdup which returns pointer to constant
char array.  The function checks if input string is in persistent and
read-only memory section, if yes it returns the input string, otherwise it
fallbacks to kstrdup.

kstrdup_const is accompanied by kfree_const performing conditional memory
deallocation of the string.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    3 +++
 mm/util.c              |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff -puN include/linux/string.h~mm-util-add-kstrdup_const include/linux/string.h
--- a/include/linux/string.h~mm-util-add-kstrdup_const
+++ a/include/linux/string.h
@@ -112,7 +112,10 @@ extern void * memchr(const void *,int,__
 #endif
 void *memchr_inv(const void *s, int c, size_t n);
 
+extern void kfree_const(const void *x);
+
 extern char *kstrdup(const char *s, gfp_t gfp);
+extern const char *kstrdup_const(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
diff -puN mm/util.c~mm-util-add-kstrdup_const mm/util.c
--- a/mm/util.c~mm-util-add-kstrdup_const
+++ a/mm/util.c
@@ -12,10 +12,30 @@
 #include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
 
+#include <asm/sections.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
 
+static inline int is_kernel_rodata(unsigned long addr)
+{
+	return addr >= (unsigned long)__start_rodata &&
+		addr < (unsigned long)__end_rodata;
+}
+
+/**
+ * kfree_const - conditionally free memory
+ * @x: pointer to the memory
+ *
+ * Function calls kfree only if @x is not in .rodata section.
+ */
+void kfree_const(const void *x)
+{
+	if (!is_kernel_rodata((unsigned long)x))
+		kfree(x);
+}
+EXPORT_SYMBOL(kfree_const);
+
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
@@ -38,6 +58,24 @@ char *kstrdup(const char *s, gfp_t gfp)
 EXPORT_SYMBOL(kstrdup);
 
 /**
+ * kstrdup_const - conditionally duplicate an existing const string
+ * @s: the string to duplicate
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ *
+ * Function returns source string if it is in .rodata section otherwise it
+ * fallbacks to kstrdup.
+ * Strings allocated by kstrdup_const should be freed by kfree_const.
+ */
+const char *kstrdup_const(const char *s, gfp_t gfp)
+{
+	if (is_kernel_rodata((unsigned long)s))
+		return s;
+
+	return kstrdup(s, gfp);
+}
+EXPORT_SYMBOL(kstrdup_const);
+
+/**
  * kstrndup - allocate space for and copy an existing string
  * @s: the string to duplicate
  * @max: read at most @max chars from @s
_

Patches currently in -mm which might be from a.hajda@samsung.com are

origin.patch

