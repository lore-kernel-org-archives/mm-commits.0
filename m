From: akpm@linux-foundation.org
Subject: + revoke-core-code-break-cow-fixes.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:57:39 -0700
Message-ID: <200703282357.l2SNvdYE023200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965801AbXC1X5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au


The patch titled
     revoke: break cow fixes
has been added to the -mm tree.  Its filename is
     revoke-core-code-break-cow-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: break cow fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Nick Piggin, __revoke_break_cow() only needs to do
down_read() and we must use vma_pages() for get_user_pages().

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-break-cow-fixes fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-break-cow-fixes
+++ a/fs/revoke.c
@@ -185,7 +185,7 @@ static int __revoke_break_cow(struct tas
 	struct vm_area_struct *vma;
 	int err = 0;
 
-	down_write(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
 		int ret;
 
@@ -196,14 +196,13 @@ static int __revoke_break_cow(struct tas
 			continue;
 
 		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
-				     vma->vm_end-vma->vm_start, 1, 1, NULL,
-				     NULL);
+				     vma_pages(vma), 1, 1, NULL, NULL);
 		if (ret < 0) {
 			err = ret;
 			break;
 		}
 	}
-	up_write(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return err;
 }
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
