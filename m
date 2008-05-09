From: akpm@linux-foundation.org
Subject: + fuse-add-flag-to-turn-on-big-writes.patch added to -mm tree
Date: Fri, 09 May 2008 14:05:44 -0700
Message-ID: <200805092105.m49L5iYB025582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472AbYEIVHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, szaka@ntfs-3g.org


The patch titled
     fuse: add flag to turn on big writes
has been added to the -mm tree.  Its filename is
     fuse-add-flag-to-turn-on-big-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: add flag to turn on big writes
From: Miklos Szeredi <mszeredi@suse.cz>

Prior to 2.6.26 fuse only supported single page write requests.  In theory all
fuse filesystem should be able support bigger than 4k writes, as there's
nothing in the API to prevent it.  Unfortunately there's a known case in
NTFS-3G where big writes cause filesystem corruption.  There could also be
other filesystems, where the lack of testing with big write requests would
result in bugs.

To prevent such problems on a kernel upgrade, disable big writes by default,
but let filesystems set a flag to turn it on.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c       |    2 ++
 fs/fuse/fuse_i.h     |    3 +++
 fs/fuse/inode.c      |    5 ++++-
 include/linux/fuse.h |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/fuse/file.c~fuse-add-flag-to-turn-on-big-writes fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-add-flag-to-turn-on-big-writes
+++ a/fs/fuse/file.c
@@ -804,6 +804,8 @@ static ssize_t fuse_fill_write_pages(str
 		if (offset == PAGE_CACHE_SIZE)
 			offset = 0;
 
+		if (!fc->big_writes)
+			break;
 	} while (iov_iter_count(ii) && count < fc->max_write &&
 		 req->num_pages < FUSE_MAX_PAGES_PER_REQ && offset == 0);
 
diff -puN fs/fuse/fuse_i.h~fuse-add-flag-to-turn-on-big-writes fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-add-flag-to-turn-on-big-writes
+++ a/fs/fuse/fuse_i.h
@@ -404,6 +404,9 @@ struct fuse_conn {
 	/** Is bmap not implemented by fs? */
 	unsigned no_bmap : 1;
 
+	/** Do multi-page cached writes */
+	unsigned big_writes : 1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff -puN fs/fuse/inode.c~fuse-add-flag-to-turn-on-big-writes fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-flag-to-turn-on-big-writes
+++ a/fs/fuse/inode.c
@@ -576,6 +576,8 @@ static void process_init_reply(struct fu
 				fc->no_lock = 1;
 			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
 				fc->atomic_o_trunc = 1;
+			if (arg->flags & FUSE_BIG_WRITES)
+				fc->big_writes = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -599,7 +601,8 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
+		FUSE_BIG_WRITES;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff -puN include/linux/fuse.h~fuse-add-flag-to-turn-on-big-writes include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-add-flag-to-turn-on-big-writes
+++ a/include/linux/fuse.h
@@ -109,6 +109,7 @@ struct fuse_file_lock {
 #define FUSE_POSIX_LOCKS	(1 << 1)
 #define FUSE_FILE_OPS		(1 << 2)
 #define FUSE_ATOMIC_O_TRUNC	(1 << 3)
+#define FUSE_BIG_WRITES		(1 << 5)
 
 /**
  * Release flags
_

Patches currently in -mm which might be from mszeredi@suse.cz are

ecryptfs-clean-up-unlock_parent.patch
fuse-add-flag-to-turn-on-big-writes.patch
git-block.patch
git-vfs-cleanups.patch
mm-fix-infinite-loop-in-filemap_fault.patch

