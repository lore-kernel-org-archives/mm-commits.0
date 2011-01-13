From: akpm@linux-foundation.org
Subject: [merged] flex_array-export-symbols-to-modules.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:06:33 -0800
Message-ID: <201101132009.p0DK9EFN029957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933680Ab1AMUKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, kernel-hacker@bennee.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     flex_array: export symbols to modules
has been removed from the -mm tree.  Its filename was
     flex_array-export-symbols-to-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: export symbols to modules
From: David Rientjes <rientjes@google.com>

Alex said:

  I want to use flex_array to store a sparse array of ATM cell
  re-assembly buffers for my ATM over Ethernet driver.  Using the per-vcc
  user_back structure causes problems when stacked with things like
  br2684.

Add EXPORT_SYMBOL() for all publically accessible flex array functions
and move to obj-y so that modules may use this library.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Reported-by: Alex Bennee <kernel-hacker@bennee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile     |    4 ++--
 lib/flex_array.c |   10 ++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN lib/Makefile~flex_array-export-symbols-to-modules lib/Makefile
--- a/lib/Makefile~flex_array-export-symbols-to-modules
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o flex_array.o
+	 is_single_threaded.o plist.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN lib/flex_array.c~flex_array-export-symbols-to-modules lib/flex_array.c
--- a/lib/flex_array.c~flex_array-export-symbols-to-modules
+++ a/lib/flex_array.c
@@ -23,6 +23,7 @@
 #include <linux/flex_array.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
@@ -103,6 +104,7 @@ struct flex_array *flex_array_alloc(int 
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_alloc);
 
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
@@ -126,12 +128,14 @@ void flex_array_free_parts(struct flex_a
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++)
 		kfree(fa->parts[part_nr]);
 }
+EXPORT_SYMBOL(flex_array_free_parts);
 
 void flex_array_free(struct flex_array *fa)
 {
 	flex_array_free_parts(fa);
 	kfree(fa);
 }
+EXPORT_SYMBOL(flex_array_free);
 
 static unsigned int index_inside_part(struct flex_array *fa,
 					unsigned int element_nr)
@@ -196,6 +200,7 @@ int flex_array_put(struct flex_array *fa
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_put);
 
 /**
  * flex_array_clear - clear element in array at @element_nr
@@ -223,6 +228,7 @@ int flex_array_clear(struct flex_array *
 	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_clear);
 
 /**
  * flex_array_prealloc - guarantee that array space exists
@@ -259,6 +265,7 @@ int flex_array_prealloc(struct flex_arra
 	}
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_prealloc);
 
 /**
  * flex_array_get - pull data back out of the array
@@ -288,6 +295,7 @@ void *flex_array_get(struct flex_array *
 	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
+EXPORT_SYMBOL(flex_array_get);
 
 /**
  * flex_array_get_ptr - pull a ptr back out of the array
@@ -308,6 +316,7 @@ void *flex_array_get_ptr(struct flex_arr
 
 	return *tmp;
 }
+EXPORT_SYMBOL(flex_array_get_ptr);
 
 static int part_is_free(struct flex_array_part *part)
 {
@@ -348,3 +357,4 @@ int flex_array_shrink(struct flex_array 
 	}
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_shrink);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
thp-transparent-hugepage-sysfs-meminfo.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
memcg-fix-deadlock-between-cpuset-and-memcg.patch
memcg-fix-deadlock-between-cpuset-and-memcg-fix.patch

