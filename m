Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62FFFBF6
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 01:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736904726; cv=none; b=csBXGRAVWuiTxZuxHLPQCCNxt/WFstkfJDe2888mF3zj7GyZAaG17FcRLk6xh4nkS1coH9NJgonTXLgKIM8ZDIBL47hNKmBsTPJ3T2uKBeqoV3CJj/0jqdw0+ZkaI/zZaFy4zOZKRw8kUXOq+//knqEg8QRSPklns/zCt4MF2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736904726; c=relaxed/simple;
	bh=i/cvrrpOhV7W4yuEfPSAV5RtKDPS8HARz9bWIGm5Hzg=;
	h=Date:To:From:Subject:Message-Id; b=TxKqlf87iM2KbU8s1Y6lkuB3JIhIRIxN/WWcOFlzBXs4eT1YvjRWMXNSPZ4t9vTfO/sbLfRkTNBc+V1n/d3u2BVVBGkmMuhDyKE61E8FliV8ELKl8s2Eqj26XnSrjKL+AsLZzMZSTBWJveGj3XQVpxx5JzGVgP9sI5Mt+KLsvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rk536+QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rk536+QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30930C4CEDF;
	Wed, 15 Jan 2025 01:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736904725;
	bh=i/cvrrpOhV7W4yuEfPSAV5RtKDPS8HARz9bWIGm5Hzg=;
	h=Date:To:From:Subject:From;
	b=rk536+QTvxHrM8TyzkZh8rga48RjhMvkZG31vnhYzE/KEFQPA+ALJXLmtISORc15u
	 qRaA7jT3FNAVcWuW9B7/XhpCRk9RwHeNog6le0QxSilCImBKWZaPk+SZ0kFTrx7YDi
	 n5YpKb7N35Ep8cj+xYTfK/zfmZy9rGuU6WO3SRXc=
Date: Tue, 14 Jan 2025 17:32:04 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch removed from -mm tree
Message-Id: <20250115013205.30930C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: skip memory compaction when there are not enough migratable pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm: compaction: skip memory compaction when there are not enough migratable pages
Date: Wed, 8 Jan 2025 19:30:54 +0800

There are 4 NUMA nodes on my machine, and each NUMA node has 32GB of
memory.  I have configured 16GB of CMA memory on each NUMA node, and
starting a 32GB virtual machine with device passthrough is extremely slow,
taking almost an hour.

During the startup of the virtual machine, it will call
pin_user_pages_remote(..., FOLL_LONGTERM, ...) to allocate memory.  Long
term GUP cannot allocate memory from CMA area, so a maximum of 16 GB of
no-CMA memory on a NUMA node can be used as virtual machine memory.  There
is 16GB of free CMA memory on a NUMA node, which is sufficient to pass the
order-0 watermark check, causing the __compaction_suitable() function to
consistently return true.  However, if there aren't enough migratable
pages available, performing memory compaction is also meaningless. 
Besides checking whether the order-0 watermark is met,
__compaction_suitable() also needs to determine whether there are
sufficient migratable pages available for memory compaction.

For costly allocations, because __compaction_suitable() always returns
true, __alloc_pages_slowpath() can't exit at the appropriate place,
resulting in excessively long virtual machine startup times.

Call trace:
__alloc_pages_slowpath
    if (compact_result == COMPACT_SKIPPED ||
        compact_result == COMPACT_DEFERRED)
        goto nopage; // should exit __alloc_pages_slowpath() from here

When the 16G of non-CMA memory on a single node is exhausted, we will
fallback to allocating memory on other nodes.  In order to quickly
fallback to remote nodes, we should skip memory compaction when migratable
pages are insufficient.  After this fix, it only takes a few tens of
seconds to start a 32GB virtual machine with device passthrough
functionality.

Link: https://lkml.kernel.org/r/1736335854-548-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/compaction.c~mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages
+++ a/mm/compaction.c
@@ -2383,7 +2383,27 @@ static bool __compaction_suitable(struct
 				  int highest_zoneidx,
 				  unsigned long wmark_target)
 {
+	pg_data_t __maybe_unused *pgdat = zone->zone_pgdat;
+	unsigned long sum, nr_pinned;
 	unsigned long watermark;
+
+	sum = node_page_state(pgdat, NR_INACTIVE_FILE) +
+		node_page_state(pgdat, NR_INACTIVE_ANON) +
+		node_page_state(pgdat, NR_ACTIVE_FILE) +
+		node_page_state(pgdat, NR_ACTIVE_ANON) +
+		node_page_state(pgdat, NR_UNEVICTABLE);
+
+	nr_pinned = node_page_state(pgdat, NR_FOLL_PIN_ACQUIRED) -
+		node_page_state(pgdat, NR_FOLL_PIN_RELEASED);
+
+	/*
+	 * Gup-pinned pages are non-migratable. After subtracting these pages,
+	 * we need to check if the remaining pages are sufficient for memory
+	 * compaction.
+	 */
+	if ((sum - nr_pinned) < (1 << order))
+		return false;
+
 	/*
 	 * Watermarks for order-0 must be met for compaction to be able to
 	 * isolate free pages for migration targets. This means that the
_

Patches currently in -mm which might be from yangge1116@126.com are


