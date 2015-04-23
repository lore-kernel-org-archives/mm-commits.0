From: akpm@linux-foundation.org
Subject: +
 mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch added to -mm tree
Date: Thu, 23 Apr 2015 13:53:34 -0700
Message-ID: <55395bce.DuYbJyXzCLOarDqY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030581AbbDWUxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 16:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, gavin.guo@canonical.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix
has been added to the -mm tree.  Its filename is
     mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

