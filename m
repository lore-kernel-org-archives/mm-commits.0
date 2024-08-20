Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C822F52
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 00:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724114435; cv=none; b=WrFjcIg/SVYYa+HDdNQi/W0qQz2/g192rx8aFkr6iw7GOCozAlQy2JlziPn9qllgvdLXmYhWBk/5aSNwUJDuAROcGBICLynm9NbSXmyBahuP5+tnmEwpSNMJMJcb45yt96O+ADCsHqD0oAdCfTbBVl0pOpDwEEab7xL2Lf4EPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724114435; c=relaxed/simple;
	bh=/KMpfColypAfTIjVO5IPZdNLfCFWJJWwPImLxi/wWC0=;
	h=Date:To:From:Subject:Message-Id; b=RlMpusgt0+gEHZNbu0KH601G1UhHbo+AZzRbmMBreF7R9LKjhpNy0YeHI+ajOZozMnDhtIeZ/BWpQnm7OH2N5LhaYIFouXwrVNpT23pX6piAC5QMwd3r5AhCQyOteFPxZ522NRuLiT+yXoybyT5WqCGj5NtRc7xX+B9B3tJdkpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQQ8tU1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQQ8tU1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68544C32782;
	Tue, 20 Aug 2024 00:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724114434;
	bh=/KMpfColypAfTIjVO5IPZdNLfCFWJJWwPImLxi/wWC0=;
	h=Date:To:From:Subject:From;
	b=xQQ8tU1DmlwPwElIsoPJZ8Mk4sOtbwy9QX6NhSrvzWRPG2ObgysVWqRAdb+HRGnEm
	 nYTqSdRgTw39gemtGV7r+frJo1YK/XY9eTfbUf89V2T29nj5VxAJjIAhqWwYn/fNfc
	 HtpmPFzdDHIJdQxeWR5FUQy+cOe5W+0P4fskob44=
Date: Mon, 19 Aug 2024 17:40:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix.patch added to mm-unstable branch
Message-Id: <20240820004034.68544C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmem: fix split_page_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kmem: fix split_page_memcg()
Date: Mon, 19 Aug 2024 16:04:15 +0800

split_page_memcg() does not care about the returned memcg for kmem
pages, so folio_memcg_charged() should be used, otherwise obj_cgroup_memcg
will complain about this.

Link: https://lkml.kernel.org/r/20240819080415.44964-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: syzbot+ef4ecf7b6bdc4157bfa4@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000006f7e4d0620042b96@google.com
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix
+++ a/mm/memcontrol.c
@@ -3035,12 +3035,11 @@ void __memcg_slab_free_hook(struct kmem_
 void split_page_memcg(struct page *head, int old_order, int new_order)
 {
 	struct folio *folio = page_folio(head);
-	struct mem_cgroup *memcg = folio_memcg(folio);
 	int i;
 	unsigned int old_nr = 1 << old_order;
 	unsigned int new_nr = 1 << new_order;
 
-	if (mem_cgroup_disabled() || !memcg)
+	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
 		return;
 
 	for (i = new_nr; i < old_nr; i += new_nr)
@@ -3049,7 +3048,7 @@ void split_page_memcg(struct page *head,
 	if (folio_memcg_kmem(folio))
 		obj_cgroup_get_many(__folio_objcg(folio), old_nr / new_nr - 1);
 	else
-		css_get_many(&memcg->css, old_nr / new_nr - 1);
+		css_get_many(&folio_memcg(folio)->css, old_nr / new_nr - 1);
 }
 
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-kmem-remove-mem_cgroup_from_obj.patch
mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg.patch
mm-kmem-add-lockdep-assertion-to-obj_cgroup_memcg-fix.patch

