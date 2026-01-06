Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F1624E4A8;
	Tue,  6 Jan 2026 03:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767670852; cv=none; b=q4gawnaptx5Z9s9jC/Hgs0iDTh94kGqNLTCp4x20HvZcLCfeeg40fRoLLL70B85GJ6hr7HP1mtVUeWW4GWs7y1aM0o4S7dgagAQR/X9aN0yCBsJXa/wm9Y0HjsjwqqiEdwEB9rnyIqlBipG6iIi+3C8/37J7RRtbjjbvf91HqIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767670852; c=relaxed/simple;
	bh=1CuxBdl5njbHYYq62NVazGyyPuBrBX9k3Tg7xgE5b6A=;
	h=Date:To:From:Subject:Message-Id; b=W+cfhKhl3a+8fgAU4jgr9VvbCmUVvksxKgx7SQ4ouZaseuXQ5IM16o2vlVa+xpu5yneFkcpOOOMY9qVkfKnysRT3gdoZSXp0jv7gtz3EZDM6GXoqmtw8pU+TPT2jcQ94vUhV/elvb0Lqp3pbOKwSn8Ek2sOwS7bn0oUYbWeyHCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rTUwvQR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rTUwvQR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A53BC116D0;
	Tue,  6 Jan 2026 03:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767670852;
	bh=1CuxBdl5njbHYYq62NVazGyyPuBrBX9k3Tg7xgE5b6A=;
	h=Date:To:From:Subject:From;
	b=rTUwvQR75EkVrnCI9g8E1L6GHE3aQcexeAyB8npFGBi0ACro6LXnJeZgFv716Vb8l
	 BiZGv8W0s66yQPkU8u7LnqD/wi+AfbZ4M6qKDoyaT59PwIjrri0IkmTj0YYjLCvbsl
	 LPbs8fk9XIW86VGk4nfcXMTgn4ukRIAuwR36a82o=
Date: Mon, 05 Jan 2026 19:40:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,liam.howlett@oracle.com,andrewjballance@gmail.com,aliceryhl@google.com,boudewijn@delta-utec.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-add-dead-node-check-in-mas_dup_alloc.patch removed from -mm tree
Message-Id: <20260106034052.1A53BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add dead node check in mas_dup_alloc()
has been removed from the -mm tree.  Its filename was
     maple_tree-add-dead-node-check-in-mas_dup_alloc.patch

This patch was dropped because an updated version will be issued

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


