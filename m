From: akpm@linux-foundation.org
Subject: - exec-fix-remove_arg_zero.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:32 -0700
Message-ID: <200705090245.l492jWNe008751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031125AbXEICpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, ptesarik@suse.cz, mm-commits@vger.kernel.org


The patch titled
     exec: fix remove_arg_zero
has been removed from the -mm tree.  Its filename was
     exec-fix-remove_arg_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: exec: fix remove_arg_zero
From: Nick Piggin <npiggin@suse.de>

Petr Tesarik discovered a problem in remove_arg_zero(). He writes:

 When a script is loaded, load_script() replaces argv[0] with the
 name of the interpreter and the filename passed to the exec syscall.
 However, there is no guarantee that the length of the interpreter
 name plus the length of the filename is greater than the length of
 the original argv[0]. If the difference happens to cross a page boundary,
 setup_arg_pages() will call put_dirty_page() [aka install_arg_page()]
 with an address outside the VMA.

 Therefore, remove_arg_zero() must free all pages which would be unused
 after the argument is removed.

So, rewrite the remove_arg_zero function without gotos, with a few comments,
and with the commonly used explicit index/offset. This fixes the problem
and makes it easier to understand as well.

[a.p.zijlstra@chello.nl: add comment]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff -puN fs/exec.c~exec-fix-remove_arg_zero fs/exec.c
--- a/fs/exec.c~exec-fix-remove_arg_zero
+++ a/fs/exec.c
@@ -982,33 +982,51 @@ void compute_creds(struct linux_binprm *
 	task_unlock(current);
 	security_bprm_post_apply_creds(bprm);
 }
-
 EXPORT_SYMBOL(compute_creds);
 
+/*
+ * Arguments are '\0' separated strings found at the location bprm->p
+ * points to; chop off the first by relocating brpm->p to right after
+ * the first '\0' encountered.
+ */
 void remove_arg_zero(struct linux_binprm *bprm)
 {
 	if (bprm->argc) {
-		unsigned long offset;
-		char * kaddr;
-		struct page *page;
+		char ch;
+
+		do {
+			unsigned long offset;
+			unsigned long index;
+			char *kaddr;
+			struct page *page;
 
-		offset = bprm->p % PAGE_SIZE;
-		goto inside;
+			offset = bprm->p & ~PAGE_MASK;
+			index = bprm->p >> PAGE_SHIFT;
 
-		while (bprm->p++, *(kaddr+offset++)) {
-			if (offset != PAGE_SIZE)
-				continue;
-			offset = 0;
-			kunmap_atomic(kaddr, KM_USER0);
-inside:
-			page = bprm->page[bprm->p/PAGE_SIZE];
+			page = bprm->page[index];
 			kaddr = kmap_atomic(page, KM_USER0);
-		}
-		kunmap_atomic(kaddr, KM_USER0);
+
+			/* run through page until we reach end or find NUL */
+			do {
+				ch = *(kaddr + offset);
+
+				/* discard that character... */
+				bprm->p++;
+				offset++;
+			} while (offset < PAGE_SIZE && ch != '\0');
+
+			kunmap_atomic(kaddr, KM_USER0);
+
+			/* free the old page */
+			if (offset == PAGE_SIZE) {
+				__free_page(page);
+				bprm->page[index] = NULL;
+			}
+		} while (ch != '\0');
+
 		bprm->argc--;
 	}
 }
-
 EXPORT_SYMBOL(remove_arg_zero);
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-more-rmap-checking.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
