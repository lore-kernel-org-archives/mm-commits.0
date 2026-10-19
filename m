Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792421679;
	b=I3A1NZgbcAezhkJc+8qyeb1N96LxF5kZ8MhXjkgePHZD1ouM8ceODCgxP2pCcf9yaaBB
	 bR9gl0+ZjQEiOksX0neB2xJr86CnhlrKbRY0Xvx6cAJLqq126i85VyIPK14BT+5J3l9HQ
	 VcS0j3GiOs837+z6V7+csHqbPJYL+s1tAhbblUZRGnyHtFjgFsY4vgmGsnW2V9tAg85td
	 frqUH846HjTQd72r4eZaon933jDq4eEbstrEKljYGk0qhyeTTFI9GtlkvMpTwXc33yxn1
	 QOC2w+AKJAO6XpIxU6Jme67uZwmvWA6m3X8zRA0Wbyq4lIa5olWBww3mCD+nGzyT9dQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421679;
	h=Received:Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hiZ+spqKOKcEuooyExBLkXKRa4fB5mZdNzxFooT/rfY=;
	b=cTBI0/D5MAIQq6QEQmQbcg0jJHalg1nth+yHE891oef+zwyQfKKAPx17dYuuYw4sLBH/
	 6p2fpJBG/AwWSir+rC5AyvpUdH9YEIsLi1iYGTqSuSDnFFBoUO8D4YFdphe9rCW5zK5jf
	 0quJCQyFJL7lB11gJpGr2JTUQVnl3qLpFB/kAcJzLQdUkjgsONKavg87bOaPkdQgVPYPb
	 QUipb2z4/pSITNlwHpWFBV6jD/y6APDUw94W+4UvTO92naoCLLM287rUy55fZBSPktia8
	 /uZL4m7KY5yMKZgctCaKmGln89i7KKim4Hmrp7YC9XMY4kO6trjbkkY2Cqke9/Obq1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SrK2DecL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88649606DA79
	for <mm-commits.vger.kernel.org@localhost.mlmmj>; Mon, 19 Oct 2026 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SrK2DecL
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7456513C1
	for <mm-commits@vger.kernel.org>; Mon, 19 Oct 2026 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421679; cv=none; b=oezYN06wokdPH15KV393N4NIm7gbzGyPQoNza8SbAzqbnMkzkJxKnHuh+UvxZ/4c7pXoCV2ZcPoVYx8dUvNZlQxTHQ7cOCc8PTWi+gcPrIz7sVfQxffqawj6zjveQQQXxSaQhqbq9rpvuJ0LyCh3SzAa6TL96yIkTHDTT2ye3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421679; c=relaxed/simple;
	bh=rMzGim4HPQyf07lu6YiaKjR6Uaq5JP7uTex0qda684E=;
	h=Date:To:From:Subject:Message-Id; b=Cv5lsHgpkyFtVa7MWkz66Kb2hLJ77RcNlaBju7yWrpa+gMtnEZqdK3EI7uxFZZ/0R/9m9bKvduI6GqaT6F83Tcuzxd5IUQ1n2bofZ/ShMWV3+i7XNGr1qnTbSRvplXqv3gve5P69wifkedwG9WfxdmQQ8tyuH9Lp0FsFO326FEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SrK2DecL; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A71F000C6;
	Mon, 19 Oct 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792421677;
	bh=hiZ+spqKOKcEuooyExBLkXKRa4fB5mZdNzxFooT/rfY=;
	h=Date:To:From:Subject;
	b=SrK2DecLhGTfTlpK73yQgQUfqRX9RcodljJ5Uo3w/1IfvDgnR61EmbKA35QQf43kJ
	 Gfzm4tHaQEZ0JaaRBWTsx7xRTYIaTDBfbr7mA5xUgkqx5SZAOeHPWT72oOu3pmAQZA
	 UlnflK7mNbm5elxKEkzE7jmA8LWk+SJ1OAzbGfzE=
Date: Mon, 19 Oct 2026 07:54:36 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,harry@kernel.org,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-an-entry-for-memory-management-memory-map.patch added to mm-unstable branch
Message-Id: <20261019145437.523A71F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY MAP
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-an-entry-for-memory-management-memory-map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-an-entry-for-memory-management-memory-map.patch

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

arch-mm-promote-debug_wx-to-check_wx.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch
maintainers-add-an-entry-for-memory-management-memory-map.patch

