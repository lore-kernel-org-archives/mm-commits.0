Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96868D310
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255744; cv=none; b=pGbBWWCPkEsPqFMW+sLn3D+QI3dqUONXmW8Gd1kU4QeNpaP6XBh1UDYVbqh8dPE1KLkBIbXwxJq3YQzJhR3aoD2kPOZrDQ83WFStcWey+Iz4DInrKJ3YVP8SFPsAUsHNHRGL17bBVaSe9h5fO7k2BkkKslRoXQw8hs5fhMScRrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255744; c=relaxed/simple;
	bh=B5TItjpRyZ/U0N2fh0hcEDgkLCv+3IBD3HiPUtAmWlM=;
	h=Date:To:From:Subject:Message-Id; b=jGhMLOxFT6YQzWJP6GTZggSsTwTDeh/qwX/uE6SwswFAol6q87s4S2h7XbKHvJwQGMMmag+Dj7Gu4LWFK09iAqaOiQHUoJdvE7qQQrtN34NuFn1Dwla//Lnauj9dJdphVJjhZwIQ0WoO5s7FJmpkNJ4z9JRUQa7Dr364KjasMPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ASEg6pvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ASEg6pvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F323AC433F1;
	Fri, 26 Jan 2024 07:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255744;
	bh=B5TItjpRyZ/U0N2fh0hcEDgkLCv+3IBD3HiPUtAmWlM=;
	h=Date:To:From:Subject:From;
	b=ASEg6pvBO0SfH7TSoicGL1VJO75nQxD/95GQdFmv1NcdNDu+RRBBMoRs0AmvM8kBy
	 jwkgtRWUHBUhxtXaniM1xZDJNVU5uBl07se4iVaqN9HmNh1ExOg4aHMeynCI1UJneC
	 ZC2GmVf3TdLCjk0VLIYrFHXia40xrvIWsjW4biQo=
Date: Thu, 25 Jan 2024 23:55:41 -0800
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range.patch removed from -mm tree
Message-Id: <20240126075543.F323AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: fix folio_set_dirty() vs. folio_mark_dirty() in zap_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: fix folio_set_dirty() vs. folio_mark_dirty() in zap_pte_range()
Date: Mon, 22 Jan 2024 18:17:51 +0100

The correct folio replacement for "set_page_dirty()" is
"folio_mark_dirty()", not "folio_set_dirty()".  Using the latter won't
properly inform the FS using the dirty_folio() callback.

This has been found by code inspection, but likely this can result in some
real trouble when zapping dirty PTEs that point at clean pagecache folios.

Yuezhang Mo said: "Without this fix, testing the latest exfat with
xfstests, test cases generic/029 and generic/030 will fail."

Link: https://lkml.kernel.org/r/20240122171751.272074-1-david@redhat.com
Fixes: c46265030b0f ("mm/memory: page_remove_rmap() -> folio_remove_rmap_pte()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lkml.kernel.org/r/2445cedb-61fb-422c-8bfb-caf0a2beed62@arm.com
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range
+++ a/mm/memory.c
@@ -1464,7 +1464,7 @@ static unsigned long zap_pte_range(struc
 			delay_rmap = 0;
 			if (!folio_test_anon(folio)) {
 				if (pte_dirty(ptent)) {
-					folio_set_dirty(folio);
+					folio_mark_dirty(folio);
 					if (tlb_delay_rmap(tlb)) {
 						delay_rmap = 1;
 						force_flush = 1;
_

Patches currently in -mm which might be from david@redhat.com are


