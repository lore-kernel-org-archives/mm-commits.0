From: akpm@linux-foundation.org
Subject: + readahead-introduce-fmode_random-for-posix_fadv_random.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:51:01 -0800
Message-ID: <201001270051.o0R0p1SU000981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395Ab0A0AxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, Trond.Myklebust@netapp.com, andi@firstfloor.org, chuck.lever@oracle.com, corbet@lwn.net, dhowells@redhat.com, hch@infradead.org, npiggin@suse.de, qbarnes+nfs@yahoo-inc.com, stable@kernel.org, swhiteho@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM
has been added to the -mm tree.  Its filename is
     readahead-introduce-fmode_random-for-posix_fadv_random.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
+#define FMODE_RANDOM		((__force fmode_t)0x1000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)8388608)
 
diff -puN mm/fadvise.c~readahead-introduce-fmode_random-for-posix_fadv_random mm/fadvise.c
--- a/mm/fadvise.c~readahead-introduce-fmode_random-for-posix_fadv_random
+++ a/mm/fadvise.c
@@ -77,12 +77,20 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		file->f_ra.ra_pages = 0;
+		spin_lock(&file->f_lock);
+		file->f_flags |= FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
 		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_flags &= ~FMODE_RANDOM;
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
devmem-check-vmalloc-address-on-kmem-read-write.patch
devmem-fix-kmem-write-bug-on-memory-holes.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
resources-introduce-generic-page_is_ram.patch
resources-introduce-generic-page_is_ram-fix.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch

