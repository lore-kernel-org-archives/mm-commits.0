Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B463E1213
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897426; cv=none; b=TOC4mRioWbNQ508D1750lJoEjniUNssRV7RSMOOkW2sF0J6QzOKiq0Shq0KeQKLI5XDkdgWl2C4Oponjf6ZtdfqXQEsLcdAKLpxjv0Cv6PEP9XBdMCnxsAoQo78KcYz4zCVw8nZHm5u+9C8v7dt6WbZtLxoOsZsWECP8XlD04rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897426; c=relaxed/simple;
	bh=uzJ3xWflw/yXawIMEwBJ+Wtko1EDFrhM4VumLNWvW6k=;
	h=Date:To:From:Subject:Message-Id; b=Y6F3TmtGAVy7MaiA66ULpaazQNMYCLCpZiyxwGdPGlfTBeA4NCvDOLvfqzYY1iTMOeeZhKncryTUtiN/+mqvmNiAPSug1yn0gQ9oscRsdoj9ANmV0zi+qU9TWBcFcnpqfGXTWqi7j6GsUDzxgdTX7jovWxXtJ9tv13XvGS8mm50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwX95hCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwX95hCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F477C2BCB2;
	Mon, 30 Mar 2026 19:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897426;
	bh=uzJ3xWflw/yXawIMEwBJ+Wtko1EDFrhM4VumLNWvW6k=;
	h=Date:To:From:Subject:From;
	b=qwX95hCvUkzgRLmkCQ8M0c3ogZ//P+kKoF+2uNUOjw7LuqUGvxS82qQbNdsYlN8Z8
	 x9mpDI8ZwWU7yHeJFHOic6aHxR+QTNsPqoZW0XpJ8gTxtBOSO1yQmeTSCYqxNtU9ev
	 EBMYKdW2rXrGI9S5jyPVu1WyqtrYlE8QRCpGXGaM=
Date: Mon, 30 Mar 2026 12:03:45 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch removed from -mm tree
Message-Id: <20260330190346.8F477C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
has been removed from the -mm tree.  Its filename was
     mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
Date: Wed, 18 Mar 2026 15:53:19 -0400

Patch series "mm: switch THP shrinker to list_lru", v3.

The open-coded deferred split queue has issues. It's not NUMA-aware
(when cgroup is enabled), and it's more complicated in the callsites
interacting with it. Switching to list_lru fixes the NUMA problem and
streamlines things. It also simplifies planned shrinker work.

Patches 1-4 are cleanups and small refactors in list_lru code. They're
basically independent, but make the THP shrinker conversion easier.

Patch 5 extends the list_lru API to allow the caller to control the
locking scope. The THP shrinker has private state it needs to keep
synchronized with the LRU state.

Patch 6 extends the list_lru API with a convenience helper to do
list_lru head allocation (memcg_list_lru_alloc) when coming from a
folio. Anon THPs are instantiated in several places, and with the
folio reparenting patches pending, folio_memcg() access is now a more
delicate dance. This avoids having to replicate that dance everywhere.

Patch 7 finally switches the deferred_split_queue to list_lru.


This patch (of 7):

skip_empty is only for the shrinker to abort and skip a list that's empty
or whose cgroup is being deleted.

For list additions and deletions, the cgroup hierarchy is walked upwards
until a valid list_lru head is found, or it will fall back to the node
list.  Acquiring the lock won't fail.  Remove the NULL checks in those
callers.

Link: https://lkml.kernel.org/r/20260318200352.1039011-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20260318200352.1039011-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty
+++ a/mm/list_lru.c
@@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru,
 	struct list_lru_one *l;
 
 	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
@@ -203,9 +201,8 @@ bool list_lru_del(struct list_lru *lru,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+
 	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

