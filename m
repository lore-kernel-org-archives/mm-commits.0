Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2420FAA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188558; cv=none; b=axr+FRU4P0claNJWj6xGgiY44NhMBdqPFXjj14t+yqjxPlMaJWOjpKOMfBi3ZbfjyNazhFvt9tRlggxi7CpzpNS17czC06pGUXKvnJn3noPzDNb5yj28pprXChStzYl/CU/0R4peveqOYGf9AqDtzma47Zp8HAeWhcM3gynvjYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188558; c=relaxed/simple;
	bh=IV4EIjE6nZThRz98KjqI/PjKNlsTitHIdiIptIRLAV0=;
	h=Date:To:From:Subject:Message-Id; b=fImXYSMSpN/EO+xUNf0To/jNzYZauanGxCL/7eFcuiL5SFdwuS1gIbgtXcXooOsyOknhcHkEADnb5vakQap21pVRyy+1BWQ55VTi1M376nviwQsgbuiJuRBdSm7QID5nbjtmnsHrKMho203PVA5Y5z9niZ2uRQkU5LbuA/YmZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FKuCAq6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FKuCAq6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC640C4CEEC;
	Mon, 17 Mar 2025 05:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188558;
	bh=IV4EIjE6nZThRz98KjqI/PjKNlsTitHIdiIptIRLAV0=;
	h=Date:To:From:Subject:From;
	b=FKuCAq6RHEBljKdTN5rp25NRcHXhuSG9ODsa97VGdLBaQlRBOHR/8BAv0cZLSU4Xn
	 Au+UOHpPCcS2n66D0lbqsm7joNHbjRPtGXytu5MZaNkOBBOBfnrnDuTARBuXKjgwKg
	 0qCzY6MyCGrmjPqSx3IvcDOPLvHwoPeiOagAOUuw=
Date: Sun, 16 Mar 2025 22:15:57 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-fadvise-comments.patch removed from -mm tree
Message-Id: <20250317051557.EC640C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: remove 'fadvise()' comments
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-fadvise-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: remove 'fadvise()' comments
Date: Fri, 7 Feb 2025 17:44:18 +0800

Similar to commit 255ff62d1586 ("docs: tmpfs: drop 'fadvise()' from the
documentation"), fadvise() has no HUGEPAGE advise currently.  Remove the
confusing fadvise() comments.

Link: https://lkml.kernel.org/r/fae702b9775f58b55b45be5eaad22d8586d0290a.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-fadvise-comments
+++ a/mm/shmem.c
@@ -525,9 +525,9 @@ static bool shmem_confirm_swap(struct ad
  *	enables huge pages for the mount;
  * SHMEM_HUGE_WITHIN_SIZE:
  *	only allocate huge pages if the page will be fully within i_size,
- *	also respect fadvise()/madvise() hints;
+ *	also respect madvise() hints;
  * SHMEM_HUGE_ADVISE:
- *	only allocate huge pages if requested with fadvise()/madvise();
+ *	only allocate huge pages if requested with madvise();
  */
 
 #define SHMEM_HUGE_NEVER	0
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


