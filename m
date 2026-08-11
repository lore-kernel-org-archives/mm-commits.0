Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA7379EC8
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472175; cv=none; b=ZWrPp60EsVPDiPuoXBN/2r6oFV5OtYWVEeTZkopstO/PU4Be90lr85MHfsNmUQr+DJgwmiwnowX9PTR+2Ir6QlYBF19PAughwUa7ygUIggtBcD+eR9Eq69HMOFh1iZGj7KFyAIZ0rmxs/MTP95+Am5xc/QhQep/QYnuICR0x7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472175; c=relaxed/simple;
	bh=dr79clty43/wja7yN5XIpA4wtTuzajQrejIoJd88Er8=;
	h=Date:To:From:Subject:Message-Id; b=Vw8n2VSK7jEw2oye/mJuTFvvq8ZMV90o9YcjHGKEbHwrDLz3IqcI5LfG2lLkzAQRa0G78kDYF524+lBnM0ylYhEzmeBMEE8B39IEUdQH+kYmXxsC/xfex2P5Fn83GZkcGHVlmbOl3jFFn0TQdKjDiRk67YsaYw/BZKl0Yoh4C0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=14JNt8Hk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="14JNt8Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C111F000E9;
	Tue, 11 Aug 2026 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472174;
	bh=6YgIGKnw7idbG4TnH5BH74TLXJ8E5katlb5XgrY7uvQ=;
	h=Date:To:From:Subject;
	b=14JNt8HkrZLBdE5DBeY2KHChrLfU9OSTelI1r/k0la7s6Q3wQSe/KvRufYi636+jq
	 9kAhEnMhWRocvU6eBq4He2H0Ga2C9ffL+O4bqtNo9vhtoEpa/4T7ynQEhhgGrfeGaZ
	 gZXK6u4VdUqRf1dOME2QZ0XMwYNOYR+U+mNPSAlw=
Date: Tue, 11 Aug 2026 11:16:13 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-documentation-clarify-where-the-mthp-stats-live.patch removed from -mm tree
Message-Id: <20260811181614.11C111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Documentation: clarify where the mTHP stats live
has been removed from the -mm tree.  Its filename was
     mm-documentation-clarify-where-the-mthp-stats-live.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm: Documentation: clarify where the mTHP stats live
Date: Tue, 04 Aug 2026 13:25:05 -0600

The note about khugepaged counters references /proc/vmstat for the PMD
case, but never mentions where the mTHPs stats can be found (i.e.:
/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/) Add a small
addition to this section for clarity.

Also fix a missing period while we are at it.

Link: https://lore.kernel.org/20260804-khugepaged_pte_refactor-v3-7-0364cad642a0@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
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


