From: akpm@linux-foundation.org
Subject: - fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:39:54 -0700
Message-ID: <200707092039.l69KdsSm010067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbXGIUkB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:40:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2
has been removed from the -mm tree.  Its filename was
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch

This patch was dropped because it was folded into fs-introduce-write_begin-write_end-and-perform_write-aops.patch

------------------------------------------------------
Subject: fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2
From: Nick Piggin <nickpiggin@yahoo.com.au>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/splice.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2 fs/splice.c
--- a/fs/splice.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2
+++ a/fs/splice.c
@@ -584,7 +584,7 @@ static int pipe_to_file(struct pipe_inod
 	if (this_len + offset > PAGE_CACHE_SIZE)
 		this_len = PAGE_CACHE_SIZE - offset;
 
-	ret = pagecache_write_begin(file, mapping, sd->pos, sd->len,
+	ret = pagecache_write_begin(file, mapping, sd->pos, this_len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
 	if (unlikely(ret))
 		goto out;
@@ -601,7 +601,7 @@ static int pipe_to_file(struct pipe_inod
 		kunmap_atomic(dst, KM_USER1);
 		buf->ops->unmap(pipe, buf, src);
 	}
-	ret = pagecache_write_end(file, mapping, sd->pos, sd->len, sd->len,
+	ret = pagecache_write_end(file, mapping, sd->pos, this_len, this_len,
 				page, fsdata);
 out:
 	return ret;
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

convert-hugetlbfs-to-use-vm_ops-fault.patch
ocfs2-release-page-lock-before-calling-page_mkwrite.patch
document-page_mkwrite-locking.patch
madvise_need_mmap_write-usage.patch
slob-initial-numa-support.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-5.patch
gfs2-convert-to-new-aops.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
nfs-invariant-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
buffer-kill-old-incorrect-comment.patch
sched2-sched-domain-sysctl.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
