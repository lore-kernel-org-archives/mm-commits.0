From: akpm@linux-foundation.org
Subject: - revoke-core-code-only-fput-unused-files.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:59 -0700
Message-ID: <200705090955.l499txQ3020542@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604AbXEIJ4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: only fput unused files
has been removed from the -mm tree.  Its filename was
     revoke-core-code-only-fput-unused-files.patch

This patch was dropped because it was folded into revoke-core-code.patch

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

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
