Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4012E1A262D
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 03:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788060791; cv=none; b=U8aU0fq2pLaCCLToozTihxmAw5+QWy+0C8QJbzlFz/qNVMGi4IYQb2uf3h2Qm1h9YYvtCmwnxjNFMD0f1HE+nyNXtJSQefDG49sHR0OSfAdyiv5j5swIWdiusZqN8LTeXD9KAw8zxt1yi3hLK1YXHgFVR5pChj9vf34FDWTx2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788060791; c=relaxed/simple;
	bh=jI9Lfyo/WoIpKdSkwtTV1BtqBdv/pN0+u3DDdAFqKD8=;
	h=Date:To:From:Subject:Message-Id; b=kUHUMDavM0tR2m5c8Yky5yo/mdDtAevSmskjX7cM/p5SG1Gmg2L4PwPE8ZdshauREVi794jrK3VreZBJNYKi5icktRd8AAVrlAsx/3u2xNP+Hmb0yR2HXIzmt80C1C6/QSJLENBnCcouoVi7cF6yJPhG6oTjdxGqddvftErnQc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toNRlC5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toNRlC5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C100B1F000E9;
	Sun, 30 Aug 2026 03:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788060789;
	bh=Vxs7UpRYHwWnBtGA5n+f8jhJc5wR4m9GxWdpYUoWrHg=;
	h=Date:To:From:Subject;
	b=toNRlC5y9WbMZMcuRyvF5E5EWr6qBH7Fj4HYdpX+WMOhf6eZJ0NmM/TdTklwM/v8K
	 6jl6zzrP1P4A6gJOBagcQC5WddZEBETBpyL+5QT1UWvWVtNyEg7+paRK0tlZuvWEMF
	 Bd+Q2ZoCrMms3uP7RElM5Xms7a9mRQFn18SG5PSk=
Date: Sat, 29 Aug 2026 20:33:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch added to mm-new branch
Message-Id: <20260830033309.C100B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: replace custom bad page ratelimiting logic
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

x86-alternative-exclude-text-poking-against-change_page_attr.patch
mm-replace-custom-bad-page-map-ratelimiting-logic.patch
mm-page_alloc-replace-custom-bad-page-ratelimiting-logic.patch

