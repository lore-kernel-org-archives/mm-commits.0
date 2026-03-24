Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D8F1A9FA0
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388484; cv=none; b=IWpWMayBYYdK+7QEKS1fxyzRZgMQafckbcnYSL58g8ZD+HaB3vIRSwYCAGU/IJG/VdOQQq/YMcNoURsLF8yBbCWL9ecBccH1KF9llTj7VdGIBGQgZo73G6DSVwnbUedpH9RNrxSW8ps1qTTjyGFGmvGV2Hc3Ov8R4o8etqvcgdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388484; c=relaxed/simple;
	bh=/5lAxIRwCKNg6oUsrOlTY3p5EK66L4x8yNhe7pJdr9o=;
	h=Date:To:From:Subject:Message-Id; b=Ekdm7+8oPqhMRX6xX1fAjQ9WRpGOO1T0qSmjpzPomstMtPJ5i0I78xl/n8UC501NaSk8bRyJsAE9m3+mCCglwNIhvC9Jor/YOpx+AhGQdh/HMbpOw7yZ08y8Dd0OO6HU552pLND1Wv11ZTucDbXLSXYVBnfiwTxMS2RcZQ4OI5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgQGAhe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgQGAhe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CC3C19424;
	Tue, 24 Mar 2026 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388484;
	bh=/5lAxIRwCKNg6oUsrOlTY3p5EK66L4x8yNhe7pJdr9o=;
	h=Date:To:From:Subject:From;
	b=CgQGAhe8CNq3d8aVMX2X18xJDJhsljEmpFi6Bq1kmv2CIKbM0nlEMAbX7KCRAq2K1
	 bpRC1zoorzTuFHI+Jx3leVvp1+JuCsUXRsdD5GLOsBbI3ICWUdtftdaV5Y3GMh8xPp
	 k+vXQJ8J4LhGxQWHrdP9629lqDpUAMVySsBQV7nQ=
Date: Tue, 24 Mar 2026 14:41:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-mas_dup_alloc-sparse-warning.patch removed from -mm tree
Message-Id: <20260324214123.E9CC3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix mas_dup_alloc() sparse warning
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_dup_alloc-sparse-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_dup_alloc() sparse warning
Date: Fri, 30 Jan 2026 15:59:06 -0500

Patch series "maple_tree: Replace big node with maple copy", v3.

The big node struct was created for simplicity of splitting, rebalancing,
and spanning store operations by using a copy buffer to create the data
necessary prior to breaking it up into 256B nodes.  Certain operations
were rather tricky due to the restriction of keeping NULL entries together
and never at the end of a node (except the right-most node).

The big node struct is incompatible with future features that are
currently in development.  Specifically different node types and different
data type sizes for pivots.

The big node struct was also a stack variable, which caused issues with
certain configurations of kernel build.

This series removes big node by introducing another node type which will
never be written to the tree: maple_copy.  The maple copy node operates
more like a scatter/gather operation with a number of sources and
destinations of allocated nodes.

The sources are copied to the destinations, in turn, until the sources are
exhausted.  The destination is changed if it is filled or the split
location is reached prior to the source data end.

New data is inserted by using the maple copy node itself as a source with
up to 3 slots and pivots.  The data in the maple copy node is the data
being written to the tree along with any fragment of the range(s) being
overwritten.

As with all nodes, the maple copy node is of size 256B.  Using a node type
allows for the copy operation to treat the new data stored in the maple
copy node the same as any other source node.

Analysis of the runtime shows no regression or benefit of removing the
larger stack structure.  The motivation is the ground work to use new node
types and to help those with odd configurations that have had issues.

The change was tested by myself using mm_tests on amd64 and by Suren on
android (arm64).  Limited testing on s390 qemu was also performed using
stress-ng on the virtual memory, which should cover many corner cases.


This patch (of 30):

Use RCU_INIT_POINTER to initialize an rcu pointer to an initial value
since there are no readers within the tree being created during
duplication.  There is no risk of readers seeing the initialized or
uninitialized value until after the synchronization call in
mas_dup_buld().

Link: https://lkml.kernel.org/r/20260130205935.2559335-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20260130205935.2559335-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_dup_alloc-sparse-warning
+++ a/lib/maple_tree.c
@@ -6260,8 +6260,15 @@ static inline void mas_dup_alloc(struct
 	for (i = 0; i < count; i++) {
 		val = (unsigned long)mt_slot_locked(mas->tree, slots, i);
 		val &= MAPLE_NODE_MASK;
-		new_slots[i] = ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
-					    val);
+		/*
+		 * Warning, see rcu_assign_pointer() documentation.  Since this
+		 * is a duplication of a tree, there are no readers walking the
+		 * tree until after the rcu_assign_pointer() call in
+		 * mas_dup_build().
+		 */
+		RCU_INIT_POINTER(new_slots[i],
+				 ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
+					      val));
 	}
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


