Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A739C218EBA
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 20:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468057; cv=none; b=HdncyYviEaG95e43Dwbolb6kWMIy38sKhI7Y40JvmLQ8n6IyLnDF6N4vvfXEHKggHC7UvPlhMZPo+jD9U6FjOudu++fRrQHrlJTkwbhiRlBcGGbdFjbr3AXphC4xmQu/aBgX7y/QWRrt0SuOE6Cmmhq4ZbsLSc9Z+BNanV6Epd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468057; c=relaxed/simple;
	bh=OxpPe1NR2wEzZJ4k6UuAVe55Qz14DzadxwHxQITNlpM=;
	h=Date:To:From:Subject:Message-Id; b=nTw7oeOMgq0cLr9q4BWXTc8SKBbnUNYSNqg5PkJ/i5eB1zGqgt8B7skP5OkUHxohlau7Q7y2/r+iAJruKu99MJ4fkWZtmbOqO/uX93/YGyUKrmED0fozn0CBRLkQTqhbz/sjvcwaWej+2cl/X/prDgcPJCuF9PvY9Wr307KQBAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5daFcOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5daFcOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2FF1F000E9;
	Thu,  3 Sep 2026 20:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788468039;
	bh=5/oI66evUZY7CYxVi6foGGzMnvxM8izxg1UOTgIpDRs=;
	h=Date:To:From:Subject;
	b=d5daFcOD8lIwKyKoFPc2ucu1uT6tj2CNzTxYpImFp1TNH/XozaeF3ckA5uw/3UfBy
	 7npxH+mwZq6kyRe0sB9TWmwM7SRdqpyzYGFe4dNfNfKP1HlCDyZZsq9TagOD4v47Y1
	 hRH+L8eU4QJnyOH+ddjtQTmY2HS7d3DjjoU5Mi8M=
Date: Thu, 03 Sep 2026 13:40:39 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chenridong@xiaomi.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch added to mm-unstable branch
Message-Id: <20260903204039.9A2FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: revert slight behavior change for swappiness 1-200
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: revert slight behavior change for swappiness 1-200
Date: Thu, 3 Sep 2026 14:48:52 +0800

Baoquan's review found that we unexpectedly introduced a slight behavior
change for swappiness 1-200. We could now have a case like:

1. First scan -> `scanned != 0`
2. Second scan -> `scanned = 0`
3. Type fallback

Step 3 was impossible before. Let's remove this possibility.

Link: https://lore.kernel.org/20260903070500.76379-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reported-by: Baoquan He <baoquan.he@linux.dev>
Closes: https://lore.kernel.org/linux-mm/apfZQE1X6zGAsBb_@fedora/
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <chenridong@xiaomi.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix
+++ a/mm/vmscan.c
@@ -4858,7 +4858,7 @@ retry:
 	 * We are running out of the current reclaim type. Fall back to
 	 * the other type if allowed.
 	 */
-	if (!scanned && type_fallback_allowed) {
+	if (!scanned && !tried && type_fallback_allowed) {
 		type = !type;
 		tried = true;
 		type_fallback_allowed = false;
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-mglru-make-retry-logic-explicit-in-isolate_folios-fix.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch
mm-mglru-separate-folio-generation-update-from-lru-accounting.patch
mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch
mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch
mm-mglru-exclude-folios-promoted-by-aging-from-protected-in-inc_min_seq.patch
mm-mglru-make-lru-folio-prefetch-helper-an-inline-function.patch
mm-mglru-move-folios-from-oldest-gen-to-second-oldest-gen-from-head-to-tail.patch
mm-mglru-batch-move-folios-to-the-second-oldest-gens-lru.patch

