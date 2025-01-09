Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA8113E02D
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 04:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736396925; cv=none; b=fPtNaEp+ny0ZLvTVFPRV936o5kuLaRlfXYjMPnTnIfHpb3tHVwwbsJuHLBX9t8hP1AYQ3cjHfD6N+jRmLRG1RIHDnMZSa41qzRBe8Ukme4/JNMrtd4jL/6b/k1Mhuh02owI+LsP4Uuf95ttXDXiCCHMv1biaJPh3LKUkVz5IOKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736396925; c=relaxed/simple;
	bh=UWbEQyCDiy8rGE6Fgnog/c1yH06E6X765Gb3W27qAXk=;
	h=Date:To:From:Subject:Message-Id; b=G5fkYTN8G/2zTupx81Ymy4fZ8uHtkpVhywXdBIJre0WRMCenh8xxT88ruvF9OF8KgyOmzo6TT6uQoxNT4onnyPLRr+uDvAnl6NB9WbCsv46YyDO3hoduBxMjCT0Yiehlp4tOFoU+l/N8DM3c3uN4TRQ2O11SpiM9XMrK0PHU4HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Us4aJjpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Us4aJjpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA579C4CED2;
	Thu,  9 Jan 2025 04:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736396924;
	bh=UWbEQyCDiy8rGE6Fgnog/c1yH06E6X765Gb3W27qAXk=;
	h=Date:To:From:Subject:From;
	b=Us4aJjpX7dsTFsq7M+f6ki4CLLf/fEHJI3aWH4a0sr0t1Ar6MzYze7gCbTquyxkC3
	 u0mp87soN4804ubuh+0yXlTkgLh5FJR9KtDtuzIRfmaVraigcoVZHTABzmAVE7Ayhy
	 cJ7NiyirsPyLArsUN5lhBs2N2sksSM68rm5IOJ5k=
Date: Wed, 08 Jan 2025 20:28:44 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch added to mm-unstable branch
Message-Id: <20250109042844.AA579C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: skip memory compaction when there are not enough migratable pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

This patch will later appear in the mm-unstable branch at
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

replace-free-hugepage-folios-after-migration.patch
mm-compaction-skip-memory-compaction-when-there-are-not-enough-migratable-pages.patch

