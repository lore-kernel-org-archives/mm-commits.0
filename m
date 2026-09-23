Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759A381EBD;
	Wed, 23 Sep 2026 02:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790130823; cv=none; b=QoxkHyNXXf9hKQXPcaFkBPkxRafoCYAm9/79vyvN17oajuyieP1vx8tCl3QHdXfClNuBPbvBrglqnnkcWHF30ANbAgmjD05jvT5L7XJ6E1ZWZfLa0K6RRlc0Oi+12fW/SP7Ia7VO+/nU30tbMMhabbhlcblLnXAg9J7Pejet8VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790130823; c=relaxed/simple;
	bh=eFDAVG+mk8rsdn+wNCNva90RToqvNfsIt347A1j+KgY=;
	h=Date:To:From:Subject:Message-Id; b=h6s69USICsxJRajX/B0/PXL9kmOXactb+NJu9RCmaNo1fXdrI5MqS1GTATiiHSgDyQSdDs5VYgJTQw7oaTm4OSieQpOpjA2tyJuo1pie6CVBIgds8BC+l3nOeE0qC9HlEDu6MIaPqLE1N8PD5RWS8PzDMv7lDQ8RBvpGTFnlkcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mpRmpD9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mpRmpD9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB41F000FF;
	Wed, 23 Sep 2026 02:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790130821;
	bh=p3N7dWDOw+eaVIvICVHnUU4epiaz5mAJPoK/foTlj9s=;
	h=Date:To:From:Subject;
	b=mpRmpD9N3A5ZoHGQi7EJhnN2vxII44Ux6+P26hqUHZKWuxLcKVP7/KJq0XXG6hEge
	 gd6cBG+r4yOlIAoz6WjL+Pgd3YWDDcMf5evEiDqQpRWuMNNEBdTzjWkL63oRQtAdY8
	 PdFKrLr0l90eQC0zWKbMf1r4vksVMHWughyBrHWk=
Date: Tue, 22 Sep 2026 19:33:41 -0700
To: mm-commits@vger.kernel.org,xmei5@asu.edu,stable@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gkobakhi@asu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path.patch added to mm-nonmm-unstable branch
Message-Id: <20260923023341.7CDB41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix array out of bound access in __ocfs2_find_path()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path.patch

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
From: Giorgi Kobakhia <gkobakhi@asu.edu>
Subject: ocfs2: fix array out of bound access in __ocfs2_find_path()
Date: Tue, 22 Sep 2026 13:21:59 -0700

__ocfs2_find_path() walks down the extent tree and records path by calling
find_path_ins(), which appends entry to path->p_node[].  It only has 5
spots.

A corrupted ocfs2 image whose extent block is pointing to itself causes
__ocfs2_find_path() descent endlessly, writing past the end of
path->p_node[] array.

 UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:677:14
 index 5 is out of range for type 'ocfs2_path_item [5]'
 Call Trace:
  <TASK>
  find_path_ins (fs/ocfs2/alloc.c:677 fs/ocfs2/alloc.c:1914)
  __ocfs2_find_path.constprop.0 (fs/ocfs2/alloc.c:1882)
  ocfs2_commit_truncate (fs/ocfs2/alloc.c:1924 fs/ocfs2/alloc.c:7286)
  ocfs2_truncate_file (fs/ocfs2/file.c:515)
  ocfs2_setattr (fs/ocfs2/file.c:1224)
  notify_change (fs/attr.c:556)
  do_truncate (fs/open.c:68)
  do_ftruncate (fs/open.c:194 (discriminator 1))
  ksys_ftruncate (fs/open.c:206)
  __x64_sys_ftruncate (fs/open.c:211 fs/open.c:209 fs/open.c:209)

Commit a406aff8c051 ("ocfs2: validate l_tree_depth to avoid out-of-bounds
access") already restricts el->l_tree_depth to be less than
OCFS2_MAX_PATH_DEPTH, which is equal to 5.  However, does not handle the
infinite descent case.

Check if the el->l_tree_depth decreases on each descent.  Maximum descents
are restricted to 4 and the path->p_node[] array does not overflow.

Assisted-by: LLM
Link: https://lore.kernel.org/20260922202159.2421642-1-gkobakhi@asu.edu
Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path
+++ a/fs/ocfs2/alloc.c
@@ -1817,6 +1817,7 @@ static int __ocfs2_find_path(struct ocfs
 	int i, ret = 0;
 	u32 range;
 	u64 blkno;
+	u32 prev_depth = OCFS2_MAX_PATH_DEPTH;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
@@ -1824,14 +1825,16 @@ static int __ocfs2_find_path(struct ocfs
 
 	el = root_el;
 	while (el->l_tree_depth) {
-		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= prev_depth)) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    "Owner %llu has invalid tree depth %u in extent list (max %u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    le16_to_cpu(el->l_tree_depth));
+				    le16_to_cpu(el->l_tree_depth), prev_depth - 1);
 			ret = -EROFS;
 			goto out;
 		}
+		prev_depth = le16_to_cpu(el->l_tree_depth);
+
 		if (!el->l_next_free_rec || !el->l_count) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n"
_

Patches currently in -mm which might be from gkobakhi@asu.edu are

ocfs2-fix-array-out-of-bound-access-in-__ocfs2_find_path.patch

