From: akpm@linux-foundation.org
Subject: - revoke-core-code-generic_file_revoke-stub-for-nommu.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:53 -0700
Message-ID: <200705090955.l499trA8020533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757256AbXEIJ4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     revoke: generic_file_revoke stub for NOMMU
has been removed from the -mm tree.  Its filename was
     revoke-core-code-generic_file_revoke-stub-for-nommu.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: generic_file_revoke stub for NOMMU
From: Pekka Enberg <penberg@cs.helsinki.fi>

As NOMMU does not include fs/revoke.c, we need to provide a stub for
generic_file_revoke() so that filesystems using it compile.

Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/fs.h~revoke-core-code-generic_file_revoke-stub-for-nommu include/linux/fs.h
--- a/include/linux/fs.h~revoke-core-code-generic_file_revoke-stub-for-nommu
+++ a/include/linux/fs.h
@@ -1756,7 +1756,11 @@ extern long do_splice_direct(struct file
 		size_t len, unsigned int flags);
 
 /* fs/revoke.c */
+#ifdef CONFIG_MMU
 extern int generic_file_revoke(struct file *);
+#else
+#define generic_file_revoke NULL
+#endif
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
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
