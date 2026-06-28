Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA8D40D569
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782611085; cv=none; b=tUzdOY7/dw8j/eKJNSoKFKzlDKToqRsjhBFzYxdxGkjno6Gj7pEP9AxCfCYEkFVA/g/ZD/QHnIg9Tlu0xcsygYZdJ3Ndi57DKzdIPVP1Rv6+l8MdMoh7JEcOycmBsZjFsldGFh7kumYf/Jk+BzJvlPw2Ww1yy8F9wF6e/4QOA+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782611085; c=relaxed/simple;
	bh=40yyS44KPZLYPZTCQyP3eZ8bZPgs9vB1COfdxS5LXsQ=;
	h=Date:To:From:Subject:Message-Id; b=gJRr6cl1ye2PsDFaPurO+5MRbASVKtzCJH+54aHsS+CGNjRR1faGn/1Op0Mw9xd9OlBjCRX7PYWhFJJLn9x1d7Tyye7jT6x2RcoffRXf+GbQwtq1kdJ8uyijt5UKqagRnRD6xPdBbBNIHw5ww3nLNqajm1LP+ceRDJn5rm8VO+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0oGcCl9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0oGcCl9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857451F000E9;
	Sun, 28 Jun 2026 01:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782611083;
	bh=CkHTNtzNlBHs/bAH2AYWhb2ig7mmaThDyrVAvf4UblI=;
	h=Date:To:From:Subject;
	b=0oGcCl9QZcSCKnKZPkfVn76w6S+peK5oMKrxqQGMQsmJaX2+lHmhmQzw61lkqMcz3
	 +mS9WsLCKIG9QoH2NIGCFZOOmRS76tGosCggzHYxavNzwSDEZf0Rufei7wra5LDj5M
	 i33m0NMg76v2VoMUbbB0a1dBeM1GLLgBTlgvFuME=
Date: Sat, 27 Jun 2026 18:44:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-add-correct-some-kernel-doc.patch added to mm-new branch
Message-Id: <20260628014443.857451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: radix-tree: add/correct some kernel-doc
has been added to the -mm mm-new branch.  Its filename is
     radix-tree-add-correct-some-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-add-correct-some-kernel-doc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

radix-tree-add-correct-some-kernel-doc.patch

