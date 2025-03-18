Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114171C6FF8;
	Tue, 18 Mar 2025 05:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274649; cv=none; b=euaEvOHkToHO+UJ5QIZ48hhEaTziRRMSnuZE0TdqIiD5A0DAENMnCTWkMPdvItWrwIx8arjeuNYU4jlgGpY36BIFCUP9gIIQlp/857uw47YmNnQy6dPPcXhRU/+vTrpoYG1p27WXBqb4CnZSLsKuLIK0swAuWs27AVMSAXPvizE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274649; c=relaxed/simple;
	bh=Sn8Z8d8tKzqfK5IBLsR47UFAa+DyY9A9VVDfID9NPsE=;
	h=Date:To:From:Subject:Message-Id; b=sBOePhHR5VKV3Gru9jvwr1MsTgKfob6oHu3p+iRaEn+CQ+cz6uiZyBZAqZouFa4VBErnoCw6ynbM54VGq3O4AlZ57HgeGM1CPq+y0Q5BPEFRT+fM6f84vkP4vTag7lBkNzqqxMYsTn0b34vmOphqLfJixw3YyLD5pBRcOMOc3FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KoZHREgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KoZHREgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB061C4CEDD;
	Tue, 18 Mar 2025 05:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274648;
	bh=Sn8Z8d8tKzqfK5IBLsR47UFAa+DyY9A9VVDfID9NPsE=;
	h=Date:To:From:Subject:From;
	b=KoZHREgUvDowCKNYlh9j4dAOggl8Sf/era0kPJwoRf5L6ns7ihIzoqInQK1v4PKIG
	 ZD41qP4ohi8NRhgEl/SwnI0cWAhQBa31Otmhxwqv46MA+U9BQ3MaPhaAAbkflhwDhx
	 k20wolPu3Vtv8PzOKs8lbjF+uInU4FStX/uXYN3s=
Date: Mon, 17 Mar 2025 22:10:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,stern@rowland.harvard.edu,stable@vger.kernel.org,peterz@infradead.org,paulmck@kernel.org,parri.andrea@gmail.com,npiggin@gmail.com,luc.maranget@inria.fr,lorenzo.stoakes@oracle.com,j.alglave@ucl.ac.uk,dhowells@redhat.com,boqun.feng@gmail.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch removed from -mm tree
Message-Id: <20250318051048.DB061C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock
has been removed from the -mm tree.  Its filename was
     mm-add-missing-release-barrier-on-pgdat_reclaim_locked-unlock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


