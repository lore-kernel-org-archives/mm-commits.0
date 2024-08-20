Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A1236B0D
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131184; cv=none; b=D8eNfwiG9xA+SNYADSYWcDfj9k3dugZcW+HLJ8/NM0xKz6zRvWGxqURQugL9FOSWWDgRIOPqWPzU2N2Slcf2MB9WHm9bu1d6sFG974hMEAxPR83ssO6ehpaHrNtYclo3lAVli8g9hH8y0o9uCHYVIFET4i/fZnxttPZ+RFwiSLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131184; c=relaxed/simple;
	bh=wRLhHPiuf1ohQgv0moTEVYTT3MBzIRTZ1UiaTgfs+UQ=;
	h=Date:To:From:Subject:Message-Id; b=pBhmawFd2UdOn1EV25+TTuLxlEdoT2764UAScqo+av/d95HlIvFmx7KNhcTHXpSSIDvdEwQEXnZzP6suuIILSCJyr+FT30YJGIPC6hDGNvGidOJr4WSQUZpdXnb/A1wtMsoVd9g1u5uRhTeejG/78AiN5navUEVdji5PqVxH8XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DluSt9gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DluSt9gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61243C4AF09;
	Tue, 20 Aug 2024 05:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724131183;
	bh=wRLhHPiuf1ohQgv0moTEVYTT3MBzIRTZ1UiaTgfs+UQ=;
	h=Date:To:From:Subject:From;
	b=DluSt9ggwiAYJWqzaNndoVU3Fh71MQIxMUez3r6OukZNCKZiEWwTmsuBjMwGI3zSw
	 00FlQmDuG2NDOsMJHh9IoBMMoJGerRyZbr8KSA51XttMXL7tGhzHq8+qPLi3teHLzA
	 PlCXZA9cm7004m56kcZAkPm1lVyiFoat4PCjem54=
Date: Mon, 19 Aug 2024 22:19:42 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jserv@ccns.ncku.edu.tw,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20240820051943.61243C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove custom swap functions in favor of built-in sort swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: ocfs2: remove custom swap functions in favor of built-in sort swap
Date: Sun, 11 Aug 2024 03:53:16 +0800

The custom swap functions used in ocfs2 do not perform any special
operations and can be replaced with the built-in swap function of sort. 
This change not only reduces code size but also improves efficiency,
especially in scenarios where CONFIG_RETPOLINE is enabled, as it makes
indirect function calls more expensive.

By using the built-in swap, we avoid these costly indirect function calls,
leading to better performance.

Link: https://lkml.kernel.org/r/20240810195316.186504-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c          |   12 +-----------
 fs/ocfs2/refcounttree.c |   13 +++----------
 fs/ocfs2/xattr.c        |   15 +++------------
 3 files changed, 7 insertions(+), 33 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap
+++ a/fs/ocfs2/dir.c
@@ -3511,16 +3511,6 @@ static int dx_leaf_sort_cmp(const void *
 	return 0;
 }
 
-static void dx_leaf_sort_swap(void *a, void *b, int size)
-{
-	struct ocfs2_dx_entry *entry1 = a;
-	struct ocfs2_dx_entry *entry2 = b;
-
-	BUG_ON(size != sizeof(*entry1));
-
-	swap(*entry1, *entry2);
-}
-
 static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
 {
 	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
@@ -3781,7 +3771,7 @@ static int ocfs2_dx_dir_rebalance(struct
 	 */
 	sort(dx_leaf->dl_list.de_entries, num_used,
 	     sizeof(struct ocfs2_dx_entry), dx_leaf_sort_cmp,
-	     dx_leaf_sort_swap);
+	     NULL);
 
 	ocfs2_journal_dirty(handle, dx_leaf_bh);
 
--- a/fs/ocfs2/refcounttree.c~ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap
+++ a/fs/ocfs2/refcounttree.c
@@ -1392,13 +1392,6 @@ static int cmp_refcount_rec_by_cpos(cons
 	return 0;
 }
 
-static void swap_refcount_rec(void *a, void *b, int size)
-{
-	struct ocfs2_refcount_rec *l = a, *r = b;
-
-	swap(*l, *r);
-}
-
 /*
  * The refcount cpos are ordered by their 64bit cpos,
  * But we will use the low 32 bit to be the e_cpos in the b-tree.
@@ -1474,7 +1467,7 @@ static int ocfs2_divide_leaf_refcount_bl
 	 */
 	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
-	     cmp_refcount_rec_by_low_cpos, swap_refcount_rec);
+	     cmp_refcount_rec_by_low_cpos, NULL);
 
 	ret = ocfs2_find_refcount_split_pos(rl, &cpos, &split_index);
 	if (ret) {
@@ -1499,11 +1492,11 @@ static int ocfs2_divide_leaf_refcount_bl
 
 	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
-	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
+	     cmp_refcount_rec_by_cpos, NULL);
 
 	sort(&new_rl->rl_recs, le16_to_cpu(new_rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
-	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
+	     cmp_refcount_rec_by_cpos, NULL);
 
 	*split_cpos = cpos;
 	return 0;
--- a/fs/ocfs2/xattr.c~ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap
+++ a/fs/ocfs2/xattr.c
@@ -4167,15 +4167,6 @@ static int cmp_xe(const void *a, const v
 	return 0;
 }
 
-static void swap_xe(void *a, void *b, int size)
-{
-	struct ocfs2_xattr_entry *l = a, *r = b, tmp;
-
-	tmp = *l;
-	memcpy(l, r, sizeof(struct ocfs2_xattr_entry));
-	memcpy(r, &tmp, sizeof(struct ocfs2_xattr_entry));
-}
-
 /*
  * When the ocfs2_xattr_block is filled up, new bucket will be created
  * and all the xattr entries will be moved to the new bucket.
@@ -4241,7 +4232,7 @@ static void ocfs2_cp_xattr_block_to_buck
 	trace_ocfs2_cp_xattr_block_to_bucket_end(offset, size, off_change);
 
 	sort(target + offset, count, sizeof(struct ocfs2_xattr_entry),
-	     cmp_xe, swap_xe);
+	     cmp_xe, NULL);
 }
 
 /*
@@ -4436,7 +4427,7 @@ static int ocfs2_defrag_xattr_bucket(str
 	 */
 	sort(entries, le16_to_cpu(xh->xh_count),
 	     sizeof(struct ocfs2_xattr_entry),
-	     cmp_xe_offset, swap_xe);
+	     cmp_xe_offset, NULL);
 
 	/* Move all name/values to the end of the bucket. */
 	xe = xh->xh_entries;
@@ -4478,7 +4469,7 @@ static int ocfs2_defrag_xattr_bucket(str
 	/* sort the entries by their name_hash. */
 	sort(entries, le16_to_cpu(xh->xh_count),
 	     sizeof(struct ocfs2_xattr_entry),
-	     cmp_xe, swap_xe);
+	     cmp_xe, NULL);
 
 	buf = bucket_buf;
 	for (i = 0; i < bucket->bu_blocks; i++, buf += blocksize)
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-bcd-optimize-_bin2bcd-for-improved-performance.patch
ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap.patch

