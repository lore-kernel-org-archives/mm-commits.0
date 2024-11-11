Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11BE13E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313720; cv=none; b=C7yhQdCNwqTeFICoH/dNe95RQHUaau40i2lbEcyUFia3ELyhYEHHlr2wqCr847b51CCVmvDqYVN+iq7tIHbTMVIOcBQwkHt5ODeMf085vPhl+Qg3I3puszrb6GKMYE3Q3QKOVofVodFswpN11/f/OPno/CNh3xjVuYmVJF9T43I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313720; c=relaxed/simple;
	bh=RzxlAb8i7h+dRj3ukTqoX8v+UNy/LekAy2tUPZGP1FQ=;
	h=Date:To:From:Subject:Message-Id; b=nrkVy7sjw47w++fhmE2yZTMW1KGqb7VU/JUEv1+rbCC++eRr07VLNkjrbn+28mz2RaKSrLlOFQYiTfNIGePU2fGcILt6lIyBi8srJn5Z032SXg83ZfakZ5ZXeEfj8C3+UCCeAyUszIF7xNMdEge/0DnLXXX2NS+FP2DynEi5Jj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ubgWP8Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ubgWP8Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F11C4CED0;
	Mon, 11 Nov 2024 08:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313719;
	bh=RzxlAb8i7h+dRj3ukTqoX8v+UNy/LekAy2tUPZGP1FQ=;
	h=Date:To:From:Subject:From;
	b=ubgWP8CyUwmxIpQ9UAJ4BnefrspIhQ9Lz0E6Cvo8S1Ql8bhyawaLbO6HrUORyfiNC
	 ONI0TlHpG8MpaseYiCai02wRs/uvMsZRBTucSHJfcsn6OeW8Vgh/mSj3kaGzzyscv4
	 Z+QC9oMNnnOPzeUfx6jQgfc6HHfD7YeASLZnx+rk=
Date: Mon, 11 Nov 2024 00:28:39 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch removed from -mm tree
Message-Id: <20241111082839.B7F11C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: print empty for an empty tree on mt_dump()
has been removed from the -mm tree.  Its filename was
     maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: print empty for an empty tree on mt_dump()
Date: Thu, 31 Oct 2024 23:16:23 +0000

Patch series "refine storing null", v5.

When overwriting the whole range with NULL, current behavior is not
correct.

An empty tree is represented by having the tree point to NULL directly. 
An empty tree indicates the entire range (0-ULONG_MAX) is NULL.

A store operation into an existing node that causes 0 - ULONG_MAX to be
equal to NULL may not be restored to an empty state - a node is used to
store the single range instead.  This is wasteful and different from the
initial setup of the tree.

Once the tree is using a single node to store 0 - ULONG_MAX, problems may
arise when storing more values into a tree with the unexpected state of 0
- ULONG being a single range in a node.

User visible issues may mean a corrupt tree and incorrect storage of
information within the tree.  This would be limited to users who create
and then empty a tree by overwriting all values, then try to store more
NULLs into the empty tree.

I cannot come up with an example of any user doing this (users usually
destroy the tree and generally don't keep trying to store NULLs over
NULLs), but patch 4/5 "maple_tree: refine mas_store_root() on storing
NULL" should be backported just in case.


This patch (of 5):

Currently for an empty tree, it would print:

  maple_tree(0x7ffcd02c6ee0) flags 1, height 0 root (nil)
  0: (nil)

This is a little misleading.

Let's print (empty) for an empty tree.

Link: https://lkml.kernel.org/r/20241031231627.14316-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241031231627.14316-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-print-empty-for-an-empty-tree-on-mt_dump
+++ a/lib/maple_tree.c
@@ -7273,10 +7273,12 @@ void mt_dump(const struct maple_tree *mt
 
 	pr_info("maple_tree(" PTR_FMT ") flags %X, height %u root " PTR_FMT "\n",
 		 mt, mt->ma_flags, mt_height(mt), entry);
-	if (!xa_is_node(entry))
-		mt_dump_entry(entry, 0, 0, 0, format);
-	else if (entry)
+	if (xa_is_node(entry))
 		mt_dump_node(mt, entry, 0, mt_node_max(entry), 0, format);
+	else if (entry)
+		mt_dump_entry(entry, 0, 0, 0, format);
+	else
+		pr_info("(empty)\n");
 }
 EXPORT_SYMBOL_GPL(mt_dump);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


