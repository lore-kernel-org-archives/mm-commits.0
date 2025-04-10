Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2BB290094
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 20:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744317594; cv=none; b=CSYgArScolKe6hRWSG3qDuDYpThWbpRK9YqJJTjYkuxz7nMsXnmoh8zZUxqbwr6fp4QhURLT7YlgaJbF640IeFXvQjkm73PRZ1Hv2JD/ZtAVQOEqg0jqBWPRr3pyRtdBitTmIz73OtwI0uyWRWZDjTI3WXyVL3S8nYc4I6ONtnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744317594; c=relaxed/simple;
	bh=7VeZfOWp54KXjlM2Y7O7piRg8GBIzHagAgQNCL36yIM=;
	h=Date:To:From:Subject:Message-Id; b=Eo5dafWOwYAF9OrBST//axV98aT4ODcnhrl2jwYKXace8XO8Zt6FHHKevpDDE9Rrt2H3LlSZxpNBqW1CdTHtySuYnmHkvZdkZqUlEcmVe/tEpHQyx5WJBNuZH+HcdC7DimpSNjEHaavH1xzwWQQncU/A9Bc9G6u735FU0kAHzD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WoNRAUO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WoNRAUO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA54C4CEE7;
	Thu, 10 Apr 2025 20:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744317594;
	bh=7VeZfOWp54KXjlM2Y7O7piRg8GBIzHagAgQNCL36yIM=;
	h=Date:To:From:Subject:From;
	b=WoNRAUO+gkoTyu5+imF1yhzO8BQp1MV3+R1/a7HHg48EaGBJK4p0zEuZCoh8/0iuZ
	 Pqj5SjR36BlIGkaBr3gW9LVuCA8cRD1vgr3nsCJWS4QsqiBOBqM1uFBsD5bUz4iikW
	 dvIqUe64Dve6hkN5jAVLo6W9e9YIOYEfyYMbNi4E=
Date: Thu, 10 Apr 2025 13:39:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch added to mm-new branch
Message-Id: <20250410203954.4EA54C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: convert mas_prealloc_calc() to take in a maple write state
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch

This patch will later appear in the mm-new branch at
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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: convert mas_prealloc_calc() to take in a maple write state
Date: Thu, 10 Apr 2025 19:14:41 +0000

Patch series "Track node vacancy to reduce worst case allocation counts", v5.

================ overview ========================
Currently, the maple tree preallocates the worst case number of nodes for
given store type by taking into account the whole height of the tree. 
This comes from a worst case scenario of every node in the tree being full
and having to propagate node allocation upwards until we reach the root of
the tree.  This can be optimized if there are vacancies in nodes that are
at a lower depth than the root node.  This series implements tracking the
level at which there is a vacant node so we only need to allocate until
this level is reached, rather than always using the full height of the
tree.  The ma_wr_state struct is modified to add a field which keeps track
of the vacant height and is updated during walks of the tree.  This value
is then read in mas_prealloc_calc() when we decide how many nodes to
allocate.

For rebalancing and spanning stores, we also need to track the lowest
height at which a node has 1 more entry than the minimum sufficient number
of entries.  This is because rebalancing can cause a parent node to become
insufficient which results in further node allocations.  In this case, we
need to use the sufficient height as the worst case rather than the vacant
height.

patch 1-2: preparatory patches
patch 3: implement vacant height tracking + update the tests
patch 4: support vacant height tracking for rebalancing writes
patch 5: implement sufficient height tracking
patch 6: reorder switch case statements

================ results =========================
Bpftrace was used to profile the allocation path for requesting new maple
nodes while running stress-ng mmap 120s.  The histograms below represent
requests to kmem_cache_alloc_bulk() and show the count argument.  This
represnts how many maple nodes the caller is requesting in
kmem_cache_alloc_bulk()

command: stress-ng --mmap 4 --timeout 120

mm-unstable 

@bulk_alloc_req:
[3, 4)                 4 |                                                    |
[4, 5)             54170 |@                                                   |
[5, 6)                 0 |                                                    |
[6, 7)            893057 |@@@@@@@@@@@@@@@@@@@@                                |
[7, 8)                 4 |                                                    |
[8, 9)           2230287 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[9, 10)            55811 |@                                                   |
[10, 11)           77834 |@                                                   |
[11, 12)               0 |                                                    |
[12, 13)         1368684 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     |
[13, 14)               0 |                                                    |
[14, 15)               0 |                                                    |
[15, 16)          367197 |@@@@@@@@                                            |


@maple_node_total: 46,630,160
@total_vmas: 46184591

mm-unstable + this series

@bulk_alloc_req:
[2, 3)               198 |                                                    |
[3, 4)                 4 |                                                    |
[4, 5)                43 |                                                    |
[5, 6)                 0 |                                                    |
[6, 7)           1069503 |@@@@@@@@@@@@@@@@@@@@@                               |
[7, 8)                 4 |                                                    |
[8, 9)           2597268 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[9, 10)           472191 |@@@@@@@@@                                           |
[10, 11)          191904 |@@@                                                 |
[11, 12)               0 |                                                    |
[12, 13)          247316 |@@@@                                                |
[13, 14)               0 |                                                    |
[14, 15)               0 |                                                    |
[15, 16)           98769 |@                                                   |


@maple_node_total: 37,813,856
@total_vmas: 43493287

This represents a ~19% reduction in the number of bulk maple nodes allocated.

For more reproducible results, a historgram of the return value of
mas_prealloc_calc() is displayed while running the maple_tree_tests whcih
have a deterministic store pattern

mas_prealloc_calc() return value mm-unstable
1   :                                                    (12068)
3   :                                                    (11836)
5   : *****                                              (271192)
7   : ************************************************** (2329329)
9   : ***********                                        (534186)
10  :                                                    (435)
11  : ***************                                    (704306)
13  : ********                                           (409781)

mas_prealloc_calc() return value mm-unstable + this series
1   :                                                    (12070)
3   : ************************************************** (3548777)
5   : ********                                           (633458)
7   :                                                    (65081)
9   :                                                    (11224)
10  :                                                    (341)
11  :                                                    (2973)
13  :                                                    (68)

do_mmap latency was also measured for regressions:
command: stress-ng --mmap 4 --timeout 120

mm-unstable:
avg = 7162 nsecs, total: 16101821292 nsecs, count: 2248034

mm-unstable + this series:
avg = 6689 nsecs, total: 15135391764 nsecs, count: 2262726


stress-ng --mmap4 --timeout 120

with vacant_height:
stress-ng: info:  [257]                   21526312 Maple Tree Read                0.176 M/sec
stress-ng: info:  [257]                  339979348 Maple Tree Write               2.774 M/sec

without vacant_height:
stress-ng: info:  [8228]                   20968900 Maple Tree Read                0.171 M/sec
stress-ng: info:  [8228]                  312214648 Maple Tree Write               2.547 M/sec

This represents an increase of ~3% read throughput and ~9% increase in
write throughput.


This patch (of 6):

In a subsequent patch, mas_prealloc_calc() will need to access fields only
in the ma_wr_state.  Convert the function to take in a ma_wr_state and
modify all callers.  There is no functional change.

Link: https://lkml.kernel.org/r/20250410191446.2474640-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20250410191446.2474640-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/lib/maple_tree.c~maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state
+++ a/lib/maple_tree.c
@@ -4140,13 +4140,14 @@ set_content:
 /**
  * mas_prealloc_calc() - Calculate number of nodes needed for a
  * given store oepration
- * @mas: The maple state
+ * @wr_mas: The maple write state
  * @entry: The entry to store into the tree
  *
  * Return: Number of nodes required for preallocation.
  */
-static inline int mas_prealloc_calc(struct ma_state *mas, void *entry)
+static inline int mas_prealloc_calc(struct ma_wr_state *wr_mas, void *entry)
 {
+	struct ma_state *mas = wr_mas->mas;
 	int ret = mas_mt_height(mas) * 3 + 1;
 
 	switch (mas->store_type) {
@@ -4243,16 +4244,15 @@ static inline enum store_type mas_wr_sto
  */
 static inline void mas_wr_preallocate(struct ma_wr_state *wr_mas, void *entry)
 {
-	struct ma_state *mas = wr_mas->mas;
 	int request;
 
 	mas_wr_prealloc_setup(wr_mas);
-	mas->store_type = mas_wr_store_type(wr_mas);
-	request = mas_prealloc_calc(mas, entry);
+	wr_mas->mas->store_type = mas_wr_store_type(wr_mas);
+	request = mas_prealloc_calc(wr_mas, entry);
 	if (!request)
 		return;
 
-	mas_node_count(mas, request);
+	mas_node_count(wr_mas->mas, request);
 }
 
 /**
@@ -5397,7 +5397,7 @@ void *mas_store(struct ma_state *mas, vo
 		return wr_mas.content;
 	}
 
-	request = mas_prealloc_calc(mas, entry);
+	request = mas_prealloc_calc(&wr_mas, entry);
 	if (!request)
 		goto store;
 
@@ -5494,7 +5494,7 @@ int mas_preallocate(struct ma_state *mas
 
 	mas_wr_prealloc_setup(&wr_mas);
 	mas->store_type = mas_wr_store_type(&wr_mas);
-	request = mas_prealloc_calc(mas, entry);
+	request = mas_prealloc_calc(&wr_mas, entry);
 	if (!request)
 		return ret;
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

