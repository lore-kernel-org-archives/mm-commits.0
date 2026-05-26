Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF003BFE24;
	Tue, 26 May 2026 20:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779827738; cv=none; b=Qnb4ep3JFv260//2zkVT8LV0ly/a6wffvGp7Yc2JQ3n4zqsFY89FOk4hJS6hA+rWOlkL/8i+hN7jkIj29ygLDSjqGPw+48Lo6QNYsR1c1jtbeVXp24MpYKUeMseuldoggHGlqhLGnJw7edwTr5dZODEPBngzsjrrftjcyazS9bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779827738; c=relaxed/simple;
	bh=zeQfcwiO7GbGf+4UeIbYXdwwQ4GwxpHeV4sjlDCVrtw=;
	h=Date:To:From:Subject:Message-Id; b=UBOxw+NcxY2o8AafuOJrKH23t9guqB8GKNcSQfFGxqpScY8PHIWC7+P737ePY+bfi7H6TpckJw4kTKAEZRGDrmSoWbeKy9fug/2PY+SwRhWj462Ggu96pZqSYOfOCh/1lTrTsK+4pMrqdCAbOAaGLtFvHtT7M+1/RQBojL1xWy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CS3lFdHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CS3lFdHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD231F000E9;
	Tue, 26 May 2026 20:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779827733;
	bh=NI6Cevn4t5LfSit16kYqKoentdpyGeg/mvaYnNzj5b0=;
	h=Date:To:From:Subject;
	b=CS3lFdHY4eNzECPJkRRYOcof1R0NlrOw/n0oXgqGfmWcBQQ4HtYxyTz1DEoZNAgH+
	 3tpbYOol4C1ATBP7ZDdQqss+ilnveb+ZGZpZdbKISM3PsqLFnXIX40b/OxY69GpyLI
	 M/u/aFrh+8LB6Ta7yguJ7L8Dkn4JBw9XbWnHwdtw=
Date: Tue, 26 May 2026 13:35:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,rollkingzzc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-oversized-group-bitmap-descriptors.patch added to mm-nonmm-unstable branch
Message-Id: <20260526203532.DBD231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject oversized group bitmap descriptors
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-oversized-group-bitmap-descriptors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-oversized-group-bitmap-descriptors.patch

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
From: Zhang Cen <rollkingzzc@gmail.com>
Subject: ocfs2: reject oversized group bitmap descriptors
Date: Sun, 24 May 2026 19:12:48 +0800

ocfs2_validate_gd_parent() only bounds bg_bits against the parent
allocator's chain geometry.  A malicious descriptor can still claim a
bg_size/bg_bits pair that exceeds the bitmap bytes that physically fit in
the group descriptor block, so later bitmap scans and bit updates can run
past bg_bitmap.

Add a physical-cap check based on ocfs2_group_bitmap_size() for the parent
allocator type and reject descriptors whose bg_size or bg_bits exceed that
capacity.  Keep the existing chain geometry check so both the on-disk
bitmap layout and the allocator metadata must agree before the descriptor
is used.

Validation reproduced this kernel report:
KASAN use-after-free in _find_next_bit+0x7f/0xc0
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xd0/0x630 (?:?)
  _find_next_bit+0x7f/0xc0 (?:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x188/0x2f0 (?:?)
  kasan_report+0xe4/0x120 (?:?)
  ocfs2_find_max_contig_free_bits+0x35/0x70 (fs/ocfs2/suballoc.c:1375)
  ocfs2_block_group_set_bits+0x472/0x4b0 (fs/ocfs2/suballoc.c:1457)
  ocfs2_cluster_group_search+0x16b/0x440 (fs/ocfs2/suballoc.c:86)
  ocfs2_bg_discontig_fix_result+0x1ef/0x230 (fs/ocfs2/suballoc.c:1786)
  ocfs2_search_chain+0x8f8/0x10a0 (fs/ocfs2/suballoc.c:1886)
  get_page_from_freelist+0x70e/0x2370 (?:?)
  lock_release+0xc6/0x290 (?:?)
  do_raw_spin_unlock+0x9a/0x100 (?:?)
  kasan_unpoison+0x27/0x60 (?:?)
  __bfs+0x147/0x240 (?:?)
  get_page_from_freelist+0x83d/0x2370 (?:?)
  ocfs2_claim_suballoc_bits+0x38c/0xe70 (fs/ocfs2/suballoc.c:96)
  sched_domains_numa_masks_clear+0x70/0xd0 (?:?)
  check_irq_usage+0xe8/0xb70 (?:?)
  __ocfs2_claim_clusters+0x18d/0x4c0 (fs/ocfs2/suballoc.c:2497)
  check_path+0x24/0x50 (?:?)
  rcu_is_watching+0x20/0x50 (?:?)
  check_prev_add+0xfd/0xd00 (?:?)
  ocfs2_add_clusters_in_btree+0x17d/0x810 (fs/ocfs2/suballoc.c:?)
  __folio_batch_add_and_move+0x1f5/0x3d0 (?:?)
  ocfs2_add_inode_data+0xd9/0x120 (fs/ocfs2/suballoc.c:?)
  filemap_add_folio+0x105/0x1f0 (?:?)
  ocfs2_write_begin_nolock+0x29f7/0x2f80 (fs/ocfs2/suballoc.c:3043)
  ocfs2_read_inode_block+0xb5/0x110 (fs/ocfs2/suballoc.c:?)
  down_write+0xf5/0x180 (?:?)
  ocfs2_write_begin+0x180/0x240 (fs/ocfs2/suballoc.c:?)
  __mark_inode_dirty+0x758/0x9a0 (?:?)
  inode_to_bdi+0x41/0x90 (?:?)
  balance_dirty_pages_ratelimited_flags+0xf8/0x1d0 (?:?)
  generic_perform_write+0x252/0x440 (?:?)
  mnt_put_write_access_file+0x16/0x70 (?:?)
  file_update_time_flags+0xe4/0x200 (?:?)
  ocfs2_file_write_iter+0x80a/0x1320 (fs/ocfs2/suballoc.c:?)
  lock_acquire+0x184/0x2f0 (?:?)
  ksys_write+0xd2/0x170 (?:?)
  apparmor_file_permission+0xf5/0x310 (?:?)
  read_zero+0x8d/0x140 (?:?)
  lock_is_held_type+0x8f/0x100 (?:?)

Link: https://lore.kernel.org/20260524111248.1429884-1-rollkingzzc@gmail.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
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

 fs/ocfs2/suballoc.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/ocfs2/suballoc.c~ocfs2-reject-oversized-group-bitmap-descriptors
+++ a/fs/ocfs2/suballoc.c
@@ -231,8 +231,16 @@ static int ocfs2_validate_gd_parent(stru
 				    int resize)
 {
 	unsigned int max_bits;
+	unsigned int max_bitmap_bits;
+	unsigned int max_bitmap_size;
+	int suballocator;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
+	suballocator = le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno;
+	max_bitmap_size = ocfs2_group_bitmap_size(sb, suballocator,
+						  OCFS2_SB(sb)->s_feature_incompat);
+	max_bitmap_bits = max_bitmap_size * 8;
+
 	if (di->i_blkno != gd->bg_parent_dinode) {
 		do_error("Group descriptor #%llu has bad parent pointer (%llu, expected %llu)\n",
 			 (unsigned long long)bh->b_blocknr,
@@ -240,6 +248,20 @@ static int ocfs2_validate_gd_parent(stru
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
 	}
 
+	if (le16_to_cpu(gd->bg_size) > max_bitmap_size) {
+		do_error("Group descriptor #%llu has bitmap size %u but physical max of %u\n",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_size),
+			 max_bitmap_size);
+	}
+
+	if (le16_to_cpu(gd->bg_bits) > max_bitmap_bits) {
+		do_error("Group descriptor #%llu has bit count %u but physical max of %u\n",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_bits),
+			 max_bitmap_bits);
+	}
+
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
 		do_error("Group descriptor #%llu has bit count of %u\n",
_

Patches currently in -mm which might be from rollkingzzc@gmail.com are

ocfs2-rebase-copied-fsdlm-lvb-pointers-in-locking_state.patch
ocfs2-reject-oversized-group-bitmap-descriptors.patch

