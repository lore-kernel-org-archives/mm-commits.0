Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF412F3609;
	Tue,  6 Jan 2026 01:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767663236; cv=none; b=rX0z7rGge/p/0swVauGZE8Y2RXwf6xJmKLFIxFNvqmuKAYOTDfgU4b8Qokwq7owCK6TPisRa/STtGPLQSpvrE5CexuGf8/lMzvEdC1e4zashpz8patDFKkwIhY2p+w0ykB6+dRkK09tWEb0kudyBg2MfWBLwj6brW6whv7jX/s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767663236; c=relaxed/simple;
	bh=AbS9zh1tIqrV6pZPXqTsnEb3GhK1lZIE1KjWQzOuo9k=;
	h=Date:To:From:Subject:Message-Id; b=D50xbfpVvxe8RNGtWI1Esin4D7+4kPwqlcTT6AN/FuiRd6ZlaJ9yOebus0PUJzpBkhMp9rKqTXexjTgajMx1seyahJnb3BsyZbWjDSiR4jCJ5qghR7MutJ+ntL5qdoBHrzoPSnyktXIyCxtmGQ56znyDhyuC2WMQiJsqR453/l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mwCvUrW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mwCvUrW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15148C16AAE;
	Tue,  6 Jan 2026 01:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767663235;
	bh=AbS9zh1tIqrV6pZPXqTsnEb3GhK1lZIE1KjWQzOuo9k=;
	h=Date:To:From:Subject:From;
	b=mwCvUrW67d6NI6FaJHG6+kTejP1wjrzBg+kE0Jaz+oriOe18xAopESWXtpt+HyATS
	 rt4t5XnVLufFM1bJREE3d6/0uPPXYhaOiMGd7LhrzInIfluBhAlmViiqtVCP+YuzOH
	 Zvn0lVc2qKzGlgiLowiaWuBv5trpjtEBS/ySdyO4=
Date: Mon, 05 Jan 2026 17:33:54 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,liam.howlett@oracle.com,andrewjballance@gmail.com,aliceryhl@google.com,boudewijn@delta-utec.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-dead-node-check-in-mas_dup_alloc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260106013355.15148C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: add dead node check in mas_dup_alloc()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-add-dead-node-check-in-mas_dup_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-dead-node-check-in-mas_dup_alloc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
Subject: maple_tree: add dead node check in mas_dup_alloc()
Date: Sat, 3 Jan 2026 17:57:58 +0100

__mt_dup() is exported and can be called without internal locking, relying
on the caller to provide appropriate synchronization.  If a caller fails
to hold proper locks, the source tree may be modified concurrently,
potentially resulting in dead nodes during traversal.

The call stack is:
  __mt_dup()
    → mas_dup_build()
      → mas_dup_alloc()  [accesses node->slot[]]

mas_dup_alloc() may access node slots without first verifying that the
node is still alive.  If a dead node is encountered, its memory layout may
have been switched to the RCU union member, making slot array access
undefined behavior as we would be reading from the rcu_head structure
instead.

If __mt_dup() is invoked without the required external locking and the
source tree is concurrently modified, a node can transition to the dead
RCU layout while mas_dup_alloc() is still traversing it.  In that case the
code may interpret the rcu_head contents as slot pointers.

Practically, this could lead to invalid pointer dereferences (kernel oops)
or corruption of the duplicated tree.  Depending on how that duplicated
tree is later used (e.g.  in mm/VMA paths), the effects could be
userspace-visible, such as fork() failures, process crashes, or broader
system instability.

My understanding is that current in-tree users hold the appropriate locks
and should not hit this, as triggering it requires violating the
__mt_dup() synchronization contract.  The risk primarily comes from the
fact that __mt_dup() is exported (EXPORT_SYMBOL), making it reachable by
out-of-tree modules or future callers which may not follow the locking
rules.

Add an explicit dead node check to detect concurrent modification during
duplication.  When a dead node is detected, return -EBUSY to indicate that
the tree is undergoing concurrent modification.

Link: https://lkml.kernel.org/r/20260103165758.74094-1-boudewijn@delta-utec.com
Fixes: fd32e4e9b764 ("maple_tree: introduce interfaces __mt_dup() and mtree_dup()")
Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/maple_tree.c~maple_tree-add-dead-node-check-in-mas_dup_alloc
+++ a/lib/maple_tree.c
@@ -6251,6 +6251,11 @@ static inline void mas_dup_alloc(struct
 	/* Allocate memory for child nodes. */
 	type = mte_node_type(mas->node);
 	new_slots = ma_slots(new_node, type);
+	if (unlikely(ma_dead_node(node))) {
+		mas_set_err(mas, -EBUSY);
+		return;
+	}
+
 	count = mas->node_request = mas_data_end(mas) + 1;
 	mas_alloc_nodes(mas, gfp);
 	if (unlikely(mas_is_err(mas)))
_

Patches currently in -mm which might be from boudewijn@delta-utec.com are

maple_tree-add-dead-node-check-in-mas_dup_alloc.patch

