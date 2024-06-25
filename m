Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61131428E0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291733; cv=none; b=GJvNvaCBrZ0USnFtZmXckRPnqHyLdbnct909B6/5NhmUOmzfeXiWjoWBedSCCrJDBFWduBmLvMXROcnUnl/1VwZeEcP/odKjXNlibWLeKg2YfDTwebeurGFXT1C+b/bVEYRhcbpSDsFTIoI6A9Gfv5RHtH3pd9Jdu673ualjsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291733; c=relaxed/simple;
	bh=1C1kkdrW3raHpZ/Y4bHs9Gvlfn1napWy7G9guWac/wE=;
	h=Date:To:From:Subject:Message-Id; b=Jg34I82TlXmCngF+QXOtR1BA3RYZrIBijVJrC0UTXlst/lOzbb2+D5ggKwcFPqFcyZFbqMmgqui+mc2bh+ZSJWS+kgSkiURnY5N1gg7Qvsrjb8m0vWFm3anJizQtHcuMB4hKsZ1Xpl5n/YMXYdw+NEbUPil4orWVIPZPIfn12+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mBXyxrIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mBXyxrIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C90EC32782;
	Tue, 25 Jun 2024 05:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291733;
	bh=1C1kkdrW3raHpZ/Y4bHs9Gvlfn1napWy7G9guWac/wE=;
	h=Date:To:From:Subject:From;
	b=mBXyxrIXwHLE0b1N1CAIFECvjTdRi6Tsp9EnKlB9oFTY1hRUARaJvEPS6tdPQg+yb
	 UNuK3TrM61fo+hfYH97ILxadmEOnWEQjFoDvCbbo0Tk67NnuNwGCKm9vln29ydZOLP
	 b4wGiJreGePtPPlqE6XhrMpNE7xnI4AHiGysfDpQ=
Date: Mon, 24 Jun 2024 22:02:12 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch removed from -mm tree
Message-Id: <20240625050213.7C90EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: add VM_BUG_ON_FOLIO() to catch lru folio in mem_cgroup_migrate()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: memcontrol: add VM_BUG_ON_FOLIO() to catch lru folio in mem_cgroup_migrate()
Date: Fri, 14 Jun 2024 09:07:42 +0800

mem_cgroup_migrate() will clear the memcg data of the old folio,
therefore, the callers must make sure the old folio is no longer on the
LRU list, otherwise the old folio can not get the correct lruvec object
without the memcg data, which could lead to potential problems [1].

Thus adding a VM_BUG_ON_FOLIO() to catch this issue.

[1] https://lore.kernel.org/all/5ab860d8ee987955e917748f9d6da525d3b52690.1718326003.git.baolin.wang@linux.alibaba.com/

Link: https://lkml.kernel.org/r/66d181c41b7ced35dbd39ffd3f5774a11aef266a.1718327124.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate
+++ a/mm/memcontrol.c
@@ -7807,6 +7807,7 @@ void mem_cgroup_migrate(struct folio *ol
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
 	VM_BUG_ON_FOLIO(folio_test_anon(old) != folio_test_anon(new), new);
 	VM_BUG_ON_FOLIO(folio_nr_pages(old) != folio_nr_pages(new), new);
+	VM_BUG_ON_FOLIO(folio_test_lru(old), old);
 
 	if (mem_cgroup_disabled())
 		return;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


