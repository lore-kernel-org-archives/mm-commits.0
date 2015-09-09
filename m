From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:11:11 -0700
Message-ID: <55f0ae7f.Ns+fMEvn9f00Qhsb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbIIWLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch

This patch was dropped because it was folded into kexec-split-kexec_load-syscall-from-kexec-core-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#2072: FILE: kernel/kexec_core.c:41:
+#include <asm/uaccess.h>

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#2073: FILE: kernel/kexec_core.c:42:
+#include <asm/io.h>

ERROR: do not initialise globals to 0 or NULL
#2092: FILE: kernel/kexec_core.c:61:
+bool kexec_in_progress = false;

WARNING: Missing a blank line after declarations
#2221: FILE: kernel/kexec_core.c:190:
+			unsigned long pstart, pend;
+			pstart = image->segment[j].mem;

WARNING: Missing a blank line after declarations
#2319: FILE: kernel/kexec_core.c:288:
+		unsigned int count, i;
+		pages->mapping = NULL;

WARNING: else is not generally useful after a break or return
#2726: FILE: kernel/kexec_core.c:695:
+			break;
+		} else {

WARNING: Missing a blank line after declarations
#2915: FILE: kernel/kexec_core.c:884:
+	size_t size = 0;
+	mutex_lock(&kexec_mutex);

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#3263: FILE: kernel/kexec_core.c:1232:
+	BUG_ON(!crash_size || !crash_base);

total: 1 errors, 7 warnings, 2753 lines checked

./patches/kexec-split-kexec_load-syscall-from-kexec-core-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/kexec_core.c~kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes
+++ a/kernel/kexec_core.c
@@ -30,6 +30,8 @@
 #include <linux/freezer.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
@@ -38,8 +40,6 @@
 #include <linux/hugetlb.h>
 
 #include <asm/page.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 #include <asm/sections.h>
 
 #include <crypto/hash.h>
@@ -187,6 +187,7 @@ int sanity_check_segment_list(struct kim
 		mend   = mstart + image->segment[i].memsz;
 		for (j = 0; j < i; j++) {
 			unsigned long pstart, pend;
+
 			pstart = image->segment[j].mem;
 			pend   = pstart + image->segment[j].memsz;
 			/* Do the segments overlap ? */
@@ -285,6 +286,7 @@ static struct page *kimage_alloc_pages(g
 	pages = alloc_pages(gfp_mask, order);
 	if (pages) {
 		unsigned int count, i;
+
 		pages->mapping = NULL;
 		set_page_private(pages, order);
 		count = 1 << order;
@@ -692,12 +694,9 @@ static struct page *kimage_alloc_page(st
 			addr = old_addr;
 			page = old_page;
 			break;
-		} else {
-			/* Place the page on the destination list I
-			 * will use it later.
-			 */
-			list_add(&page->lru, &image->dest_pages);
 		}
+		/* Place the page on the destination list, to be used later */
+		list_add(&page->lru, &image->dest_pages);
 	}
 
 	return page;
@@ -881,6 +880,7 @@ void crash_kexec(struct pt_regs *regs)
 size_t crash_get_memory_size(void)
 {
 	size_t size = 0;
+
 	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

