Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F5376475
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622941; cv=none; b=BvE6aYYkMvSfuOxEDsjq+uErhgZbnlwDeoPycyeISwu5Nq0PUmcfNxdtpqIp1CzPdswUg3qFImbLG4fEBJYe6VL0gdRJT55wrfdiT7v3GcqkS7raIGfRqHZzTth25l/flZ7Iio3FFqhNwR6Gw0HR/1AIswieSxOXgp5MylKnOxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622941; c=relaxed/simple;
	bh=s62k1jL6whcK5IQJ1QNsNyQpZdLH8sVOVvZCWzK2l1A=;
	h=Date:To:From:Subject:Message-Id; b=GFwGSFA2mZlfL4wieo8lQZ0qj+q1Ina08PN1MbBjMSlnLi5OJ5KAeeVzDzl31A+VBYMBTubcH+fTLqt7h8GnLcfD2wE4XKNomUQKaAjk5u+u1NsZBAVgjCjcLBrTJux6OZd2+cxsCTJNSoas6xnv1UrnZsiEotyFZDfW9VyrLek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eo4N4vts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eo4N4vts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654581F000E9;
	Tue, 25 Aug 2026 01:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622940;
	bh=Dtwf8pdLLMlga/0q8JEaoJe6ELGd20t5eEUDN8Gq9YM=;
	h=Date:To:From:Subject;
	b=eo4N4vtsL+z15YrgeICx2Il6sN/hrh8dB6kR8BQQ8utCu0aVAf/+XDALmJym5GpfA
	 MNXLD9I2QNr4tUBftvp+f9E4c9NsWcR0apu9miNuxP1LItgyjgA+zOd9d3K7pAgOSu
	 m95rRpKcNn1ERtmesuh7TEA9YafpO89jYdyd4xgo=
Date: Mon, 24 Aug 2026 18:55:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-documentation-clarify-where-the-mthp-stats-live.patch removed from -mm tree
Message-Id: <20260825015540.654581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Documentation: clarify where the mTHP stats live
has been removed from the -mm tree.  Its filename was
     mm-documentation-clarify-where-the-mthp-stats-live.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm: Documentation: clarify where the mTHP stats live
Date: Tue, 11 Aug 2026 06:48:39 -0600

The note about khugepaged counters references /proc/vmstat for the PMD
case, but never mentions where the mTHPs stats can be found (i.e.:
/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/) Add a small
addition to this section for clarity.

Also fix a missing period while we are at it.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Pedro Falcato <pfalcato@suse.de> 
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-documentation-clarify-where-the-mthp-stats-live
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -224,7 +224,7 @@ khugepaged will be automatically started
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
 all THP sizes are disabled (when both the per-size anon control and the
-top-level control are "never")
+top-level control are "never").
 
 process THP controls
 --------------------
@@ -301,7 +301,9 @@ being replaced by a PMD mapping, or (2)
 hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
 or together, depending on the type of memory and the failures that occur.
 As such, this value should be interpreted roughly as a sign of progress,
-and counters in /proc/vmstat consulted for more accurate accounting)::
+and counters in /proc/vmstat consulted for more accurate accounting.
+Per-order mTHP collapse statistics are also available under
+/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 
_

Patches currently in -mm which might be from nico.pache@linux.dev are


