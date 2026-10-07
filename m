Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBEC2FE566
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334260; cv=none; b=NcVqK2y/erwI0gKqnRWnwlLPcxg38dow2JfWCoHFpuq/5T3uwGCsTm+scXEBzgTo8BoUuZPhYv3wLRZgMQU+/E9GX2kWbyG3tlYsCFWesDtAX7GrvIJOefuO0PQ+kltELoD/eor7/uanrmjLtSGUKrpMMMuMG56sWqEwgSs0xg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334260; c=relaxed/simple;
	bh=Ay8K1ZPJXsX7eYo+OKtDOCkg3ZHdTGP4pMVXOgpdQ9M=;
	h=Date:To:From:Subject:Message-Id; b=ccIzpSRwoVbPwEk6yZtjJWK6Ms6Gz4wSGSFtUF47Jvkb0KkIm/v574A6Wv/9gvgPNDfQqBGqaMxS8zZ41hZxueKWsx4JKN6HrX3naOuPiEXvAzIKQzoQ/K7XRBGMnMGnTFLKGPoLn4b8t9LBkLOvYA7Oh2izN9UBk68mogOg2xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swH7S4Qm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swH7S4Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442991F0089B;
	Wed,  7 Oct 2026 00:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334259;
	bh=hTrTovSqo1p37brVyX7kBVDyOjAXXDTGU7zYlzTTqkw=;
	h=Date:To:From:Subject;
	b=swH7S4QmIBn4UxPQ9OLbPpI/+NM+RW4KmCTdSDApSDdOV09SrPy9XqIbG9IHcxEP3
	 KTX9QRkU325tsKBb2+l17LpEO2MNx2a/5x5u1QwUrZAyemi/Y9UJVxFlqKd+Naq/7m
	 Rgv4USMvDs0IiXn7xEfIxweUsMkO5cETB3O5Jmbo=
Date: Tue, 06 Oct 2026 17:50:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-custom-bad-page-map-ratelimiting-logic.patch removed from -mm tree
Message-Id: <20261007005059.442991F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace custom bad page map ratelimiting logic
has been removed from the -mm tree.  Its filename was
     mm-replace-custom-bad-page-map-ratelimiting-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm: replace custom bad page map ratelimiting logic
Date: Tue, 11 Aug 2026 18:21:55 +0100

Patch series "mm: replace custom ratelimiting logic".

The kernel has a perfectly cromulent and mostly-equivalent variant in
lib/ratelimit.c that can be used.


This patch (of 2):

The current logic (allow up to $BURST prints per minute) can be entirely
replaced by the generic version in lib/ratelimit.c, used around the
kernel.

Do so.  The only functional difference should be that the new logs will
read something like:

KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...

But that should be fine enough.

Link: https://lore.kernel.org/20260811172156.356053-1-pfalcato@suse.de
Link: https://lore.kernel.org/20260811172156.356053-2-pfalcato@suse.de
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

 mm/memory.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

--- a/mm/memory.c~mm-replace-custom-bad-page-map-ratelimiting-logic
+++ a/mm/memory.c
@@ -492,32 +492,8 @@ static inline void add_mm_rss_vec(struct
 			add_mm_counter(mm, i, rss[i]);
 }
 
-static bool is_bad_page_map_ratelimited(void)
-{
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
-			return true;
-		}
-		if (nr_unshown) {
-			pr_alert("BUG: Bad page map: %lu messages suppressed\n",
-				 nr_unshown);
-			nr_unshown = 0;
-		}
-		nr_shown = 0;
-	}
-	if (nr_shown++ == 0)
-		resume = jiffies + 60 * HZ;
-	return false;
-}
+/* Allow a burst of 60 bad page map reports per minute. */
+static DEFINE_RATELIMIT_STATE(bad_page_map_ratelimit, 60 * HZ, 60);
 
 static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
 {
@@ -633,7 +609,7 @@ static void print_bad_page_map(struct vm
 	char entry_str[PTVAL_STR_MAX];
 	pgoff_t index, anon_index;
 
-	if (is_bad_page_map_ratelimited())
+	if (!__ratelimit(&bad_page_map_ratelimit))
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
_

Patches currently in -mm which might be from pfalcato@suse.de are


