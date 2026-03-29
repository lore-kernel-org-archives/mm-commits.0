Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022B513AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744938; cv=none; b=hBs565H0v5wICzu3z0I0SzVGZSqtv9v5IgkHII8Z0QxEA0o3cUM5U0ur6JUeu4oXNhAnulSAAtckwEu50oeTz+qTY17xiYa0/s0IvdvdexZX94YTKin3taxy3+8LYlIy5YfOsna+EVmJotyYXGajmYnjn3EBKZumgoKxB2XklPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744938; c=relaxed/simple;
	bh=rTeTHQUus4Eta9VRasXTOqBqUh5nUX6IVF1ik6pP03k=;
	h=Date:To:From:Subject:Message-Id; b=LUopvjd1xhvtpWh021olEdO/B3W6Tnp8QkaKuj3PHnFGxntc0tNruglU8DAk6Ex7QdL6TxjNQQvRjEnzJIObDLwdUFGJq/vsr8LcAnt03xnGrtyeawQ5yrvQNXN2bcAXmlxwqKD3s9MtEksi25EmD2KfBMBLGDCsgEiUm6tR9mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g8NHgKnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g8NHgKnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE04BC4CEF7;
	Sun, 29 Mar 2026 00:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744937;
	bh=rTeTHQUus4Eta9VRasXTOqBqUh5nUX6IVF1ik6pP03k=;
	h=Date:To:From:Subject:From;
	b=g8NHgKnjBskaGs3XSmGW/EgJEADjnG+4Y9KQVawgNG5byhXdqiOZzN46GNJGn4qZI
	 NI1jFQxMIZdUSjkcjDuitelnmkp4zVp5hoV+FBLDCZm4CIyu6gO3hIqi40ktr5RWD4
	 mlr1OToJT8jyj4zY+gDjtxPT/uX+46RPWSvJg0sA=
Date: Sat, 28 Mar 2026 17:42:17 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-drop-set_section_nid-from-sparse_add_section.patch removed from -mm tree
Message-Id: <20260329004217.CE04BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: drop set_section_nid() from sparse_add_section()
has been removed from the -mm tree.  Its filename was
     mm-sparse-drop-set_section_nid-from-sparse_add_section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: drop set_section_nid() from sparse_add_section()
Date: Fri, 20 Mar 2026 23:13:44 +0100

CONFIG_MEMORY_HOTPLUG is CONFIG_SPARSEMEM_VMEMMAP-only.  And
CONFIG_SPARSEMEM_VMEMMAP implies that NODE_NOT_IN_PAGE_FLAGS cannot be
set: see include/linux/page-flags-layout.h

	...
	#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
	#error "Vmemmap: No space for nodes field in page flags"
	...

Which implies that the node is always stored in page flags and
NODE_NOT_IN_PAGE_FLAGS cannot be set.  Therefore, set_section_nid() is a
NOP on CONFIG_SPARSEMEM_VMEMMAP.

So let's remove the set_section_nid() call to prepare for moving
CONFIG_MEMORY_HOTPLUG to mm/sparse-vmemmap.c

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-12-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-drop-set_section_nid-from-sparse_add_section
+++ a/mm/sparse.c
@@ -765,7 +765,6 @@ int __meminit sparse_add_section(int nid
 	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
-	set_section_nid(section_nr, nid);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
_

Patches currently in -mm which might be from david@kernel.org are


