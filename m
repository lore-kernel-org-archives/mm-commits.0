From: akpm@linux-foundation.org
Subject: + mm-nommu-sort-mm-mmap-list-properly-fix.patch added to -mm tree
Date: Thu, 31 Mar 2011 11:52:21 -0700
Message-ID: <201103311852.p2VIqMhx021890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759114Ab1CaSwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, namhyung@gmail.com


The patch titled
     mm-nommu-sort-mm-mmap-list-properly-fix
has been added to the -mm tree.  Its filename is
     mm-nommu-sort-mm-mmap-list-properly-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-nommu-sort-mm-mmap-list-properly-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid duplicating __vma_link_list().

Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++++
 mm/mmap.c     |   22 ----------------------
 mm/nommu.c    |   24 ------------------------
 mm/util.c     |   24 ++++++++++++++++++++++++
 4 files changed, 28 insertions(+), 46 deletions(-)

diff -puN mm/internal.h~mm-nommu-sort-mm-mmap-list-properly-fix mm/internal.h
--- a/mm/internal.h~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/internal.h
@@ -66,6 +66,10 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+/* mm/util.c */
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent);
+
 #ifdef CONFIG_MMU
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/mmap.c
--- a/mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/mmap.c
@@ -398,28 +398,6 @@ find_vma_prepare(struct mm_struct *mm, u
 	return vma;
 }
 
-void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
diff -puN mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/nommu.c
--- a/mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/nommu.c
@@ -672,30 +672,6 @@ static void protect_vma(struct vm_area_s
 #endif
 }
 
-/* borrowed from mm/mmap.c */
-static inline void
-__vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 /*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
diff -puN mm/util.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/util.c
--- a/mm/util.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/util.c
@@ -6,6 +6,8 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
@@ -215,6 +217,28 @@ char *strndup_user(const char __user *s,
 }
 EXPORT_SYMBOL(strndup_user);
 
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent)
+{
+	struct vm_area_struct *next;
+
+	vma->vm_prev = prev;
+	if (prev) {
+		next = prev->vm_next;
+		prev->vm_next = vma;
+	} else {
+		mm->mmap = vma;
+		if (rb_parent)
+			next = rb_entry(rb_parent,
+					struct vm_area_struct, vm_rb);
+		else
+			next = NULL;
+	}
+	vma->vm_next = next;
+	if (next)
+		next->vm_prev = vma;
+}
+
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

