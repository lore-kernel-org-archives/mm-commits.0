Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EA8158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945868; cv=none; b=jadTCbBGncmhup74IYgseCd6IcDA3cFPW0SERgEfIPrqvvi/qbDhFX4eIc+fwz2P/rIrUM0ftCVdvmN7ryo1Af+6pOECfX0Ywm/yOD8w4/Ke/QgQR1/8fF2f+sMzNMz58dXx8qX7B/nDW0CyQBJXpzUOKunlFxG8FQOUjDNMD9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945868; c=relaxed/simple;
	bh=CqAgNK8BRDY1R0qTNJeYNPxJxVtsiiOpMAk1s7jDU+8=;
	h=Date:To:From:Subject:Message-Id; b=IUwcydlR+ZeL2sPRhevkH1R1HSEDHo1EaQQmCadCGhu+blnBMn+dd233Id93TD3YRQwaYAb0GmuXCuw4Ye0jIa7TyPgWhEp0svk1eQB0CMVRiBUsmPaks4Y93Rud6LqgZRF9F8AzPfBJienWR5IRs7/djVybAdqFE8CbIIoGdcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lW60ylK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lW60ylK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7C1C4CEE4;
	Fri, 18 Apr 2025 03:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945868;
	bh=CqAgNK8BRDY1R0qTNJeYNPxJxVtsiiOpMAk1s7jDU+8=;
	h=Date:To:From:Subject:From;
	b=lW60ylK1K86/CpbsqHVRi9XTnP5RbfSP7oQlP2zvhukNKeKjhXSgnYyj+XPjHmvvs
	 XcUTliqkKeJ5OdRRU70bPmSOvUiukXMYMjmdAR6PyBUpNPAcgfki59Q2w12b6fiwpS
	 K2ejDgX8hyQaKgBgqNqHylVQgUSLaFJ/7dwTFGWM=
Date: Thu, 17 Apr 2025 20:11:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhocko@suse.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,harry.yoo@oracle.com,hannes@cmpxchg.org,cl@linux.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-subsection-for-the-page-allocator.patch removed from -mm tree
Message-Id: <20250418031107.DF7C1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add MM subsection for the page allocator
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-subsection-for-the-page-allocator.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: add MM subsection for the page allocator
Date: Thu, 10 Apr 2025 11:00:23 +0200

Add a subsection for the page allocator, including compaction as it's
crucial for high-order allocations and works together with the
anti-fragmentation features.  Add reviewers (including myself) who
voluteered.

Link: https://lkml.kernel.org/r/20250410090021.72296-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Christoph Lameter (Ampere) <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-subsection-for-the-page-allocator
+++ a/MAINTAINERS
@@ -15516,6 +15516,21 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - PAGE ALLOCATOR
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+R:	Brendan Jackman <jackmanb@google.com>
+R:	Johannes Weiner <hannes@cmpxchg.org>
+R:	Zi Yan <ziy@nvidia.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/compaction.c
+F:	mm/page_alloc.c
+F:	include/linux/gfp.h
+F:	include/linux/compaction.h
+
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from vbabka@suse.cz are

memcg-combine-slab-obj-stock-charging-and-accounting.patch

