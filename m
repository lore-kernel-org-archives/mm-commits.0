Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FE643F4B9
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 23:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764525; cv=none; b=oqzu5fAoUlFSwM+89SX7aoPNB0aFOkUTTLIEiZdmZHnXi3DOTnQkzFsCj6M+FJuT3bcUaqBOKW5R4dSGxVbpeB5xOOH8GHLfMbZovTTaZtO93HJKCH+W4WW1CvWHUhHIu3YYsqP3h/MXmVCp0JbVSQ/8pM8UzfZQdW1wQTe+My4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764525; c=relaxed/simple;
	bh=oXSIe+g4+vjQui0gYjusd+7V7cyzm4Q+1i3Z9WShfR0=;
	h=Date:To:From:Subject:Message-Id; b=hAoEHa1tzf/EvAIW+i5HAgm6uGTZoKpzoGlLSld6EXd1FEXwN0jnfPDZfM5WvTJfMfS2bEW1IdGEh9t5XddPzX2HTEobMLg7vO1dGjX5V9ezGpO6QvJmfAGIeE9uCGJL4VM/BIogK1OKKqnG2P72u8Qxj+ZomEws+qB6xSA1HEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QsiZxHLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QsiZxHLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055DC1F000E9;
	Wed, 22 Jul 2026 23:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784764524;
	bh=VPX53fzvOwRI0t9r0SuImS+V39SY/f3Wv20ZJqXKonQ=;
	h=Date:To:From:Subject;
	b=QsiZxHLbD2pKz81u9Epbo6aEHSJPEX4yI/MTuXi3YmFAxmWQDtKK04wbOMq9Bxebv
	 oM9RMaDIl4//8rIsFnJ7nR7DEtdgyCQlC585djZdOrahk5Zi50O79S5A56fpp8R71i
	 7bkQPWjgerrfemYbiqfDPv4OkbBziNCruni6cszY=
Date: Wed, 22 Jul 2026 16:55:23 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,peterz@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rbtree-fixup-kernel-doc-names.patch added to mm-nonmm-unstable branch
Message-Id: <20260722235524.055DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rbtree: fixup kernel-doc names
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rbtree-fixup-kernel-doc-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rbtree-fixup-kernel-doc-names.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: rbtree: fixup kernel-doc names
Date: Tue, 21 Jul 2026 22:07:59 -0700

Use the correct function parameter name in rb_next_match().  Use the
struct keyword when describing struct latch_tree_ops.

Prevents the following kernel-doc warnings:

Warning: ./include/linux/rbtree.h:510 function parameter 'node' not
 described in 'rb_next_match'
Warning: ./include/linux/rbtree.h:510 Excess function parameter 'tree'
 description in 'rb_next_match'
Warning: ./include/linux/rbtree_latch.h:63 cannot understand function
 prototype: 'struct latch_tree_ops'

Link: https://lore.kernel.org/20260722050759.3892887-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h       |    2 +-
 include/linux/rbtree_latch.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rbtree.h~rbtree-fixup-kernel-doc-names
+++ a/include/linux/rbtree.h
@@ -500,7 +500,7 @@ rb_find_first(const void *key, const str
 /**
  * rb_next_match() - find the next @key in @tree
  * @key: key to match
- * @tree: tree to search
+ * @node: tree to search
  * @cmp: operator defining node order
  *
  * Returns the next node matching @key, or NULL.
--- a/include/linux/rbtree_latch.h~rbtree-fixup-kernel-doc-names
+++ a/include/linux/rbtree_latch.h
@@ -47,7 +47,7 @@ struct latch_tree_root {
 };
 
 /**
- * latch_tree_ops - operators to define the tree order
+ * struct latch_tree_ops - operators to define the tree order
  * @less: used for insertion; provides the (partial) order between two elements.
  * @comp: used for lookups; provides the order between the search key and an element.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-migrate-use-migrate_info-field-instead-of-private-fix.patch
mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch
rbtree-fixup-kernel-doc-names.patch

