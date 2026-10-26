Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045727;
	b=LPgUqvT57P/byYXSfTn0WlNRItQfebGPcHQaLexNH2n6MM4ps7DWISbsX1W40d9SF7iv
	 ghOAUrOeX9ABdlSmD1MHjskoga25WopNuCFVF79qY8dMQg33nzBNnrw/gIsYY/V4ZrRbN
	 s+j2xs0uqDPqgRDmomwFoZ2UWiosk3KiUQ7nqE89HxBV0rTjkUgUAmG3JFEWZWjLDSv61
	 ODP3HhxPBe4A/PSYu59KLUbZOx9RRHBZJbuuvOUL2/oP1dNqxq54o+Rb92kTl1vaFI75a
	 uj5k1qLswILKneGjYXVi7nSml8QLcUViVpSiLnlCtw7BxY3Tll2yPreA9Zv4Q9hIoWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045727;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kg1FEEWYbGq7lJBC1/J4dnRb81NaIwEkbUwrQ5UXHxo=;
	b=DMQ1qtRJIYu4dJkHa+U4KMMeFkax38jwVndluYRxotD+mnz9SQzq0E1wJ5BSLH77ns5B
	 wtZK48B362U0JfG3AYX8TupOzIT/JR9JQPv1rinwpNZe3GK2A8Q2bKxZDkGFuSn9jCMXG
	 G7GOPlwNDn3OlhvmgAF280AC/39nUZF27RqeVg+pAVo7b8t8VeE1610Y2X/YXiQjiPk2o
	 qkOeyqPDtULMQBYDUaH0d5l8mM1TWmmQrlQUktTuHjkEP2xLuxDBweColEZEiZOptLWjP
	 BNJxDcKuGd3uZtTjmxiRY0PjWAxMxJLx0PV4nwlvLuZLVFzQpcbcU6z/prXyIhp6FSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hRIo4sys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C32606A31D;
	Mon, 26 Oct 2026 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hRIo4sys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8E11F01825;
	Mon, 26 Oct 2026 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793045726;
	bh=kg1FEEWYbGq7lJBC1/J4dnRb81NaIwEkbUwrQ5UXHxo=;
	h=Date:To:From:Subject;
	b=hRIo4sys0jPnFdg4rN/f6DzsmY7/+ROHmKZ+inFao8sbtomcAik3jnQI7qgVqzVBa
	 LJ3wr4XxF5M2N9l8sS2E/8Du5CYmCA5yZn+MqXrLo88QtUhiEnvtP8Mn7RK5FBKbfi
	 Gr5vwSt7JIfYTJLe+m7FHAPYAxJiwzEdUEVraWgo=
Date: Mon, 26 Oct 2026 13:15:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vincenzo.frascino@arm.com,stable@vger.kernel.org,sashiko-bot@kernel.org,
	odys.yuan@gmail.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,
	gourry@gourry.net,david@kernel.org,catalin.marinas@arm.com,byungchul@sk.com,
	apopple@nvidia.com,andreyknvl@gmail.com,dennylin0707@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-untag-addresses-when-querying-page-nodes.patch added to mm-unstable branch
Message-Id: <20261026201526.7B8E11F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: untag addresses when querying page nodes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-untag-addresses-when-querying-page-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-untag-addresses-when-querying-page-nodes.patch

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
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: mm/migrate: untag addresses when querying page nodes
Date: Mon, 26 Oct 2026 19:53:29 +0000

When move_pages() is used with nodes == NULL, do_pages_stat_array() passes
each page address directly to vma_lookup().  A valid tagged address
therefore fails the VMA lookup and gets -EFAULT in its status entry,
instead of the node reported for the corresponding untagged address.

The tagged address ABI permits these pointers, and the migration path
already removes their tags.  Apply the target mm's untagging rules to the
query path as well, while holding its mmap read lock.

Link: https://lore.kernel.org/20261026195330.46757-1-dennylin0707@gmail.com
Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <odys.yuan@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-untag-addresses-when-querying-page-nodes
+++ a/mm/migrate.c
@@ -2461,7 +2461,7 @@ static void do_pages_stat_array(struct m
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch
mm-migrate-untag-addresses-when-querying-page-nodes.patch

