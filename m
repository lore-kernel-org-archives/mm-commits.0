Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B75132C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806609; cv=none; b=fqK6/D/cBRX6mrSlvYi5Q28DIuwqo9ZRpKFXBn/u6SuH699Uxlvs8vVthNj7UFZ9m668qeCPdXmVh4IGhwKXjgV93dNHm+6sI964gtyOy55AxE5F8rl1+xat90zh7UXCmhxQeajBVHwADd8+niLjL5KPC7FIsTrrUZKP0xFKqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806609; c=relaxed/simple;
	bh=ITgxa7n0YNgcNsdP5CP4tP+xgtHazhiEkxsUW9ER+6Q=;
	h=Date:To:From:Subject:Message-Id; b=j0FTM8V5Z5TEzxgyKN92vC0lixWLeviX8tA6f04PvKJht0IQTuRBVM8AHXAXnRWwkHb6SEPPOR0K5r0AaJaoKQXmZLe+30X3NnrA236F7tLkKClNa9ihorBCw/Mn9JeD6bcOqFSVlbWcAyqhIsX0LpBeF7OECK3rR3+17gwfrXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMtB1TsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMtB1TsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54B1C4CEE4;
	Wed, 21 May 2025 05:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806608;
	bh=ITgxa7n0YNgcNsdP5CP4tP+xgtHazhiEkxsUW9ER+6Q=;
	h=Date:To:From:Subject:From;
	b=HMtB1TsLKz5PyJwQkjQunZNFV2KZ3YCk5+yM2X88NwvWCbl5+aSYa6B/iDrwuJM3/
	 L+ii2031UwYi51f6Qm9rke2nQGgjQbs6ZtBfNf4M3DbSwh5HSP4xaSW9UCoWCQr28q
	 wEKbz2x1jRA6T8scw9kExrwEY6id8WmV5c192sh4=
Date: Tue, 20 May 2025 22:50:08 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-reclaim-section.patch removed from -mm tree
Message-Id: <20250521055008.C54B1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm reclaim section
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-reclaim-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm reclaim section
Date: Mon, 12 May 2025 15:31:22 +0100

In furtherance of ongoing efforts to ensure people are aware of who
de-facto maintains/has an interest in specific parts of mm, as well trying
to avoid get_maintainers.pl listing only Andrew and the mailing list for
mm files - establish a reclaim memory management section and add relevant
maintainers/reviewers.

This is a key part of memory management so sensibly deserves its own
section.

This encompasses both 'classical' reclaim and MGLRU and thus reflects this
in the reviewers from both, as well as those who have contributed
specifically on the memcg side of things.

Link: https://lkml.kernel.org/r/20250512143122.87740-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-reclaim-section
+++ a/MAINTAINERS
@@ -15581,6 +15581,19 @@ F:	mm/compaction.c
 F:	mm/page_alloc.c
 F:	mm/page_isolation.c
 
+MEMORY MANAGEMENT - RECLAIM
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Johannes Weiner <hannes@cmpxchg.org>
+R:	David Hildenbrand <david@redhat.com>
+R:	Michal Hocko <mhocko@kernel.org>
+R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/pt_reclaim.c
+F:	mm/vmscan.c
+
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

