Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C48A1F03EF
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 22:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741817957; cv=none; b=krUrxyR2m8/H2fg/NL9r1b9fOsFvPVlIL1gyELnpN1qhrkKNyfJ8wJW+TrHYJZabV3NQxsF+D1iOeKlxUVN5jTfLEQtfbuN22Qrv4BWW8h5x6EmMpVjjYht4+9o0pOI5QfPPHrtsn2sd3gUIyZl5qLvMXpdQLOrMM7HAmQ5k6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741817957; c=relaxed/simple;
	bh=LLDLKHrahscq4JeQTRVX3qr6Ok2M6JMPEKMUvMwO9fo=;
	h=Date:To:From:Subject:Message-Id; b=K85K+Y1uCaMDXRzIjhVd2enXtklYG3Zj91hsydczTL5D+QD9VZHryC/+4mMh+pHaoDTHvT31zopWIXGpcHfgAuD3DbfIVEFyy038jXrwrryqfLljwOIM6LFKWC/SyUQEk7gnKNgwkGpczyG9ZfE3rPL56cQY99tvyBG7e3UEX8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nMzNprce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nMzNprce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA7CC4CEE3;
	Wed, 12 Mar 2025 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741817956;
	bh=LLDLKHrahscq4JeQTRVX3qr6Ok2M6JMPEKMUvMwO9fo=;
	h=Date:To:From:Subject:From;
	b=nMzNprcerm9M/mzZiG2D2om8iHUNMdq4X4LiFO9VHOauOKKopWzcWbr2BJXQIk5xO
	 SiUy1cY17GJc3Mj9ys7C9czWe6AyrbM5Tmj1Y99E5DdKIAITx9MaiQ3NXCMAKRw5+O
	 G85wAGA/vP9R3VtiH3CPOvC59DllcK1v3p23w350=
Date: Wed, 12 Mar 2025 15:19:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,stern@rowland.harvard.edu,peterz@infradead.org,paulmck@kernel.org,parri.andrea@gmail.com,npiggin@gmail.com,luc.maranget@inria.fr,lorenzo.stoakes@oracle.com,j.alglave@ucl.ac.uk,dhowells@redhat.com,boqun.feng@gmail.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch added to mm-unstable branch
Message-Id: <20250312221916.7CA7CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: lock PGDAT_RECLAIM_LOCKED with acquire memory ordering
has been added to the -mm mm-unstable branch.  Its filename is
     mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: lock PGDAT_RECLAIM_LOCKED with acquire memory ordering
Date: Wed, 12 Mar 2025 10:10:14 -0400

The PGDAT_RECLAIM_LOCKED bit is used to provide mutual exclusion of node
reclaim for struct pglist_data using a single bit.

Use test_and_set_bit_lock rather than test_and_set_bit to test-and-set
PGDAT_RECLAIM_LOCKED with an acquire memory ordering semantic.

This changes the "lock" acquisition from a full barrier to an acquire
memory ordering, which is weaker.  The acquire semi-permeable barrier
paired with the release on unlock is sufficient for this mutual exclusion
use-case.

No behavior change intended other than to reduce overhead by using the
appropriate barrier.

Link: https://lkml.kernel.org/r/20250312141014.129725-2-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jade Alglave <j.alglave@ucl.ac.uk>
Cc: Luc Maranget <luc.maranget@inria.fr>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering
+++ a/mm/vmscan.c
@@ -7577,7 +7577,7 @@ int node_reclaim(struct pglist_data *pgd
 	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
 		return NODE_RECLAIM_NOSCAN;
 
-	if (test_and_set_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
+	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return NODE_RECLAIM_NOSCAN;
 
 	ret = __node_reclaim(pgdat, gfp_mask, order);
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch
mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch

