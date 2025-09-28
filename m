Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E051534BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085536; cv=none; b=fSy4EMH9ZmIPlFf0q240A/GtjY2CoaS0+c2e6IRWNZlqt9M4v5odPbLhmE/npiJEeNZbx8o32u7qPm78p4rNNE+ZzVozMboJvahbcJe4hXVxUqGI+qVG8t/JC9J4TgGLEfi6/Oxag4Fi5rjEVBb/JUEW/P3htIrGQTXUf+Ri+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085536; c=relaxed/simple;
	bh=HPNlaE//tNT+am+TX4YQ5HRZwT4OBtwKFbn7OTpgRW0=;
	h=Date:To:From:Subject:Message-Id; b=u/frzhPllPQvx1OsR+F/ejWbLzXr2in1dskbWBF9w6LgQPTg8sBrffdNpE2PbuF3kCHAakv4xNmP7uTH+1aTAo7AdF1vleMXGAibBwfFaLSZ+gOPNCdhaJvwyDFYocXCfMMFIvHnl2mpVSRvCWLoFP1dnJtGJuVv1ck3pjJpwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWksREzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWksREzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2BAC4CEF0;
	Sun, 28 Sep 2025 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085535;
	bh=HPNlaE//tNT+am+TX4YQ5HRZwT4OBtwKFbn7OTpgRW0=;
	h=Date:To:From:Subject:From;
	b=uWksREzAEvJiRJCDqYvmsXzDGzpJoxin2fhD4feGMXyt6h9dofuJpMRWZDP0jXfBB
	 SDE/mhnAad02fjxOrIiPy86Ir78zabrtHTiPkKlbs/6nGZBsF6mrC+naIDzPMVA3a1
	 L+Xs5Degzch2j1Z69XCuoet0MI1LApxLwc6Etf+Q=
Date: Sun, 28 Sep 2025 11:52:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-improve-mlock-tracking-for-large-folios.patch removed from -mm tree
Message-Id: <20250928185215.AE2BAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: improve mlock tracking for large folios
has been removed from the -mm tree.  Its filename was
     mm-rmap-improve-mlock-tracking-for-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: improve mlock tracking for large folios
Date: Tue, 23 Sep 2025 12:07:11 +0100

The kernel currently does not mlock large folios when adding them to rmap,
stating that it is difficult to confirm that the folio is fully mapped and
safe to mlock it.

This leads to a significant undercount of Mlocked in /proc/meminfo,
causing problems in production where the stat was used to estimate system
utilization and determine if load shedding is required.

However, nowadays the caller passes a number of pages of the folio that
are getting mapped, making it easy to check if the entire folio is mapped
to the VMA.

mlock the folio on rmap if it is fully mapped to the VMA.

Mlocked in /proc/meminfo can still undercount, but the value is closer the
truth and is useful for userspace.

Link: https://lkml.kernel.org/r/20250923110711.690639-7-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/rmap.c~mm-rmap-improve-mlock-tracking-for-large-folios
+++ a/mm/rmap.c
@@ -1463,12 +1463,12 @@ static __always_inline void __folio_add_
 	}
 
 	/*
-	 * For large folio, only mlock it if it's fully mapped to VMA. It's
-	 * not easy to check whether the large folio is fully mapped to VMA
-	 * here. Only mlock normal 4K folio and leave page reclaim to handle
-	 * large folio.
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
 	 */
-	if (!folio_test_large(folio))
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
@@ -1601,8 +1601,13 @@ static __always_inline void __folio_add_
 
 	__folio_add_rmap(folio, page, nr_pages, vma, level);
 
-	/* See comments in folio_add_anon_rmap_*() */
-	if (!folio_test_large(folio))
+	/*
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
+	 */
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
_

Patches currently in -mm which might be from kas@kernel.org are


