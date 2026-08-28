Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A587A3B9927;
	Fri, 28 Aug 2026 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787948274; cv=none; b=Ps9YZTv73ozZel+l16JSANsQBrO6FQ3Ig+5aiyT71iBAz1NSeU5wq/nV+wDEbIaDnCMEGxbFrO4x/Ui1xiDWNpUUCbRCqhDj/Z0qnwvUbkBPytmNx9SZUyY/9JBlYZisgtlPafSipn2ZRjDFLrKHnEIPeX0PasfOfARePu6fLtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787948274; c=relaxed/simple;
	bh=FgfYKGFgSetuMUHy4hEzMQsH1/zi/8Fq0psKJoL29Yk=;
	h=Date:To:From:Subject:Message-Id; b=kpzcxHn99fry+f4b7Fo7FF5MBKOEdhw2Ew025Q5HlMUNuDwKsHMk0sviLmf8EVxywuNyrB01djROuJKVFa6Nl9AIX2PHrcaCjdBL4P91pdt4s+h1pnV/I2lFn4sw/vzZAoWNtCDnFJK+wPGrcbYWz5nTDrkWPuA/GYQYUJn8xKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NmhaaV4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NmhaaV4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110651F000E9;
	Fri, 28 Aug 2026 20:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787948272;
	bh=mKg6eCvSdJocWjYIk+kQAcRn1zZ7RT3pb0vDWn04DRI=;
	h=Date:To:From:Subject;
	b=NmhaaV4Ar6dLDOGgb1rQTgMHNGGZUtNsi6a2kuM+Wld7MSsnBjyi/0bhQThZSceiW
	 rRczXMZpdRCJAzeAHLaZuJ7LLPOskxRCk4W3YvzbIn0+01dczpdjzR0RKCqHNO1ols
	 /MDr6/DwsWoud++j3jYbLI9f6ttLUcVEymMJafRU=
Date: Fri, 28 Aug 2026 13:17:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,urezki@gmail.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,david@kernel.org,chenwandun@huawei.com,chelsyratnawat2001@gmail.com,byungchul@sk.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch added to mm-new branch
Message-Id: <20260828201752.110651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: take a cpuset cookie for the interleave node count
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: mm/mempolicy: take a cpuset cookie for the interleave node count
Date: Fri, 28 Aug 2026 15:31:11 -0400

alloc_pages_bulk_interleave() counts pol->nodes without a cpuset cookie:

	nodes = nodes_weight(pol->nodes);
	nr_pages_per_node = nr_pages / nodes;

nodemask_t spans several words once MAX_NUMNODES exceeds BITS_PER_LONG, so
a concurrent cpuset rebind can tear that read and yield an empty mask even
though neither version of it was empty.  The call then allocates nothing
and returns 0.

Some compilers will hoist the loop entry test above the division,
because nr_pages_per_node is dead when the loop does not run.

	682e:	call	...		<- nodes_weight()
	6838:	test	%eax,%eax
	683a:	jle	692d		<- nodes <= 0 skips the loop
	684a:	div	%rcx

So in most deployments, this div/0 is unreachable - but nothing in the
source guarantees that, it's just not easily exercised.

Take the cookie around the count and bail if the mask really is empty. 
Only the count needs it, interleave_nodes() takes the cookie itself so so
a torn read there is already retried.

A rebind landing mid-loop can still leave the count disagreeing with the
mask, so the loop may revisit a node or skip one - but a rebind where
nodes change causes migration, so a handful of misplaced pages isn't
catastrophic in any sense.

Measured on a 72 node VM (NODES_SHIFT=10) with a cgroup v2 cpuset flipping
cpuset.mems between a word 0 and a word 1 node set, and the two word read
artificially widened: 330 zero counts in 130414 calls without the cookie,
and 401 retries with it.

Link: https://lore.kernel.org/20260828193111.1023497-1-gourry@gourry.net
Fixes: c00b6b961099 ("mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reported-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Link: https://lore.kernel.org/all/20250907160829.91628-1-chelsyratnawat2001@gmail.com/
Assisted-by: Claude:claude-opus-5
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chenwandun <chenwandun@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count
+++ a/mm/mempolicy.c
@@ -2592,6 +2592,7 @@ static unsigned long alloc_pages_bulk_in
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
+	unsigned int cpuset_mems_cookie;
 	int nodes;
 	unsigned long nr_pages_per_node;
 	int delta;
@@ -2599,7 +2600,16 @@ static unsigned long alloc_pages_bulk_in
 	unsigned long nr_allocated;
 	unsigned long total_allocated = 0;
 
-	nodes = nodes_weight(pol->nodes);
+	/* count the nodes, retry if a rebind happened during the read */
+	do {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nodes = nodes_weight(pol->nodes);
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+	/* if the nodemask has become invalid, we cannot do anything */
+	if (!nodes)
+		return 0;
+
 	nr_pages_per_node = nr_pages / nodes;
 	delta = nr_pages - nodes * nr_pages_per_node;
 
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch

