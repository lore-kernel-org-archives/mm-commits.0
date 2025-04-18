Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0805158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945871; cv=none; b=IBAY2RXFxZHZo2r6ckQhGDaHmTuhG/mSUEVvXXTV/3PsUf0+VrsImhdXCnlq8KTbMdUORxKS1ttzV+eGbtX7H+4TJhu1qUeSOq7ZbYua4XrK6TmWffYQtSk/dUkDikaUt2xF/ikP3F8m39snm+4HaQ8KrJDOazs2N3tqun8rdAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945871; c=relaxed/simple;
	bh=j4dHybqdMXABsK6jIZ4bUT0pYRBHendWDM2fIgm/biE=;
	h=Date:To:From:Subject:Message-Id; b=HwJHBN2GlRRB6gMS7j0oTCAW1m7SzBsgJLMQqwaudv5GonmSb3SqdS7ygYPcs5hM/frCvLn2ILCLrMY3j6gd3wg0HwEFQTAj0Xwbz1p5QGifowXvpZjeEJtK3es3wi51tZvAXenMwWcx/Kn7BXEPqCA77/b/ErbAmxzAbaPpRDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dhX/lTuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dhX/lTuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C83C4CEE4;
	Fri, 18 Apr 2025 03:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945869;
	bh=j4dHybqdMXABsK6jIZ4bUT0pYRBHendWDM2fIgm/biE=;
	h=Date:To:From:Subject:From;
	b=dhX/lTuj4HQv62hEau7FSxX+NTyHE4txd/bjv4sy2t606WBzANzSHGQ1b51nPnLJJ
	 0i4NO3GdsFvIK2qoxtivanHF3S0oYM1IykDp4yWv6Ujpe9qlEhbHqhqLWZikRY07iw
	 4vLas8FpsozSU/p40gdSungiOzwZk8vdgbnzikLs=
Date: Thu, 17 Apr 2025 20:11:09 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch removed from -mm tree
Message-Id: <20250418031109.B8C83C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: fix swap counter leak from offline cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix swap counter leak from offline cgroup
Date: Thu, 10 Apr 2025 16:18:12 +0800

commit 73f839b6d2ed addressed an issue regarding the swap counter leak
that occurred from an offline cgroup.  However, commit 89ce924f0bd4
modified the parameter from @swap_memcg to @memcg (presumably this
alteration was introduced while resolving conflicts).  Fix this problem by
reverting this minor change.

Link: https://lkml.kernel.org/r/20250410081812.10073-1-songmuchun@bytedance.com
Fixes: 89ce924f0bd4 ("mm: memcontrol: move memsw charge callbacks to v1")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup
+++ a/mm/memcontrol-v1.c
@@ -620,7 +620,7 @@ void memcg1_swapout(struct folio *folio,
 		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_id(swap_memcg), entry);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


