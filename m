From: akpm@linux-foundation.org
Subject: - nommu-fix-ksize-abuse.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:01 -0700
Message-ID: <200806081949.m58Jn1Ck017616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbYFHTuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     nommu: fix ksize() abuse
has been removed from the -mm tree.  Its filename was
     nommu-fix-ksize-abuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix ksize() abuse
From: Pekka Enberg <penberg@cs.helsinki.fi>

The nommu binfmt code uses ksize() for pointers returned from do_mmap()
which is wrong.  This converts the call-sites to use the nommu specific
kobjsize() function which works as expected.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    2 +-
 fs/binfmt_flat.c      |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~nommu-fix-ksize-abuse fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~nommu-fix-ksize-abuse
+++ a/fs/binfmt_elf_fdpic.c
@@ -390,7 +390,7 @@ static int load_elf_fdpic_binary(struct 
 	}
 
 	/* expand the stack mapping to use up the entire allocation granule */
-	fullsize = ksize((char *) current->mm->start_brk);
+	fullsize = kobjsize((char *) current->mm->start_brk);
 	if (!IS_ERR_VALUE(do_mremap(current->mm->start_brk, stack_size,
 				    fullsize, 0, 0)))
 		stack_size = fullsize;
diff -puN fs/binfmt_flat.c~nommu-fix-ksize-abuse fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~nommu-fix-ksize-abuse
+++ a/fs/binfmt_flat.c
@@ -548,7 +548,7 @@ static int load_flat_file(struct linux_b
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
 		/* Remap to use all availabe slack region space */
 		if (realdatastart && (realdatastart < (unsigned long)-4096)) {
-			reallen = ksize((void *)realdatastart);
+			reallen = kobjsize((void *)realdatastart);
 			if (reallen > len) {
 				realdatastart = do_mremap(realdatastart, len,
 					reallen, MREMAP_FIXED, realdatastart);
@@ -600,7 +600,7 @@ static int load_flat_file(struct linux_b
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
 		/* Remap to use all availabe slack region space */
 		if (textpos && (textpos < (unsigned long) -4096)) {
-			reallen = ksize((void *)textpos);
+			reallen = kobjsize((void *)textpos);
 			if (reallen > len) {
 				textpos = do_mremap(textpos, len, reallen,
 					MREMAP_FIXED, textpos);
@@ -683,7 +683,7 @@ static int load_flat_file(struct linux_b
 		 */
 		current->mm->start_brk = datapos + data_len + bss_len;
 		current->mm->brk = (current->mm->start_brk + 3) & ~3;
-		current->mm->context.end_brk = memp + ksize((void *) memp) - stack_len;
+		current->mm->context.end_brk = memp + kobjsize((void *) memp) - stack_len;
 	}
 
 	if (flags & FLAT_FLAG_KTRACE)
@@ -790,7 +790,7 @@ static int load_flat_file(struct linux_b
 
 	/* zero the BSS,  BRK and stack areas */
 	memset((void*)(datapos + data_len), 0, bss_len + 
-			(memp + ksize((void *) memp) - stack_len -	/* end brk */
+			(memp + kobjsize((void *) memp) - stack_len -	/* end brk */
 			libinfo->lib_list[id].start_brk) +		/* start brk */
 			stack_len);
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
linux-next.patch
git-unionfs.patch
git-pekka.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
clean-up-duplicated-alloc-free_thread_info.patch
slab-leaks3-default-y.patch

