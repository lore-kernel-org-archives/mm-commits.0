Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C592D30566D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334261; cv=none; b=O8KTdp/tLXHAYXjVcsScjsBB64yLOVGPWQDo8F9WhDeZnupfILWRTc2A91CO1tGsLJfOmbJUdM62pwiT8FM7mZP6zu5egF5szw8fLfQbkoW8wYnbg30OtUutlpxQBcZlZZPsd9QrumD5XpzI+ohU8WPvSHk6cds4AxAwxTpT8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334261; c=relaxed/simple;
	bh=x7KBD9uoMfZXXgVtdIXPRpJ9OhpcW9qTEurTU3IAQ9A=;
	h=Date:To:From:Subject:Message-Id; b=Cu1PkIKQ9dIhKgN1VjOJk/2upKUgGgF6ZrhmHAv1wSK/WmAEEtRp+4uwE4y3+2woTefCEH0yRWi2epyLP9xBwDW8DOHF2v3g9rdAVbehzrNeu9rtRBrvN71873tHMyZ+OvBBih4XTzjUb013kfu8ywCjkf5nqPNMjEcs1+NRXbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=obNsibUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="obNsibUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEDA1F0089C;
	Wed,  7 Oct 2026 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334260;
	bh=Hv6TdTwPPAQE0mPJGDteLKVYrJMYTl1AOWvdVr/X5l8=;
	h=Date:To:From:Subject;
	b=obNsibUoxGgT6q/bkW2zgTXfAl6W/3Ksr9G0i4I5fynKAsJDyqvG6An6Zg3jlYS23
	 LdAWIGx2UBbQ1bhVwKaDhWg5P6xgRVJKQ0R+jKyurbbz24HSutCMmBei/E18qWDA5x
	 2gghQSBTUqQ10LSZ8dhKdaUWX2Xvxk+ziwcK9bhU=
Date: Tue, 06 Oct 2026 17:50:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch removed from -mm tree
Message-Id: <20261007005100.6AEDA1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: replace custom bad page ratelimiting logic
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm/page_alloc: replace custom bad page ratelimiting logic
Date: Tue, 11 Aug 2026 18:21:56 +0100

The current logic (allow up to $BURST prints per minute) can be entirely
replaced by the generic version in lib/ratelimit.c, used around the
kernel.

Do so. The only functional difference should be that the new logs will
read something like:

KERN_WARNING "bad_page: %d callbacks suppressed\n", ...

But that should be fine enough.

Link: https://lore.kernel.org/20260811172156.356053-3-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 mm/page_alloc.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-custom-bad-page-ratelimiting-logic
+++ a/mm/page_alloc.c
@@ -613,31 +613,13 @@ static inline bool __maybe_unused bad_ra
 }
 #endif
 
+/* Allow a burst of 60 reports per minute */
+static DEFINE_RATELIMIT_STATE(bad_page_ratelimit, 60 * HZ, 60);
+
 static void bad_page(struct page *page, const char *reason)
 {
-	static unsigned long resume;
-	static unsigned long nr_shown;
-	static unsigned long nr_unshown;
-
-	/*
-	 * Allow a burst of 60 reports, then keep quiet for that minute;
-	 * or allow a steady drip of one report per second.
-	 */
-	if (nr_shown == 60) {
-		if (time_before(jiffies, resume)) {
-			nr_unshown++;
-			goto out;
-		}
-		if (nr_unshown) {
-			pr_alert(
-			      "BUG: Bad page state: %lu messages suppressed\n",
-				nr_unshown);
-			nr_unshown = 0;
-		}
-		nr_shown = 0;
-	}
-	if (nr_shown++ == 0)
-		resume = jiffies + 60 * HZ;
+	if (!__ratelimit(&bad_page_ratelimit))
+		goto out;
 
 	pr_alert("BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
_

Patches currently in -mm which might be from pfalcato@suse.de are


