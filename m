Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793375177;
	b=4oETXDIv6SbRpReHfMNQesYdbsKgrLU7C6XZU4Sz5uV5LZpXU2ZGJBDPqkHsLyjd6be0
	 vLf6locXwe44fqgFAGmxjY90yb2B2xvtuok1d8LyLa7G+g931QZQmyuC96MTkB/Emil0h
	 V+eU9MZaTQLJmjHywvLbPDPNgaLnGylSh+7sRNb9POAFhRVS4HjMlhE/G2pKTOiUmUAMB
	 l/lm7iCImw4VQeaN73FsiaDlE5C7UDjrRwWBfYKh7kSpdRmsM+FNZeE5iEyb2TSjCE6hW
	 Nb0IQ8FuN4CKqKSB1gLNOTzG+YTkgvdeVktHJUY0Vsqn0qotsIDyzoNhcu/dcDxgNdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375177;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HYc8kA1Dj7hEjokGvwIC8AqPAr4TIaJOHfnb1TjnPgQ=;
	b=k20ZNiPygLXt0mkLdGZf/jkZBcGNOPbTM8fEM42wO9xMtG06gjZXjBYRId6MhwNfZnD8
	 3Mj54tTxhFN8iT4p0Ex4uI58tuW2BIL59u5bBB8X97GYPahOTIaAh8uSW6Ti6PtRyMlb7
	 Osq5ljvPFHyeFKvplzUSacXPfcBxBw3I2ctQuVbIRkJL6IOssoafwOJhzm0h6V1ehJ2TV
	 nR+C+zMyGmbwWNJacdoEhEZvM1GxI9eqWppozwNDHCohOsEfCPnhm9tVNspmtWzrlr1ix
	 EKXNKDHjpbvfB5cuXK0YlohN3absb7L1qchWMpNH1jGhWdk/ootle9PararxPT4DBwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NnIsw0t5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9991F606A31D
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NnIsw0t5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2441A1F0093A;
	Fri, 30 Oct 2026 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793375177;
	bh=HYc8kA1Dj7hEjokGvwIC8AqPAr4TIaJOHfnb1TjnPgQ=;
	h=Date:To:From:Subject;
	b=NnIsw0t5PnnJgCQ949u1zjIFMQxwH9NmezBJdS/Ci8SUDwomefD36AfFWYdiUG6jB
	 P/IT74yy+BmBL0tfGLOorAqcc3vaXCE6MWrTWjVVf+KOYWzwuPyYbZYU3lyH9iLH6n
	 sepMA3i5Kx34Qg8Lh4KQ/nWEtS/BQ9fzeNnaUn5c=
Date: Fri, 30 Oct 2026 08:46:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nickolai@csail.mit.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch added to mm-hotfixes-unstable branch
Message-Id: <20261030154617.2441A1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: xarray: clear the new head's parent before freeing the old head
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch

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
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: xarray: clear the new head's parent before freeing the old head
Date: Tue, 27 Oct 2026 15:20:14 -0400

xas_shrink() passes the old head to xa_node_free(), which queues it with
call_rcu(), before it clears the new head's parent pointer.  A lockless
walker that loads the new head after the grace period has started can
still climb from it into the old head through xa_parent(), as xas_find(),
xas_find_marked(), xas_next() and xas_prev() do when they step past the
end of a node, and read the old head after it is freed.

Clear the parent pointer before freeing the old head, as
radix_tree_shrink() does.

With a delay injected after xa_node_free() in xas_shrink(), KASAN reports
a slab-use-after-free in the walker; with this patch it does not.

Link: https://lore.kernel.org/20261027192014.844878-1-nickolai@csail.mit.edu
Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 lib/xarray.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-clear-the-new-heads-parent-before-freeing-the-old-head
+++ a/lib/xarray.c
@@ -471,11 +471,12 @@ static void xas_shrink(struct xa_state *
 		if (!xa_is_node(entry))
 			RCU_INIT_POINTER(node->slots[0], XA_RETRY_ENTRY);
 		xas_update(xas, node);
+		if (xa_is_node(entry))
+			xa_to_node(entry)->parent = NULL;
 		xa_node_free(node);
 		if (!xa_is_node(entry))
 			break;
 		node = xa_to_node(entry);
-		node->parent = NULL;
 	}
 }
 
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
panic-zero-the-dynamically-allocated-taint-buffer.patch

