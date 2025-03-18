Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A02B1C6FF8
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274650; cv=none; b=luippniqigjzZC7Jo5eO7+GuIfWk83cn+IuKXOzxW3PFx1p+eM1X92bFbUmERvR4O272Wg3jQK/csw0iuANRwIoRXBnIMrs+5rIK3HjXJeszKI53eO2xf2GAum89/Dwjb+lguYffQ2Ke+os98IJGpce/bdYUtxFx14R9A/uaJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274650; c=relaxed/simple;
	bh=FVXtCo5fksJRpSghO8QTQ6WDg+KcoTCKgx2fUHaJ29s=;
	h=Date:To:From:Subject:Message-Id; b=KeCrka3gfNw38zA6G1RdYOU0S3/oF0Vxjgc9GUj+whinio1z4706ijQII4h6T4ga0XozE72gDAeRu8X87vlhROv012sE1jrOCOu27+fIPX1asBmbjSHmuWjG0Hwb03kLTX4eDiPMl4imTiRc3dkOOyopaYMC5x5mnC6/viKDjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cj8mwLPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cj8mwLPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F109C4CEDD;
	Tue, 18 Mar 2025 05:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274650;
	bh=FVXtCo5fksJRpSghO8QTQ6WDg+KcoTCKgx2fUHaJ29s=;
	h=Date:To:From:Subject:From;
	b=cj8mwLPM+X54yAkU2hXbdq2URB0/i0va+eSCn/XuAXRSnPpROTyvidWyPExBUk3Nv
	 xnDQQmkep6Ab3D2gGFXq56d4WbjPWA8usI4I/etB5kfcg1UkXzuP+zvJOzgMPzGzc3
	 /BQjPz4bffo4ifZaynlFHZiLG9yhRMDppqfFM2Fo=
Date: Mon, 17 Mar 2025 22:10:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,stern@rowland.harvard.edu,peterz@infradead.org,paulmck@kernel.org,parri.andrea@gmail.com,npiggin@gmail.com,luc.maranget@inria.fr,lorenzo.stoakes@oracle.com,j.alglave@ucl.ac.uk,dhowells@redhat.com,boqun.feng@gmail.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch removed from -mm tree
Message-Id: <20250318051050.1F109C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: lock PGDAT_RECLAIM_LOCKED with acquire memory ordering
has been removed from the -mm tree.  Its filename was
     mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


