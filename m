Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8E71EFFAD;
	Wed, 12 Mar 2025 22:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741817956; cv=none; b=HOAJVaOLz0/LDKRfl+7vh+LdE0fuFz9jvzQeChmNTCjCf1PlU+MLgVkLFsiD7QxCPzKAgp7bvfpV67NgBy6N9ULd9Fqs8xu2l2Q4GwfHCLVJ9E5Q3Hwn5iOMszjpAXX0ikSa7rozTLr5WPof8D/l26ws/loJTytE2MPAijbW0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741817956; c=relaxed/simple;
	bh=8MYFJ/fYFrF/V9a0Eqv7AHunvE0rzt3y+VMyB5+Co+M=;
	h=Date:To:From:Subject:Message-Id; b=HxwiWKDw6NeL/z2AaHSYAOG8a7VJQ1h0PVzy5fZ1m5JyNhJrRGws7YSwu10zBxvuYC6aiDr9a0RtcEjAr1TdzmnKDSDGaSKvQhjf+dGvwvcgcjHANW1qDccYbcFOwVxyuYEUhg/dvQ878iTk/KfZekaMELoXWMtpZEzMt1sIQcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FqtT6598; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FqtT6598"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44367C4CEEB;
	Wed, 12 Mar 2025 22:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741817955;
	bh=8MYFJ/fYFrF/V9a0Eqv7AHunvE0rzt3y+VMyB5+Co+M=;
	h=Date:To:From:Subject:From;
	b=FqtT6598Qh2EQ/APDT19BdqORaHkRJcG+YdupuYrN9PvVkoHVHbyxOgyDQyr+wZia
	 rx/KBkqAGRQ+xVVWUUH1TZ9nivO7y+V3kW8J9eEvNRNkrIPHUZ/auavB8XIyT/EP8r
	 lyKsQGjBBUwv/BfIeFnnJ+QL74na2JtMIDYdwOhA=
Date: Wed, 12 Mar 2025 15:19:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,stern@rowland.harvard.edu,stable@vger.kernel.org,peterz@infradead.org,paulmck@kernel.org,parri.andrea@gmail.com,npiggin@gmail.com,luc.maranget@inria.fr,lorenzo.stoakes@oracle.com,j.alglave@ucl.ac.uk,dhowells@redhat.com,boqun.feng@gmail.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch added to mm-unstable branch
Message-Id: <20250312221915.44367C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch

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
Subject: mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock
Date: Wed, 12 Mar 2025 10:10:13 -0400

The PGDAT_RECLAIM_LOCKED bit is used to provide mutual exclusion of node
reclaim for struct pglist_data using a single bit.

It is "locked" with a test_and_set_bit (similarly to a try lock) which
provides full ordering with respect to loads and stores done within
__node_reclaim().

It is "unlocked" with clear_bit(), which does not provide any ordering
with respect to loads and stores done before clearing the bit.

The lack of clear_bit() memory ordering with respect to stores within
__node_reclaim() can cause a subsequent CPU to fail to observe stores from
a prior node reclaim.  This is not an issue in practice on TSO (e.g. 
x86), but it is an issue on weakly-ordered architectures (e.g.  arm64).

Fix this by using clear_bit_unlock rather than clear_bit to clear
PGDAT_RECLAIM_LOCKED with a release memory ordering semantic.

This provides stronger memory ordering (release rather than relaxed).

Link: https://lkml.kernel.org/r/20250312141014.129725-1-mathieu.desnoyers@efficios.com
Fixes: d773ed6b856a ("mm: test and set zone reclaim lock before starting reclaim")
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock
+++ a/mm/vmscan.c
@@ -7581,7 +7581,7 @@ int node_reclaim(struct pglist_data *pgd
 		return NODE_RECLAIM_NOSCAN;
 
 	ret = __node_reclaim(pgdat, gfp_mask, order);
-	clear_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
+	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch
mm-lock-pgdat_reclaim_locked-with-acquire-memory-ordering.patch

