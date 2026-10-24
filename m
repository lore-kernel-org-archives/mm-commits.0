Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832533;
	b=0mH6Dc6l2Xyy2wnBp21y6gaIV/ZWZuOQ8AN+wQ/TURiA63eLcEpTjBHZovmHPcTlkhlt
	 KOMMNCbuLaQFItqCxLXH5LYopJL1soq68WZ39tg1Rdqa2ehTqjW0mMK3zWBiEEgULSfjv
	 Eq2bOyq9evvvBXDhrztYqOL1H2xgbDRNxIIm6oI4YkbNf3/zGvLvc2Jj/1ZUWCDkms80m
	 AU2f14Akhi3E8+Owu/ReV2MnYwpZTm6Qu/Q6osLfRnK5BHR5VjW7N+ZbNxPi4Lt5HjbfO
	 mGkWCsPJqQwXTmuqHRnRXvcvabqffJ+yWP5DMhrfuVg1QZ8eVymAoMRtbCM7EwQl2Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832533;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mO6mJY/qAixbrVuWJzACZTGyMp2wQ1ioCA0uX9BIYCg=;
	b=5A7s3WV7WQ/lB+mTuvh/kNbd6idJwKbgLEoYklLkvS4TXkSyaD0kH5RjSINxjY/pZRdB
	 uw/F2A5KbvRhKS2dsIP7N+A3INoSJa0BPCAMmQQp3Ww5np9PHvpZXI6o4ra3VNZFeUpdi
	 GCGmKpzSJQb0j8tzrIDbAv14dCH+rxXrWGjnPAbWfJeU11cTkg1Dgc8T0yCeCkmG3EiJj
	 vcGGsHKqaLzefZm6vUlZ/PMdCB1zHPOpB4AOwFYqEz5l5Hy44FJ3t3H6fQ3UYuUFrqRc9
	 qnUXQ3SKFZ9SYRmUkG/lUu1jEtOvDXH2poiIZ9n3V/X2J1vk0FWcYGXWMVKaJpGLSPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AJTN0Q8K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF72606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AJTN0Q8K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A891F01825;
	Sat, 24 Oct 2026 09:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832532;
	bh=mO6mJY/qAixbrVuWJzACZTGyMp2wQ1ioCA0uX9BIYCg=;
	h=Date:To:From:Subject;
	b=AJTN0Q8K4hbe97oAZbkIAmDs7QikjtbWu0juh0bYueoRnrkAN22tZ6Yw4U+D3sFDw
	 DNPnTs5Q+97qbpZHd0Q4gik1XGtudSFuT9H7Vy8DDj7FhjBiBtXeA7iVqgnvo60iwv
	 2RJstG0QiAsYVzMkmeBzh7Iup4S4vnrth+YuQgOk=
Date: Sat, 24 Oct 2026 02:02:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,muchun.song@linux.dev,harry@kernel.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-an-entry-for-memory-management-memory-map.patch removed from -mm tree
Message-Id: <20261024090212.89A891F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY MAP
has been removed from the -mm tree.  Its filename was
     maintainers-add-an-entry-for-memory-management-memory-map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY MAP
Date: Mon, 19 Oct 2026 14:34:26 +0300

Split out files related to SPARSE and SPARSE_VMEMMAP management from
MEMORY MANAGEMENT - CORE into a dedicated entry.

Also include architecture specific sparsemem.h headers, pfn_to_page() and
page_to_pfn() conversions and Documentation/mm/memory-model.rst.

Muchun, who did a lot of work cleaning up SPARSE_VMEMMAP and extending
vmemmap optimization, volunteered to help with the maintenance.

David and I will continue to look after that part of the mm subsystem.

Link: https://lore.kernel.org/20261019-memmap-maint-v1-1-80850871d0cc@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
---

 MAINTAINERS |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-add-an-entry-for-memory-management-memory-map
+++ a/MAINTAINERS
@@ -17162,9 +17162,6 @@ F:	mm/mmzone.c
 F:	mm/pagewalk.c
 F:	mm/pgtable-generic.c
 F:	mm/ptdump.c
-F:	mm/sparse-vmemmap.c
-F:	mm/sparse.c
-F:	mm/sparse.h
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
@@ -17212,6 +17209,21 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
+MEMORY MANAGEMENT - MEMORY MAP
+M:	Muchun Song <muchun.song@linux.dev>
+M:	Mike Rapoport <rppt@kernel.org>
+M:	David Hildenbrand <david@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git memmap
+F:	Documentation/mm/memory-model.rst
+F:	arch/*/include/asm/sparsemem.h
+F:	include/asm-generic/memory_model.h
+F:	mm/sparse-vmemmap.c
+F:	mm/sparse.c
+F:	mm/sparse.h
+K:	(?i:vmemmap)
+
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Kairui Song <kasong@tencent.com>
_

Patches currently in -mm which might be from rppt@kernel.org are


