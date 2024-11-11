Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DDF165EED;
	Mon, 11 Nov 2024 08:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313723; cv=none; b=AxzUt7+/BjckdjNC04hslOWia1lTcCPneyIThxSsxvG6xSu2pFCXv8encDkl1UGIrXQXm4iqF3CrBSVbWejRh5NgR0Am49CNETwujAlzMBubVh8PF/q1h5XM/H3TdhuOAzA3RXdCxNVysXcW+WYs7C4lkPvu+HDKIYTfPg+UgpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313723; c=relaxed/simple;
	bh=S2RyJR8gBhzd/GaKfCIIotiVu1jovi6sp2vkszkrltE=;
	h=Date:To:From:Subject:Message-Id; b=dy7TOk1+p5hvFAcJgGsqVP6HPVLh2fGAbYs4/5EvsAuftpoXEMl9cIWBdNSufx7XiW1mM1J6OWgF8IIDGTY1t41FEUlQ4BVe/9PSh8L/pEEHhWkzPSjkMKmjOqF9f+q6uLZ9QsPwhmbLGOF4koCt8xvr/fyesEuEn0sJ6lbWDx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yf2FSCa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yf2FSCa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3611DC4CED0;
	Mon, 11 Nov 2024 08:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313723;
	bh=S2RyJR8gBhzd/GaKfCIIotiVu1jovi6sp2vkszkrltE=;
	h=Date:To:From:Subject:From;
	b=yf2FSCa5EnAcrdoUupY7QfCLsEm94kA/1nhY+Fzy/fXrmiAfzDRMoRjD6uvwvxlca
	 FGdYEKVTxDn5wZoYtX2TJgphJBZT4dLMCA3nJIAsyYqpzf/EmDJgfHPRwEunFVNcYn
	 hCq4h1yxmsEhDwfwsPXFvBpfarCIdwXQk3VLag2U=
Date: Mon, 11 Nov 2024 00:28:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-refine-mas_store_root-on-storing-null.patch removed from -mm tree
Message-Id: <20241111082843.3611DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: refine mas_store_root() on storing NULL
has been removed from the -mm tree.  Its filename was
     maple_tree-refine-mas_store_root-on-storing-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: refine mas_store_root() on storing NULL
Date: Thu, 31 Oct 2024 23:16:26 +0000

Currently, when storing NULL on mas_store_root(), the behavior could be
improved.

Storing NULLs over the entire tree may result in a node being used to
store a single range.  Further stores of NULL may cause the node and
tree to be corrupt and cause incorrect behaviour.  Fixing the store to
the root null fixes the issue by ensuring that a range of 0 - ULONG_MAX
results in an empty tree.

Users of the tree may experience incorrect values returned if the tree
was expanded to store values, then overwritten by all NULLS, then
continued to store NULLs over the empty area.

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
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <stable@vger.kernel.org>
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


