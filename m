From: akpm@linux-foundation.org
Subject: [merged] readahead-introduce-fmode_random-for-posix_fadv_random.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:57 -0800
Message-ID: <201003091903.o29J3vKX031006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755832Ab0CITE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, Trond.Myklebust@netapp.com, andi@firstfloor.org, chuck.lever@oracle.com, corbet@lwn.net, dhowells@redhat.com, hch@infradead.org, npiggin@suse.de, qbarnes+nfs@y


The patch titled
     readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM
has been removed from the -mm tree.  Its filename was
     readahead-introduce-fmode_random-for-posix_fadv_random.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM
From: Wu Fengguang <fengguang.wu@intel.com>

This fixes inefficient page-by-page reads on POSIX_FADV_RANDOM.

POSIX_FADV_RANDOM used to set ra_pages=0, which leads to poor performance:
a 16K read will be carried out in 4 _sync_ 1-page reads.

In other places, ra_pages==0 means
- it's ramfs/tmpfs/hugetlbfs/sysfs/configfs
- some IO error happened
where multi-page read IO won't help or should be avoided.

POSIX_FADV_RANDOM actually want a different semantics: to disable the
*heuristic* readahead algorithm, and to use a dumb one which faithfully
submit read IO for whatever application requests.

So introduce a flag FMODE_RANDOM for POSIX_FADV_RANDOM.

Note that the random hint is not likely to help random reads performance
noticeably.  And it may be too permissive on huge request size (its IO
size is not limited by read_ahead_kb).

In Quentin's report (http://lkml.org/lkml/2009/12/24/145), the overall
(NFS read) performance of the application increased by 313%!

Tested-by: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@kernel.org>			[2.6.33.x]
Cc: <qbarnes+nfs@yahoo-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    3 +++
 mm/fadvise.c       |   10 +++++++++-
 mm/readahead.c     |    6 ++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/fs.h~readahead-introduce-fmode_random-for-posix_fadv_random include/linux/fs.h
--- a/include/linux/fs.h~readahead-introduce-fmode_random-for-posix_fadv_random
+++ a/include/linux/fs.h
@@ -87,6 +87,9 @@ struct inodes_stat_t {
  */
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
+/* Expect random access pattern */
+#define FMODE_RANDOM		((__force fmode_t)4096)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
diff -puN mm/fadvise.c~readahead-introduce-fmode_random-for-posix_fadv_random mm/fadvise.c
--- a/mm/fadvise.c~readahead-introduce-fmode_random-for-posix_fadv_random
+++ a/mm/fadvise.c
@@ -77,12 +77,20 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		spin_lock(&file->f_lock);
+		file->f_mode |= FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		if (!mapping->a_ops->readpage) {
diff -puN mm/readahead.c~readahead-introduce-fmode_random-for-posix_fadv_random mm/readahead.c
--- a/mm/readahead.c~readahead-introduce-fmode_random-for-posix_fadv_random
+++ a/mm/readahead.c
@@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
 	if (!ra->ra_pages)
 		return;
 
+	/* be dumb */
+	if (filp->f_mode & FMODE_RANDOM) {
+		force_page_cache_readahead(mapping, filp, offset, req_size);
+		return;
+	}
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
 }
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-improve-writeback_inodes_wb.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch
vfs-add-super-operation-writeback_inodes.patch

