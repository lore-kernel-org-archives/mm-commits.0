Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7BB246781;
	Wed, 22 Jul 2026 00:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784679107; cv=none; b=n+Cu0u66eS9h2g3s9I+EH/wfDLNeUJntJbtNDLI5R45LxwDBrJGboM/DViD1x/9XOYrk93YxfprYg1TbKgWHy+loHe/02m7ajvWuVQd28dXgG7acMPPAp5PvlqS0tBG7k6DXVQhgdEDgHTE3vUDmv094yvvRx4TqZicLrprq6sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784679107; c=relaxed/simple;
	bh=kmbdmW+A3sDlmF2FCFi3vasbjjFsB9FKD3lfyIwEQb4=;
	h=Date:To:From:Subject:Message-Id; b=e8uTEl2y1l4wE73lega/1LjF60Rh4QSX6G/XpeKgAyEKAycWDiHdAPMG86Z9YFeFYdCcJ7xKNBAPTbLgAex6WvUwgiA46tLnPJI1Fb6Y4x1oXrfi93gdIkheAbonzW/6o6TfV/ZpyTukLwoCWzq0LUaJX683vTPEytDiaDfKei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=honkZpyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="honkZpyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494F21F000E9;
	Wed, 22 Jul 2026 00:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784679104;
	bh=iHZVrZmHrArnaNVCQfgsdtP5R0u/v/D9XAj+T3rSmJw=;
	h=Date:To:From:Subject;
	b=honkZpyEwBjEvqYJIP9VVi9CybQdwRkDeLR+YyamWm0UqvpypEGyNO6dZeB7+vleD
	 FcRmOdJ7VQDdr6LcRMA7fbTiXIe/cqEBoRp3jb+tRJtPHDgJJLLnHVZXfJ6IVF1+G0
	 PzGQ0QSDWRw+Ai9NnrVaYi2lDlM0fYSHhhb//uHo=
Date: Tue, 21 Jul 2026 17:11:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-always-run-deallocs-on-copy-on-write-completion.patch added to mm-nonmm-unstable branch
Message-Id: <20260722001144.494F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: always run deallocs on copy-on-write completion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-always-run-deallocs-on-copy-on-write-completion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-always-run-deallocs-on-copy-on-write-completion.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: always run deallocs on copy-on-write completion
Date: Tue, 21 Jul 2026 13:28:40 +0300

Local fuzzing of 6.12.94 has found the following memory leak
caused by doing 'copy_file_range()' within the same filesystem:

unreferenced object 0xffff88812192c980 (size 32):
  comm "syz.0.49", pid 12095, jiffies 4294964143
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00  ................
    c0 c5 92 21 81 88 ff ff 00 02 00 00 00 06 00 00  ...!............
  backtrace (crc 7068d63f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    slab_post_alloc_hook mm/slub.c:4152 [inline]
    slab_alloc_node mm/slub.c:4197 [inline]
    __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
    kmalloc_noprof include/linux/slab.h:878 [inline]
    ocfs2_find_per_slot_free_list fs/ocfs2/alloc.c:6618 [inline]
    ocfs2_cache_block_dealloc+0x155/0x4b0 fs/ocfs2/alloc.c:6786
    ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
    ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
    ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
    __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
    ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
    ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
    ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
    ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
    ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
    ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
    ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
    ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
    ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
    ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
    ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
    iter_file_splice_write+0x890/0xf60 fs/splice.c:743
    do_splice_from fs/splice.c:944 [inline]
    direct_splice_actor+0x232/0x480 fs/splice.c:1167
    splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
    do_splice_direct_actor fs/splice.c:1210 [inline]
    do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
    do_sendfile+0x430/0xbf0 fs/read_write.c:1388

unreferenced object 0xffff88812192c5c0 (size 32):
  comm "syz.0.49", pid 12095, jiffies 4294964143
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    29 70 00 00 00 00 00 00 19 00 00 00 00 00 00 00  )p..............
  backtrace (crc afec850f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    slab_post_alloc_hook mm/slub.c:4152 [inline]
    slab_alloc_node mm/slub.c:4197 [inline]
    __kmalloc_cache_noprof+0x168/0x2c0 mm/slub.c:4358
    kmalloc_noprof include/linux/slab.h:878 [inline]
    kzalloc_noprof include/linux/slab.h:1014 [inline]
    ocfs2_cache_block_dealloc+0x25c/0x4b0 fs/ocfs2/alloc.c:6793
    ocfs2_cache_extent_block_free fs/ocfs2/alloc.c:6819 [inline]
    ocfs2_unlink_path+0x286/0x450 fs/ocfs2/alloc.c:2613
    ocfs2_rotate_subtree_left fs/ocfs2/alloc.c:2779 [inline]
    __ocfs2_rotate_tree_left+0x1f6f/0x2da0 fs/ocfs2/alloc.c:2985
    ocfs2_rotate_tree_left+0x283/0xe00 fs/ocfs2/alloc.c:3237
    ocfs2_try_to_merge_extent+0xf56/0x1a20 fs/ocfs2/alloc.c:3825
    ocfs2_split_extent+0x15f4/0x2940 fs/ocfs2/alloc.c:5138
    ocfs2_clear_ext_refcount+0x2f6/0x550 fs/ocfs2/refcounttree.c:3098
    ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3131 [inline]
    ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
    ocfs2_replace_cow+0x991/0x1660 fs/ocfs2/refcounttree.c:3349
    ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
    ocfs2_refcount_cow+0x5e1/0x9f0 fs/ocfs2/refcounttree.c:3470
    ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
    ocfs2_file_write_iter+0xbda/0x1880 fs/ocfs2/file.c:2451
    iter_file_splice_write+0x890/0xf60 fs/splice.c:743
    do_splice_from fs/splice.c:944 [inline]
    direct_splice_actor+0x232/0x480 fs/splice.c:1167
    splice_direct_to_actor+0x4b4/0xb60 fs/splice.c:1111
    do_splice_direct_actor fs/splice.c:1210 [inline]
    do_splice_direct+0x10f/0x1c0 fs/splice.c:1236
    do_sendfile+0x430/0xbf0 fs/read_write.c:1388

This happens when 'ocfs2_cache_block_dealloc()' called from
'ocfs2_cache_extent_block_free()' uses the suballocator to
schedule extent removal, so 'ocfs2_run_deallocs()' should
be run unconditionally to complete the removal with
'ocfs2_free_cached_blocks()'. An extra semi-automated static
analysis [1] suspects that the same scenario looks possible in
'ocfs2_attach_refcount_tree()' and 'ocfs2_reflink_remap_blocks()'
as well, but, since 'ocfs2_run_deallocs()' is a safe no-op for
an empty dealloc context, 'ocfs2_create_reflink_node()' and
'ocfs2_reflink_xattrs()' may be adjusted in the same way too,
thus keeping the code pattern consistent.

[1] https://lore.kernel.org/ocfs2-devel/f1d7e266-4b44-41b9-98c0-5b3868a8d9c3@yandex.ru

Link: https://lore.kernel.org/20260721102840.387663-1-dmantipov@yandex.ru
Fixes: 6f70fa519976 ("ocfs2: Add CoW support.")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |   20 ++++++++------------
 fs/ocfs2/xattr.c        |    5 ++---
 2 files changed, 10 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-always-run-deallocs-on-copy-on-write-completion
+++ a/fs/ocfs2/refcounttree.c
@@ -3387,10 +3387,9 @@ static int ocfs2_replace_cow(struct ocfs
 		cow_start += num_clusters;
 	}
 
-	if (ocfs2_dealloc_has_cluster(&context->dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&context->dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &context->dealloc);
-	}
+	ocfs2_run_deallocs(osb, &context->dealloc);
 
 	return ret;
 }
@@ -3873,10 +3872,9 @@ unlock:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 
-	if (!ret && ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (!ret && ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
+	ocfs2_run_deallocs(osb, &dealloc);
 out:
 	/*
 	 * Empty the extent map so that we may get the right extent
@@ -4162,10 +4160,9 @@ out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
 out:
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
+	ocfs2_run_deallocs(osb, &dealloc);
 
 	return ret;
 }
@@ -4718,10 +4715,9 @@ loff_t ocfs2_reflink_remap_blocks(struct
 	}
 
 out:
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(osb, 1);
-		ocfs2_run_deallocs(osb, &dealloc);
-	}
+	ocfs2_run_deallocs(osb, &dealloc);
 
 	return ret;
 }
--- a/fs/ocfs2/xattr.c~ocfs2-always-run-deallocs-on-copy-on-write-completion
+++ a/fs/ocfs2/xattr.c
@@ -7424,10 +7424,9 @@ out_unlock:
 				   ref_tree, 1);
 	brelse(ref_root_bh);
 
-	if (ocfs2_dealloc_has_cluster(&dealloc)) {
+	if (ocfs2_dealloc_has_cluster(&dealloc))
 		ocfs2_schedule_truncate_log_flush(OCFS2_SB(old_inode->i_sb), 1);
-		ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
-	}
+	ocfs2_run_deallocs(OCFS2_SB(old_inode->i_sb), &dealloc);
 
 out:
 	return ret;
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch
ocfs2-always-run-deallocs-on-copy-on-write-completion.patch

