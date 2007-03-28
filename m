From: akpm@linux-foundation.org
Subject: + revoke-core-code-generic_file_revoke-stub-for-nommu.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:50:41 -0700
Message-ID: <200703282350.l2SNofIf023078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965811AbXC1Xut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, bryan.wu@analog.com


The patch titled
     revoke: generic_file_revoke stub for NOMMU
has been added to the -mm tree.  Its filename is
     revoke-core-code-generic_file_revoke-stub-for-nommu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+)

diff -puN include/linux/fs.h~revoke-core-code-generic_file_revoke-stub-for-nommu include/linux/fs.h
--- a/include/linux/fs.h~revoke-core-code-generic_file_revoke-stub-for-nommu
+++ a/include/linux/fs.h
@@ -1752,7 +1752,11 @@ extern long do_splice_direct(struct file
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
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
