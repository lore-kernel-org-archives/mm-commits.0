From: akpm@linux-foundation.org
Subject: + revoke-core-code-only-fput-unused-files.patch added to -mm tree
Date: Thu, 19 Apr 2007 14:06:50 -0700
Message-ID: <200704192106.l3JL6oJ3030655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766991AbXDSVGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 17:06:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi


The patch titled
     revoke: only fput unused files
has been added to the -mm tree.  Its filename is
     revoke-core-code-only-fput-unused-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: only fput unused files
From: Pekka Enberg <penberg@cs.helsinki.fi>

We should do fput only to files that were not used by the revoke operation.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-only-fput-unused-files fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-only-fput-unused-files
+++ a/fs/revoke.c
@@ -130,7 +130,6 @@ static int revoke_fds(struct task_struct
 		}
 
 		new_filp = revoke_table_get(table);
-		get_file(new_filp);
 
 		/*
 		 * Replace original struct file pointer with a pointer to
@@ -487,7 +486,7 @@ static void free_revoke_table(struct rev
 {
 	int i;
 
-	for (i = 0; i < table->size; i++)
+	for (i = table->end; i < table->size; i++)
 		fput(table->files[i]);
 
 	kfree(table->files);
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
slab-mark-set_up_list3s-__init.patch
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
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
slab-leaks3-default-y.patch
