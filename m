From: akpm@linux-foundation.org
Subject: + fs-do-not-prefault-sys_write-user-buffer-pages.patch added to
 -mm tree
Date: Tue, 14 Jul 2015 14:20:55 -0700
Message-ID: <55a57d37.zCHxRZ2CkkS7Iv41%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbGNVU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 17:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, ak@linux.intel.com, axboe@fb.com, cassella@cray.com, gthelen@google.com, matthew.r.wilcox@intel.com, mhocko@suse.cz, neilb@suse.de, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: do not prefault sys_write() user buffer pages
has been added to the -mm tree.  Its filename is
     fs-do-not-prefault-sys_write-user-buffer-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-do-not-prefault-sys_write-user-buffer-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-do-not-prefault-sys_write-user-buffer-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: fs: do not prefault sys_write() user buffer pages

=== Short summary ====

iov_iter_fault_in_readable() works around a really rare case and we can
avoid the deadlock it addresses in another way: disable page faults and
work around copy failures by faulting after the copy in a slow path
instead of before in a hot one.

I have a little microbenchmark that does repeated, small writes to tmpfs. 
This patch speeds that micro up by 6.2%.

=== Long version ===

When doing a sys_write() we have a source buffer in userspace and then a
target file page.

If both of those are the same physical page, there is a potential deadlock
that we avoid.  It would happen something like this:

1. We start the write to the file
2. Allocate page cache page and set it !Uptodate
3. Touch the userspace buffer to copy in the user data
4. Page fault (since source of the write not yet mapped)
5. Page fault code tries to lock the page and deadlocks

(more details on this below)

To avoid this, we prefault the page to guarantee that this fault does not
occur.  But, this prefault comes at a cost.  It is one of the most
expensive things that we do in a hot write() path (especially if we
compare it to the read path).  It is working around a pretty rare case.

To fix this, it's pretty simple.  We move the "prefault" code to run after
we attempt the copy.  We explicitly disable page faults _during_ the copy,
detect the copy failure, then execute the "prefault" ouside of where the
page lock needs to be held.

iov_iter_copy_from_user_atomic() actually already has an implicit
pagefault_disable() inside of it (at least on x86), but we add an explicit
one.  I don't think we can depend on every kmap_atomic() implementation to
pagefault_disable() for eternity.

===================================================

The stack trace when this happens looks like this:

[<ffffffff81172130>] wait_on_page_bit_killable+0xc0/0xd0
[<ffffffff811721c4>] __lock_page_or_retry+0x84/0xa0
[<ffffffff811723cd>] filemap_fault+0x1ed/0x3d0
[<ffffffff81197841>] __do_fault+0x41/0xc0
[<ffffffff8119b8db>] handle_mm_fault+0x9bb/0x1210
[<ffffffff8109945f>] __do_page_fault+0x17f/0x3d0
[<ffffffff810996bc>] do_page_fault+0xc/0x10
[<ffffffff8183ba92>] page_fault+0x22/0x30
[<ffffffff8116ff1a>] generic_perform_write+0xca/0x1a0
[<ffffffff81171e30>] __generic_file_write_iter+0x190/0x1f0
[<ffffffff8126d659>] ext4_file_write_iter+0xe9/0x460
[<ffffffff811d027a>] __vfs_write+0xaa/0xe0
[<ffffffff811d0ae6>] vfs_write+0xa6/0x1a0
[<ffffffff811d1726>] SyS_write+0x46/0xa0
[<ffffffff81839f17>] entry_SYSCALL_64_fastpath+0x12/0x6a
[<ffffffffffffffff>] 0xffffffffffffffff

(Note, this does *NOT* happen in practice today because
 the kmap_atomic() does a pagefault_disable().  The trace
 above was obtained by taking out the pagefault_disable().)

You can trigger the deadlock with this little code snippet:

	fd = open("foo", O_RDWR);
	fdmap = mmap(NULL, len, PROT_WRITE|PROT_READ, MAP_SHARED, fd, 0);
	write(fd, &fdmap[0], 1);

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Paul Cassella <cassella@cray.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN mm/filemap.c~fs-do-not-prefault-sys_write-user-buffer-pages mm/filemap.c
--- a/mm/filemap.c~fs-do-not-prefault-sys_write-user-buffer-pages
+++ a/mm/filemap.c
@@ -2473,21 +2473,6 @@ ssize_t generic_perform_write(struct fil
 						iov_iter_count(i));
 
 again:
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 *
-		 * Not only is this an optimisation, but it is also required
-		 * to check that the address is actually valid, when atomic
-		 * usercopies are used, below.
-		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
-			status = -EFAULT;
-			break;
-		}
-
 		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
 						&page, &fsdata);
 		if (unlikely(status < 0))
@@ -2495,8 +2480,17 @@ again:
 
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
-
+		/*
+		 * 'page' is now locked.  If we are trying to copy from a
+		 * mapping of 'page' in userspace, the copy might fault and
+		 * would need PageUptodate() to complete.  But, page can not be
+		 * made Uptodate without acquiring the page lock, which we hold.
+		 * Deadlock.  Avoid with pagefault_disable().  Fix up below with
+		 * iov_iter_fault_in_readable().
+		 */
+		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
+		pagefault_enable();
 		flush_dcache_page(page);
 
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
@@ -2519,6 +2513,14 @@ again:
 			 */
 			bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
 						iov_iter_single_seg_count(i));
+			/*
+			 * This is the fallback to recover if the copy from
+			 * userspace above faults.
+			 */
+			if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+				status = -EFAULT;
+				break;
+			}
 			goto again;
 		}
 		pos += copied;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
fs-do-not-prefault-sys_write-user-buffer-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

