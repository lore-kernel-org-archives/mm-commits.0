From: akpm@linux-foundation.org
Subject: + exec-fix-remove_arg_zero.patch added to -mm tree
Date: Wed, 28 Feb 2007 23:41:36 -0800
Message-ID: <200703010741.l217fase007752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXCAHln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 02:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ptesarik@suse.cz


The patch titled
     exec: fix remove_arg_zero
has been added to the -mm tree.  Its filename is
     exec-fix-remove_arg_zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~exec-fix-remove_arg_zero fs/exec.c
--- a/fs/exec.c~exec-fix-remove_arg_zero
+++ a/fs/exec.c
@@ -988,23 +988,38 @@ EXPORT_SYMBOL(compute_creds);
 void remove_arg_zero(struct linux_binprm *bprm)
 {
 	if (bprm->argc) {
-		unsigned long offset;
-		char * kaddr;
-		struct page *page;
+		char ch;
 
-		offset = bprm->p % PAGE_SIZE;
-		goto inside;
+		do {
+			unsigned long offset;
+			unsigned long index;
+			char *kaddr;
+			struct page *page;
 
-		while (bprm->p++, *(kaddr+offset++)) {
-			if (offset != PAGE_SIZE)
-				continue;
-			offset = 0;
-			kunmap_atomic(kaddr, KM_USER0);
-inside:
-			page = bprm->page[bprm->p/PAGE_SIZE];
+			offset = bprm->p & ~PAGE_MASK;
+			index = bprm->p >> PAGE_SHIFT;
+
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
_

Patches currently in -mm which might be from npiggin@suse.de are

ia64-permon-use-after-free-fix.patch
git-block.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
exec-fix-remove_arg_zero.patch
