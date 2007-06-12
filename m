From: akpm@linux-foundation.org
Subject: + fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:57:58 -0700
Message-ID: <200706121957.l5CJvwYO020041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbXFLT6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au


The patch titled
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2
has been added to the -mm tree.  Its filename is
     fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2
From: Nick Piggin <nickpiggin@yahoo.com.au>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/splice.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2 fs/splice.c
--- a/fs/splice.c~fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2
+++ a/fs/splice.c
@@ -585,7 +585,7 @@ static int pipe_to_file(struct pipe_inod
 	if (this_len + offset > PAGE_CACHE_SIZE)
 		this_len = PAGE_CACHE_SIZE - offset;
 
-	ret = pagecache_write_begin(file, mapping, sd->pos, sd->len,
+	ret = pagecache_write_begin(file, mapping, sd->pos, this_len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
 	if (unlikely(ret))
 		goto out;
@@ -602,7 +602,7 @@ static int pipe_to_file(struct pipe_inod
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

unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
ocfs2-release-page-lock-before-calling-page_mkwrite.patch
document-page_mkwrite-locking.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-2.patch
gfs2-convert-to-new-aops.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
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
nick-broke-reiser4-too.patch
