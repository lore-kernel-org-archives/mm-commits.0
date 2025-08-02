Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417A1E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160841; cv=none; b=mAy2I5ipdVuDKXsQNM/Pvb+VmMvw4M5mHbuownm2yC9Jk4Fx5Y+/aS+5Y8Dix2px3Ys0X+L0Yr01sUNh5BdOkza5i6xRVJYtI2/7sv3paLEQC2P8ZYKFqN1ZUu4BzRHNTcjfyN1TXj8+WcKzj391cpyRxEgNB8at+wFXKwJNnAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160841; c=relaxed/simple;
	bh=EDT1FJ5AAgq29AQvyiRHmPN2xmL8lciFvTwoqiv1rxI=;
	h=Date:To:From:Subject:Message-Id; b=F/uhpgVwrQlZwimPzMyx/rMt3/YD3W7/h0bSgiYrePViwjlzKRSgyBPY2MuP9lz378Szir4P3hljfRtgLqJ3ZrEsl5ugmKp68QP5lhhMq8s7xmNZvu757Lk9Ih1CrFAJuLdeTeZ7ZEwO1rWJsy9CzCbQ9NpTnsX3vXuqSGmfV8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vFxByNhC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vFxByNhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCD6C4CEEF;
	Sat,  2 Aug 2025 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160841;
	bh=EDT1FJ5AAgq29AQvyiRHmPN2xmL8lciFvTwoqiv1rxI=;
	h=Date:To:From:Subject:From;
	b=vFxByNhCqQPxQUu0IoQ1/2+uMo8gOqlEEoPsOnWwCoq3r3fp5zk/VH2PHvXRt0jev
	 eKpr1Q3yJ7A8cxnk8KUQO3JOc4lRoR+XYbQbb2fmBmmJ1TH4mZqwpr0wyZpSjcGSyg
	 OgJ61sN53/b4/nSIpikEsRtrgAcRCsS7cOqHu2oU=
Date: Sat, 02 Aug 2025 11:54:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,raghavendra.kt@amd.com,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid.patch removed from -mm tree
Message-Id: <20250802185401.8DCD6C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: skip isolating folios already in destination nid
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/vaddr: skip isolating folios already in destination nid
Date: Fri, 25 Jul 2025 11:33:00 -0500

damos_va_migrate_dests_add() determines the node a folio should be in
based on the struct damos_migrate_dests associated with the migration
scheme and adds the folio to the linked list corresponding to that node so
it can be migrated later.  Currently, folios are isolated and added to the
list even if they are already in the node they should be in.

In using damon weighted interleave more, I've found that the overhead of
needlessly adding these folios to the migration lists can be quite high. 
The overhead comes from isolating folios and placing them in the migration
lists inside of damos_va_migrate_dests_add(), as well as the cost of
handling those folios in damon_migrate_pages().  This patch eliminates
that overhead by simply avoiding the addition of folios that are already
in their intended location to the migration list.

To show the benefit of this patch, we start the test workload and start a
DAMON instance attached to that workload with a migrate_hot scheme that
has one dest field sending data to the local node.  This way, we are only
measuring the overheads of the scheme, and not the cost of migrating
pages, since data will be allocated to the local node by default.  I
tested with two workloads: the embedding reduction workload used in [1]
and a microbenchmark that allocates 20GB of data then sleeps, which is
similar to the memory usage of the embedding reduction workload.

The time taken in damos_va_migrate_dests_add() and damon_migrate_pages()
each aggregation interval is shown below.

Before this patch:
                       damos_va_migrate_dests_add damon_migrate_pages
microbenchmark                   ~2ms                      ~3ms
embedding reduction              ~1s                       ~3s

After this patch:
                       damos_va_migrate_dests_add damon_migrate_pages
microbenchmark                    0us                      ~40us
embedding reduction               0us                      ~100us

I did not do an in depth analysis for why things are much slower in the
embedding reduction workload than the microbenchmark.  However, I assume
it's because the embedding reduction workload oversaturates the bandwidth
of the local memory node, increasing the memory access latency, and in
turn making the pointer chasing involved in iterating through a linked
list much slower.  Regardless of that, this patch results in a significant
speedup.

[1] https://lore.kernel.org/damon/20250709005952.17776-1-bijan311@gmail.com/

Link: https://lkml.kernel.org/r/20250725163300.4602-1-bijan311@gmail.com
Fixes: 19c1dc15c859 ("mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}")
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-skip-isolating-folios-already-in-destination-nid
+++ a/mm/damon/vaddr.c
@@ -711,6 +711,10 @@ static void damos_va_migrate_dests_add(s
 		target -= dests->weight_arr[i];
 	}
 
+	/* If the folio is already in the right node, don't do anything */
+	if (folio_nid(folio) == dests->node_id_arr[i])
+		return;
+
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
_

Patches currently in -mm which might be from bijantabatab@micron.com are


