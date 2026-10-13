Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE864825B3;
	Tue, 13 Oct 2026 04:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865947; cv=none; b=ml3tJUYcvhAjYa3UHXpI844ceIBS4TQPwRkB6UNLsoxj8CHvMLT4/cuFUtn3AWiFLj6dbiuYgJhABRGIZ/Jyv5hHm8rzSFtZpwxhdWHOw4VJH7PkNi1zxeMYl9JpyzKvIZd9ndNDFYwH0qXANUmKgPNkMMI+zBClCh78HdTgM6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865947; c=relaxed/simple;
	bh=NIWA1WQxaEymU4wFzgwQH1eTfwDMfG+/zxRzzBByF2Q=;
	h=Date:To:From:Subject:Message-Id; b=gqD47AmepJ/QC4aBKpiex75HmiN4ftKn/3DYpjeG+i4wb2xAWuppk+1PHdm42xPNegFGBiEMgJYRLu7rEFtAej2VUuvtuudjIbW2nRA+ddbIOWjsv7TvocZ+b9blr9Bbzb94gzyaHhNj/9vms7WGudqnTgnJOA3f3ZSEve+vjyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xjbYuQaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xjbYuQaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F281B1F00893;
	Tue, 13 Oct 2026 04:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865946;
	bh=0DoRAJFIA+pMWFa+VGB3So+W1nWqOul0K0Vm/qCmWLw=;
	h=Date:To:From:Subject;
	b=xjbYuQaRCTMMNzWgjNDB9NmFhgsId1c6ZI1jGpHk4lyl/kruoUSaYwhYYUPFWeTQn
	 YBjfjbRJC7cessXpM3RUo3+bn2UfsqWR+kzaNk8Yv8dKIIhUKYB9+H5LvJ3jl6PBR0
	 uCDhB7LXJZrp1S4DooGRAMdriFdmCrnL2upd4NfY=
Date: Mon, 12 Oct 2026 21:32:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch removed from -mm tree
Message-Id: <20261013043225.F281B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: use folio_trylock() in the cold/pageout PMD split
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Sat, 12 Sep 2026 07:05:40 -0400

MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
madvise_cold_or_pageout_pte_range().  Two threads doing that to the same
THP create spurious failures.

  CPU0                          CPU1
  ----                          ----
  folio_get()
  spin_unlock(ptl)
  folio_lock()
                                folio_get()
                                spin_unlock(ptl)
                                folio_lock()  <- blocks, keeps its ref
  split_folio()
    folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
    -EAGAIN

CPU1 cannot drop its reference until it gets the lock CPU0 holds, so
CPU0's split always fails.  folio_trylock() makes CPU1 leave without ever
taking a reference.  The PTE branch of this same function already does
this, as do madvise_free_pte_range() and madvise_free_huge_pmd().

Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
/proc/vmstat:

                     thp_split_page   thp_split_page_failed
    before                     3186                     860
    after                      3200                       0

The short before count is rounds where every thread failed and the advice
was dropped for that THP entirely.

On failure the walker returns 0 and nothing retries.  The PMD path becomes
best effort when the folio lock is held elsewhere - same as the PTE path.

Link: https://lore.kernel.org/20260912110540.3203010-1-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split
+++ a/mm/madvise.c
@@ -417,9 +417,10 @@ static int madvise_cold_or_pageout_pte_r
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
+			if (!folio_trylock(folio))
+				goto huge_unlock;
 			folio_get(folio);
 			spin_unlock(ptl);
-			folio_lock(folio);
 			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

