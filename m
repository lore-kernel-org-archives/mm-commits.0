Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97E3BBEA
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 00:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730248747; cv=none; b=uzqyBFmt3t4qLsMBPKIAHBIVrMhUR7oYTzg0dpoeuml8XaVcZ2whT/s7+mp2gZyv9s5X8c98eJrLiuXy37OBnUToMIYoKWhyKw4NwrPn1CroK3g8A7OSZ6xsOT6jtX7HZLNTwqbvRQN9cPkKjK8SE5FdWqYI+CxidFjqJ2LRhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730248747; c=relaxed/simple;
	bh=8PfN6Se60GB8wqy7IL7eUqlopdPow6WXck0+B3q0Ulg=;
	h=Date:To:From:Subject:Message-Id; b=WLFuE0b4tr5HFwmbAZiWzjM/K+KCuxLsJgk76N9vTsFFdHyscXTXAWeCUGjq6bHtUcY9t7ee0uezUuTpWWtS7c0hIiYoevJb+DOVK1Al9/S/tf7oN7wBcSxFG77ZhxXFyjWwQPjVP5rBSMeJmwnOT+0PiCMy8TuMy6HaW4Shww0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AS2HNMPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AS2HNMPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CCFC4CECD;
	Wed, 30 Oct 2024 00:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730248746;
	bh=8PfN6Se60GB8wqy7IL7eUqlopdPow6WXck0+B3q0Ulg=;
	h=Date:To:From:Subject:From;
	b=AS2HNMPN0E+eZQBSJpp1UPAdZXp2Jj4+gAZJJ5AVd7LN6ZM+DeEe2KIFT8T5gTDuU
	 I8CG5nrxG0dZFhDOChS+9IO2koqcoQ2nG73Mc7c59n91LJ8w3rzSi5l6d8x6RN6gR6
	 gUXgsV9YIvc2PgGkr6gqN1E7Z798TPD6Gt63S8Ns=
Date: Tue, 29 Oct 2024 17:39:06 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@suse.cz,rientjes@google.com,linkl@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-keep-track-of-free-highatomic-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241030003906.A3CCFC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-keep-track-of-free-highatomic-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-keep-track-of-free-highatomic-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-keep-track-of-free-highatomic-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-keep-track-of-free-highatomic-fix
Date: Tue Oct 29 05:37:30 PM PDT 2024

s/if/else if/, per Johannes, stealth whitespace tweak

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Link Lin <linkl@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-keep-track-of-free-highatomic-fix
+++ a/mm/page_alloc.c
@@ -644,9 +644,9 @@ static inline void account_freepages(str
 
 	if (is_migrate_cma(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
-
-	if (is_migrate_highatomic(migratetype))
-		WRITE_ONCE(zone->nr_free_highatomic, zone->nr_free_highatomic + nr_pages);
+	else if (is_migrate_highatomic(migratetype))
+		WRITE_ONCE(zone->nr_free_highatomic,
+			   zone->nr_free_highatomic + nr_pages);
 }
 
 /* Used for pages not on another list */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch

