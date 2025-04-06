Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5F2914
	for <mm-commits@vger.kernel.org>; Sun,  6 Apr 2025 23:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743983181; cv=none; b=eoMuuez2tSuRTC8yFsKbgIB9/F1gUayYzqEZjSln0EThqJuWx7e67q2eThTyjTNe6v5K2hKl5YJ56q9x9xi6Blv0CWVYRlpoIs2+a5eFOwuMjpqnPBL/fPm8iZpdb8o1OLH2ZRTbDleqNI80wtrRM0JGbyblDKv5upiErRVlo10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743983181; c=relaxed/simple;
	bh=jim3WBqxKzh/oCykYQ+glkzdszw9l6tLcMCvSCH+pNk=;
	h=Date:To:From:Subject:Message-Id; b=YA2UICE/VO9xvN17+L1LCGsfO6FGuJRr599b+rKtzZ2DcOSmrP2CYuUBrRqwMGH1ZmpeRN+zpTGxIho3o+c3+sZ9taQYVtHcP9iMS54xA5MiCYIYQquI5sy30hYGzwJwuRjfhf/ogRORirF9dt3V+wJFJCF2Flz52VA3y999Vkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ILkEQfXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ILkEQfXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E3FC4CEE3;
	Sun,  6 Apr 2025 23:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743983180;
	bh=jim3WBqxKzh/oCykYQ+glkzdszw9l6tLcMCvSCH+pNk=;
	h=Date:To:From:Subject:From;
	b=ILkEQfXrQaEHIgT2jzlFJLm7VURxc9T0O3neX1m4dXiqjxwCegSiTLPUnDdm+ilu6
	 Mv2oi42u9oTgAmaOQ4YCxkBLxClk4eHqJrqCtXTmR8VXXeG5D9dhwjgWiv62d6cSlV
	 VIb+Rz8mCDwvYfTg5BaiOwazK+rdWxcfZyxd6KsU=
Date: Sun, 06 Apr 2025 16:46:19 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch added to mm-new branch
Message-Id: <20250406234620.53E3FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: simplify MEMCG_VMALLOC updates - fix
has been added to the -mm mm-new branch.  Its filename is
     memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch

This patch will later appear in the mm-new branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: simplify MEMCG_VMALLOC updates - fix
Date: Fri, 4 Apr 2025 10:41:52 -0700

add comment

Link: https://lkml.kernel.org/r/bmlkdbqgwboyqrnxyom7n52fjmo76ux77jhqw5odc6c6dfon3h@zdylwtmlywbt
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmalloc.c~memcg-vmalloc-simplify-memcg_vmalloc-updates-fix
+++ a/mm/vmalloc.c
@@ -3370,6 +3370,7 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
+	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
 		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
 	for (i = 0; i < vm->nr_pages; i++) {
@@ -3671,6 +3672,7 @@ static void *__vmalloc_area_node(struct
 		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
+	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
 		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
 				     area->nr_pages);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch

