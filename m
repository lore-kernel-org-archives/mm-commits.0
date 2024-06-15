Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2969C8F6B
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 02:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718419490; cv=none; b=gbDACcdCGdZj1rpYJUFuVi8HU8ir4d/rZ16EMphnE/s+1nikVfNawMh2TxpUtdUJW+lZlv2bdM5yQC1yn5Yc2iXgwt5tK3fnJqYO+Rl3YhvVZs2U2UtQF9T1Q5ZjKpASvTlhbFHw90U9fwgxh4jo/l9+c9IqAfSk7ur9db6ofRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718419490; c=relaxed/simple;
	bh=nt2dNBmuwPnzzIbu1RWOwuCD67FuBpczpRTVApieUx8=;
	h=Date:To:From:Subject:Message-Id; b=YCHtbVun7lUabFztebAp3XOcpnD3vviaI+6MUz/unIk7LbqdEUnU/uSL5f6ZFoVkbrJzdNZe6PXL7Dcx2C+m/GzhFYtUxUczEYq6QLnrjdGjI9SQ9dnDPAdzoViXsQKoopKe4AWFPxqO1EQZbmjZTaXLTqBl6nWoS8/NhquT7OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=figClkXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="figClkXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B475C2BD10;
	Sat, 15 Jun 2024 02:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718419489;
	bh=nt2dNBmuwPnzzIbu1RWOwuCD67FuBpczpRTVApieUx8=;
	h=Date:To:From:Subject:From;
	b=figClkXiL4JIDvTFuxWDMGt4E7kLWG2dxMLriQ9M8HpseWQ0K4Pb25stm2qSFmkW2
	 XZIfY2EdSNa7mr+R8dmYP34nLkPncpL5dNkmgTNKuwq8ja+KNn9UvoeRkwmPYr6JgM
	 ky2FJ/YH4jdpqXugscrNNJbwfzsocU+spYjgpSSM=
Date: Fri, 14 Jun 2024 19:44:48 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch added to mm-unstable branch
Message-Id: <20240615024449.7B475C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: add VM_BUG_ON_FOLIO() to catch lru folio in mem_cgroup_migrate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

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
@@ -7808,6 +7808,7 @@ void mem_cgroup_migrate(struct folio *ol
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
 	VM_BUG_ON_FOLIO(folio_test_anon(old) != folio_test_anon(new), new);
 	VM_BUG_ON_FOLIO(folio_nr_pages(old) != folio_nr_pages(new), new);
+	VM_BUG_ON_FOLIO(folio_test_lru(old), old);
 
 	if (mem_cgroup_disabled())
 		return;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

