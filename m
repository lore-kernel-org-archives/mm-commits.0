From: akpm@linux-foundation.org
Subject: - module-use-krealloc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:14 -0700
Message-ID: <200705090245.l492jEgH008718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968787AbXEICpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     module: use krealloc
has been removed from the -mm tree.  Its filename was
     module-use-krealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: module: use krealloc
From: Pekka Enberg <penberg@cs.helsinki.fi>

This converts an open-coded krealloc() to use the shiny new API.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/module.c~module-use-krealloc kernel/module.c
--- a/kernel/module.c~module-use-krealloc
+++ a/kernel/module.c
@@ -310,14 +310,14 @@ static int split_block(unsigned int i, u
 {
 	/* Reallocation required? */
 	if (pcpu_num_used + 1 > pcpu_num_allocated) {
-		int *new = kmalloc(sizeof(new[0]) * pcpu_num_allocated*2,
-				   GFP_KERNEL);
+		int *new;
+
+		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
+			       GFP_KERNEL);
 		if (!new)
 			return 0;
 
-		memcpy(new, pcpu_size, sizeof(new[0])*pcpu_num_allocated);
 		pcpu_num_allocated *= 2;
-		kfree(pcpu_size);
 		pcpu_size = new;
 	}
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
unionfs-fix-slab-abuses-with-krealloc.patch
swsusp-use-reasonable-default-for-hibernation_mode.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
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
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
