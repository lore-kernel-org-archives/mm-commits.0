Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D323C14F9E6
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248829; cv=none; b=oMHZYcmrJltaDz8XjCv2uDiL73PJ6uniKEJs+XjU5u2axjQsQohiOLmtvZ8scpuvHlAJMHjRkPK9G7KTCKanOq19OFTOs50uIPBPEkAGcMsu3VCqVKJ29bguE0GxEjWX5qkTGWOIn7gHuZ2kVFsHnEqEhysw5ABEksGmEXWYpds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248829; c=relaxed/simple;
	bh=Etd9xnYBfKsBBOLwEq9G9pzy8pJnYsfZSOB7sNYkHhc=;
	h=Date:To:From:Subject:Message-Id; b=uwHpKZmThSt/KdGE7T+U26xLZg41pnAbh3krddeCjOTrcQAFZbHY4R9HfdKv3kkmixMYW+pzZeVPIwtCjKBwoeP3bYzI1Aljxs4whogodbynYziCnlzkrVA/2Zmwd3TW7QzwPydhGTXrqc5Hn77quNw6Vt1eVzJDlNH8COuY7q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C7Ksq6J7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C7Ksq6J7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA455C4CEC2;
	Mon,  2 Sep 2024 03:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248829;
	bh=Etd9xnYBfKsBBOLwEq9G9pzy8pJnYsfZSOB7sNYkHhc=;
	h=Date:To:From:Subject:From;
	b=C7Ksq6J77xhC1UNXD6clrfXYb8Y/0A+NEnkNGE7fdsxNXi/kJ+RWTht+W0uupsbbQ
	 x4EZIzjFSLuu2zsn2tr4yCTCUPSQgV1PKdtd5ajZf1T8sdBhvx803/gY7tcMdU409t
	 yr3gyVtLZuIN1Cdguep3bZqKwkgGARXxCP/aWU34=
Date: Sun, 01 Sep 2024 20:47:09 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jserv@ccns.ncku.edu.tw,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap.patch removed from -mm tree
Message-Id: <20240902034709.AA455C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove custom swap functions in favor of built-in sort swap
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-custom-swap-functions-in-favor-of-built-in-sort-swap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


