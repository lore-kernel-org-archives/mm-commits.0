Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A034F896
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707780525; cv=none; b=HmIJ1/wKGCwdL1zujQ1r+Ay9c8W8W5n9tT4wjsnmrkPSFA3Sg0KCHUba8QkAk8zi1+f3Opf3pmh82EVgXz7M9ohC2Y7Cf1RTAWIxixHN15YrV0ikQixRbeIhpMD8gfe5qXoRwffWqdNzIjuW+/HT6dNFdT+exe493FfXjJBYysA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707780525; c=relaxed/simple;
	bh=cgylFqXVbJKUeDMdx5sOR5LAyTo8TbFcvteRrvkaDTQ=;
	h=Date:To:From:Subject:Message-Id; b=u1K+ishzmra2odLuUpBZUzJe4utr1YBwBgCsC4f23/+tTz3cT6wmw5NyLH5PZJAjAsQKES0W9TTwVvgVt0Tvd+kAgFYe4WOIrtu1Yb/XiTcrwvL9rwV5Z2WbmXYfr4Iz3UYJ1G8B76NSRWGbg7RIq67PtHgEdlOnq8yqevarFyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xdg3WIBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xdg3WIBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC61C433F1;
	Mon, 12 Feb 2024 23:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707780525;
	bh=cgylFqXVbJKUeDMdx5sOR5LAyTo8TbFcvteRrvkaDTQ=;
	h=Date:To:From:Subject:From;
	b=xdg3WIBCFE1E2d3Rj6WQ0oRuiBZ9ZEhkBbuvrZodDwjHKIAJjVpfSFXdlfOZ9LyYp
	 n0l6vgZ5QN64NDppgzoyxCJ/IUzg2WRRFIJSf1OP5njCHfWgUnwzxzWw00l2fM+pG3
	 L9/9ltJcdvVKgjj4niK/o5nmxs9yJkx8lN3x1Rhw=
Date: Mon, 12 Feb 2024 15:28:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-update-documentation-regarding-page_owner_stacks.patch added to mm-unstable branch
Message-Id: <20240212232845.6CC61C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: update Documentation regarding page_owner_stacks
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: update Documentation regarding page_owner_stacks
Date: Mon, 12 Feb 2024 23:30:29 +0100

Update page_owner documentation including the new page_owner_stacks
feature to show how it can be used.

Link: https://lkml.kernel.org/r/20240212223029.30769-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/page_owner.rst |   44 ++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/Documentation/mm/page_owner.rst~mmpage_owner-update-documentation-regarding-page_owner_stacks
+++ a/Documentation/mm/page_owner.rst
@@ -24,6 +24,11 @@ fragmentation statistics can be obtained
 each page. It is already implemented and activated if page owner is
 enabled. Other usages are more than welcome.
 
+It can also be used to show all the stacks and their outstanding
+allocations, which gives us a quick overview of where the memory is going
+without the need to screen through all the pages and match the allocation
+and free operation.
+
 page owner is disabled by default. So, if you'd like to use it, you need
 to add "page_owner=on" to your boot cmdline. If the kernel is built
 with page owner and page owner is disabled in runtime due to not enabling
@@ -68,6 +73,45 @@ Usage
 
 4) Analyze information from page owner::
 
+	cat /sys/kernel/debug/page_owner_stacks/show_stacks > stacks.txt
+	cat stacks.txt
+	 prep_new_page+0xa9/0x120
+	 get_page_from_freelist+0x7e6/0x2140
+	 __alloc_pages+0x18a/0x370
+	 new_slab+0xc8/0x580
+	 ___slab_alloc+0x1f2/0xaf0
+	 __slab_alloc.isra.86+0x22/0x40
+	 kmem_cache_alloc+0x31b/0x350
+	 __khugepaged_enter+0x39/0x100
+	 dup_mmap+0x1c7/0x5ce
+	 copy_process+0x1afe/0x1c90
+	 kernel_clone+0x9a/0x3c0
+	 __do_sys_clone+0x66/0x90
+	 do_syscall_64+0x7f/0x160
+	 entry_SYSCALL_64_after_hwframe+0x6c/0x74
+	stack_count: 234
+	...
+	...
+	echo 7000 > /sys/kernel/debug/page_owner_stacks/set_threshold > stacks_7000.txt
+	cat stacks_7000.txt
+	 prep_new_page+0xa9/0x120
+	 get_page_from_freelist+0x7e6/0x2140
+	 __alloc_pages+0x18a/0x370
+	 alloc_pages_mpol+0xdf/0x1e0
+	 folio_alloc+0x14/0x50
+	 filemap_alloc_folio+0xb0/0x100
+	 page_cache_ra_unbounded+0x97/0x180
+	 filemap_fault+0x4b4/0x1200
+	 __do_fault+0x2d/0x110
+	 do_pte_missing+0x4b0/0xa30
+	 __handle_mm_fault+0x7fa/0xb70
+	 handle_mm_fault+0x125/0x300
+	 do_user_addr_fault+0x3c9/0x840
+	 exc_page_fault+0x68/0x150
+	 asm_exc_page_fault+0x22/0x30
+	stack_count: 8248
+	...
+
 	cat /sys/kernel/debug/page_owner > page_owner_full.txt
 	./page_owner_sort page_owner_full.txt sorted_page_owner.txt
 
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

