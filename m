From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:45:06 -0700
Message-ID: <558b4102./LQYrldAKU550+st%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbFXXpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, gavin.guo@canonical.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix
has been removed from the -mm tree.  Its filename was
     mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch

This patch was dropped because it was folded into mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix

s/kmalloc_names/kmalloc_info/, tweak comment text

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gavin Guo <gavin.guo@canonical.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slab_common.c~mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix
+++ a/mm/slab_common.c
@@ -784,14 +784,14 @@ struct kmem_cache *kmalloc_slab(size_t s
 }
 
 /*
- * The kmalloc_names is to make slub_debug=,kmalloc-xx option work in the boot
- * time. The kmalloc_index() support to 2^26=64MB. So, the final entry of the
- * table is kmalloc-67108864.
+ * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
+ * kmalloc_index() supports up to 2^26=64MB, so the final entry of the table is
+ * kmalloc-67108864.
  */
 static struct {
 	const char *name;
 	unsigned long size;
-} const kmalloc_names[] __initconst = {
+} const kmalloc_info[] __initconst = {
 	{NULL,                      0},		{"kmalloc-96",             96},
 	{"kmalloc-192",           192},		{"kmalloc-8",               8},
 	{"kmalloc-16",             16},		{"kmalloc-32",             32},
@@ -861,8 +861,8 @@ void __init create_kmalloc_caches(unsign
 	for (i = KMALLOC_LOOP_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		if (!kmalloc_caches[i]) {
 			kmalloc_caches[i] = create_kmalloc_cache(
-						kmalloc_names[i].name,
-						kmalloc_names[i].size,
+						kmalloc_info[i].name,
+						kmalloc_info[i].size,
 						flags);
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch

