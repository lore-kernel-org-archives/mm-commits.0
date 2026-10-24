Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832344;
	b=NZEzCTQ6g1MJ92l+zMA+SmH1OKx+Ff82SjzZtM64/EVDHtqIEp+KMlpGwUsUu0jJu7Wz
	 IQAbylOgIsmcDUBJ0odwSZfuaYZkykr6ZA8TaQFR8msL6ju9lHt8zbk6S4wXpwC2xN66h
	 ZWDOIT+LyLBPLXaRL0qE1ZGiIaN5xojUMWP1IpzPI/BIYVgdzuGfS+MyWwkUy6KBNOG6G
	 ofpkbfcLD/aWQdR/O+JhDuEigZtKEF31C1w3cssP98NfAYdclBt/yZgr2kUZ7XzBu7etr
	 ocPafRD++ubMiOh6Sx68FKS7wT+qoZar1NHZYYolh0YzvDQNHnu63xJ0gzb0KTd2veQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832344;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SfJX4i8zE4dRPE6/16u8IMhtlPxqKyQZUGoT/aVkaQw=;
	b=1GH1+cPt5vhQOPbIuljuis7vbya9+mo9z+UlsZ73wLYAc60piRel2k258KR2J9iFBRei
	 /6JhIqbDDJoO+cHNsNWCva9EllDpG8HVicVfmtgI1eO0ymlqqhCGXkr2JDTDpjkI8Py0Y
	 QVMStAZlYHZOb9ffy477Az1zPKWU/L7zAzHJ0asNClqtDPW93fdJV0TJGGNb3xDvFfeI7
	 zFVdBpEXTEqg4Qg3nmFLKU9KsYAzK46QOic04/Wgh5J+jwF49d17+f/gsOL1oWIxhXTQS
	 T8vfaCkohrtjR+e+coqyld9Fuwbu+PI+aJx5iKaJy0y+Di4CHeuUVi2gt/GOWFL+epQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F2X3RJBK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB80606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F2X3RJBK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806B51F01828;
	Sat, 24 Oct 2026 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832343;
	bh=SfJX4i8zE4dRPE6/16u8IMhtlPxqKyQZUGoT/aVkaQw=;
	h=Date:To:From:Subject;
	b=F2X3RJBK2kHSyb9mFoRBpxs1TFwk1wZ3+sseCeJ7pv9xi5cRzuawRYH5N25hDAXjo
	 PPFcrwNZ94Y2r/ZuMh1G02F6EFqauiw8NMRmu9RxSjXHGoeu044sWGZHQTJMnfBdqi
	 CFOh1NHgfsY5E5OwZ0e65eInUOeGWEr0jOwvRpk8=
Date: Sat, 24 Oct 2026 01:59:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hsj0512@snu.ac.kr,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch removed from -mm tree
Message-Id: <20261024085903.806B51F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: scripts/gdb: mm.py: remove fallbacks for SECTION_HAS_MEM_MAP and SECTION_IS_EARLY
has been removed from the -mm tree.  Its filename was
     scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: scripts/gdb: mm.py: remove fallbacks for SECTION_HAS_MEM_MAP and SECTION_IS_EARLY
Date: Mon, 21 Sep 2026 21:59:01 +0200

There is no reason to handle the absence of the corresponding BIT values. 
So let's remove the fallbacks.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-9-54d81d65e125@kernel.org
Link: https://lore.kernel.org/r/vpz5zqg5nwbpolxbkip45vxxdt3lni7j2haal7q42skc3b57tu@uh4cec4x32dq
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 scripts/gdb/linux/mm.py |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early
+++ a/scripts/gdb/linux/mm.py
@@ -71,12 +71,8 @@ class x86_page_ops():
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
 
-        try:
-            self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
-            self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
-        except:
-            self.SECTION_HAS_MEM_MAP = 1 << 0
-            self.SECTION_IS_EARLY = 1 << 3
+        self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
+        self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
 
         self.SUBSECTION_SHIFT = 21
         self.PAGES_PER_SUBSECTION = 1 << (self.SUBSECTION_SHIFT - self.PAGE_SHIFT)
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

