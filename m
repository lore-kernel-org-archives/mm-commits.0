Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2647FBE4F
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420446; cv=none; b=j3S178eVzFTBml9+2szvSD8D2Dd/DTUSB5CYAZCRD2lVm9Ksy3ysxTp64nHwI8QKAjF8Wxb/ihkTTPB/xMOu2Jdw/Dh36WR7EURQd4Feiz2R/HMLxYJQapYygficakI5GUdM5lZJartX69erTiMz/IQssHgmIDHR3zxqUX8Yyeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420446; c=relaxed/simple;
	bh=e6i0QHMATPCRfmC+70yrheIzk/61hB9FQJkqNKpNKDE=;
	h=Date:To:From:Subject:Message-Id; b=XCicVe3YJDd+kXiaMn3fmVPWM7ZnIhh3VebiiKRAawlsYQTJCCExNmuyb6v37X3MkGEY3OizBJQvz2TLQEselvNjKE9oNPOG3GVTkF3U9Hs8VwO4tAAIfI63EEVbCMO01vod8r996GrqGtM8HVNibAcx89TfRf4lu7V+BsN0j0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jzd8BnZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jzd8BnZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA077C4CECF;
	Fri,  1 Nov 2024 00:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420445;
	bh=e6i0QHMATPCRfmC+70yrheIzk/61hB9FQJkqNKpNKDE=;
	h=Date:To:From:Subject:From;
	b=jzd8BnZoZQW1P1Vj9/1ELmW2+qXtuWm1VN5dICPqcp04CEwHmkMUYabdCDKaeQwqt
	 bsileL2vj4wUenoWSrc7tUjyl8A5VuSCVWzgJN+pevKNHzMUbWNPZKeeOSBLcUpl5J
	 60bvlX8fpkpoJv68NCbPdw0N11YHGzhUWmavADRE=
Date: Thu, 31 Oct 2024 17:20:45 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-refine-mas_store_root-on-storing-null.patch added to mm-unstable branch
Message-Id: <20241101002045.DA077C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: refine mas_store_root() on storing NULL
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-refine-mas_store_root-on-storing-null.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-refine-mas_store_root-on-storing-null.patch

This patch will later appear in the mm-unstable branch at
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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: refine mas_store_root() on storing NULL
Date: Thu, 31 Oct 2024 23:16:26 +0000

Currently, when storing NULL on mas_store_root(), the behavior could be
improved.

For example possible cases are:

  * store NULL at any range result a new node
  * store NULL at range [m, n] where m > 0 to a single entry tree result
    a new node with range [m, n] set to NULL
  * store NULL at range [m, n] where m > 0 to an empty tree result
    consecutive NULL slot
  * it allows for multiple NULL entries by expanding root
    to store NULLs to an empty tree

This patch tries to improve in:

  * memory efficient by setting to empty tree instead of using a node
  * remove the possibility of consecutive NULL slot which will prohibit
    extended null in later operation

Link: https://lkml.kernel.org/r/20241031231627.14316-5-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-refine-mas_store_root-on-storing-null
+++ a/lib/maple_tree.c
@@ -3447,9 +3447,20 @@ static inline void mas_root_expand(struc
 	return;
 }
 
+/*
+ * mas_store_root() - Storing value into root.
+ * @mas: The maple state
+ * @entry: The entry to store.
+ *
+ * There is no root node now and we are storing a value into the root - this
+ * function either assigns the pointer or expands into a node.
+ */
 static inline void mas_store_root(struct ma_state *mas, void *entry)
 {
-	if (likely((mas->last != 0) || (mas->index != 0)))
+	if (!entry) {
+		if (!mas->index)
+			rcu_assign_pointer(mas->tree->ma_root, NULL);
+	} else if (likely((mas->last != 0) || (mas->index != 0)))
 		mas_root_expand(mas, entry);
 	else if (((unsigned long) (entry) & 3) == 2)
 		mas_root_expand(mas, entry);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

