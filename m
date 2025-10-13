Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180E02EC56F
	for <mm-commits@vger.kernel.org>; Mon, 13 Oct 2025 22:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760395231; cv=none; b=A5Qqcgy0OwxqikoQhFS9e40JuwAL8jkbqnUapoTcDtrGNTEjoXrjnvyNQuLT6moQp5EY7OhhUyQKJr7cr/G0dOLfFPj6bl+pa/HavoXP0pCMrmcfkGsl5pvRpiHLvtt3MU5nA42h4FB9LYGSnhZF92+w000robPuED89ox9Wsn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760395231; c=relaxed/simple;
	bh=RAW7lVCPv8GsVCvBJOiLilSowYmmN2/CUHxHCMXXni8=;
	h=Date:To:From:Subject:Message-Id; b=ZonYV2vJUWX7y00OQknMqrVsYjh0ntImRUUOOG06EqKKGwGWKODbSIkxvWVIvoHo3vqyERDzefkav8Mlh3B5dbaKzq/rJDDu5KunVRh0uNcdiwrngtgC0K4Wg9sF7B1wDzEirpEKjcZPbLaytxbzB5YVES8/MFlZtDmwhqcqIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fZjPuZSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fZjPuZSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0148C113D0;
	Mon, 13 Oct 2025 22:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760395230;
	bh=RAW7lVCPv8GsVCvBJOiLilSowYmmN2/CUHxHCMXXni8=;
	h=Date:To:From:Subject:From;
	b=fZjPuZSQ/06la5T4cEsF//KXMBDxK/1p0xsxJKvbfb0Go/kRf6h+weiEWsndVDc5b
	 CisGe7lbXrheZ1nTrKa17AgisAsZ2m33BJkmaSFfK+ySwh7dihSB2ahjbKbe0fFHIt
	 Ha4v/23wOOcHICh7STz8wQaOYLugXNXAdMQ2g4dg=
Date: Mon, 13 Oct 2025 15:40:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,clm@fb.com,akpm@linux-foundation.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch added to mm-new branch
Message-Id: <20251013224030.D0148C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: batch page freeing in decay_pcp_high
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/page_alloc: batch page freeing in decay_pcp_high
Date: Mon, 13 Oct 2025 12:08:10 -0700

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot. 
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp or zone lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Link: https://lkml.kernel.org/r/20251013190812.787205-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-page-freeing-in-decay_pcp_high
+++ a/mm/page_alloc.c
@@ -2559,7 +2559,7 @@ static int rmqueue_bulk(struct zone *zon
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2577,11 +2577,14 @@ bool decay_pcp_high(struct zone *zone, s
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch
mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch
mm-page_alloc-vmstat-simplify-refresh_cpu_vm_stats-change-detection.patch
mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch

