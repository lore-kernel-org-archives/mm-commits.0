Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A23911BC
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298485; cv=none; b=j8KZnWWmv0KJJcCQBiGVZWzePYtLv3jM/w/+qWWTa7OSZvkox918EwJTNHR+x4UgzcE0xTSIj35OVY8sS/9R/D2nXoK17QyUw0kpsRxXnaAclidBrXwaB27Zi6MdaW6JWdxZoDoOQYLzei37EiaxxfUrLUwKSqN8vl8is8srpNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298485; c=relaxed/simple;
	bh=upfGec+n50aN74Q4E5WEQ9DhAzUDB3XghHuAzryzw1g=;
	h=Date:To:From:Subject:Message-Id; b=nmyoCYwK0P2qBLuSEeVVHAQHZYZ8KWxjTdHGt1/iIURtKvs7iK7/5RbQK7naTEICySEBWEtGxjBgwHokaL7+n++5NAqxGMwgF0R0c5nwkQK2OiuVywdXdTpKZrd7TFO6GfD85iLimA1XYjUbWBTM8V+8om3ZgwnGlbrzrXu3Euc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TOiqw4EI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOiqw4EI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC9C1F00A3A;
	Wed, 29 Jul 2026 04:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298484;
	bh=XBNSiSWPsS3Gw+6TCctN1Fb9JsS24Q4PVcyZcMzvNOc=;
	h=Date:To:From:Subject;
	b=TOiqw4EIDFGLbfxc6fJA8t7pcSoWs/T5lhJ/VfYgcDabL6Zem1qfVjmCO4bdyMTv5
	 xe3Z1P5tt4PC1ksmXYgMIsJnerZf/UL3/dOXXiXTrWQw+mXdbrSdSq2PK8rBfhAHZ9
	 ITw7Ogd5u49pkXk7XPg2nxXSANeL6zextpRDzJOA=
Date: Tue, 28 Jul 2026 21:14:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-add-correct-some-kernel-doc.patch removed from -mm tree
Message-Id: <20260729041444.0CC9C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: radix-tree: add/correct some kernel-doc
has been removed from the -mm tree.  Its filename was
     radix-tree-add-correct-some-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: radix-tree: add/correct some kernel-doc
Date: Sat, 27 Jun 2026 11:58:58 -0700

Correct some kernel-doc issues in radix-tree.h:
- use "DOC:" so that a kernel-doc comment is parsed correctly
  (or we could just use "/*" for that comment)
- add one function parameter description
- add one function parameter name inside the prototype

to fix these warnings:

Warning: include/linux/radix-tree.h:164 Incorrect use of kernel-doc format:
 * radix_tree_deref_slot - dereference a slot
Warning: include/linux/radix-tree.h:177 cannot understand function
 prototype: '* @slot: slot pointer, returned by radix_tree_lookup_slot
Warning: include/linux/radix-tree.h:192 function parameter 'treelock'
 not described in 'radix_tree_deref_slot_protected'
Warning: include/linux/radix-tree.h:309 function parameter '' not
 described in 'radix_tree_next_chunk'

Link: https://lore.kernel.org/20260627185859.1632928-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/radix-tree.h~radix-tree-add-correct-some-kernel-doc
+++ a/include/linux/radix-tree.h
@@ -111,7 +111,7 @@ struct radix_tree_iter {
 };
 
 /**
- * Radix-tree synchronization
+ * DOC: Radix-tree synchronization
  *
  * The radix-tree API requires that users provide all synchronisation (with
  * specific exceptions, noted below).
@@ -182,6 +182,7 @@ static inline void *radix_tree_deref_slo
 /**
  * radix_tree_deref_slot_protected - dereference a slot with tree lock held
  * @slot: slot pointer, returned by radix_tree_lookup_slot
+ * @treelock: caller must hold this spinlock
  *
  * Similar to radix_tree_deref_slot.  The caller does not hold the RCU read
  * lock but it must hold the tree lock to prevent parallel updates.
@@ -306,7 +307,7 @@ radix_tree_iter_init(struct radix_tree_i
  * Also it fills @iter with data about chunk: position in the tree (index),
  * its end (next_index), and constructs a bit mask for tagged iterating (tags).
  */
-void __rcu **radix_tree_next_chunk(const struct radix_tree_root *,
+void __rcu **radix_tree_next_chunk(const struct radix_tree_root *root,
 			     struct radix_tree_iter *iter, unsigned flags);
 
 /**
_

Patches currently in -mm which might be from rdunlap@infradead.org are

delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch
rbtree-fixup-kernel-doc-names.patch
llist-use-correct-function-parameter-name.patch
stacktrace-header-repair-kernel-doc-comments.patch

