Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFE2355F49
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774495621; cv=none; b=VQ1cVQZ32vaxMjb5kqAB9uGrqMByZgVYHa8aXJJRTsPShgDPg0XXNyyB4EVmKnMygLLzZaHO1g87EqUV/2eDYyoknTdRCNDjqdb9ERD1akI21mwuGF/UkKkxN778LQSIhtLAKeGaaDfjBh22A9MyBUjmhIWDIYjnXM2+g6hEgY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774495621; c=relaxed/simple;
	bh=cwXrj9Y7FiV29MXA6b78yRDazXwUHUd7jhxwJ5UqswM=;
	h=Date:To:From:Subject:Message-Id; b=NApi20CaNyGWBujhmrKjoKek6ipZFGi/nIjSvvpo9Qx5uxi5FbPJMP1kJNUPTTQMAhL6yhp9neAkLBT5RjxqngWqcHzwdC/RZ3KaSQzbi9H9/w5B3DcXrXWB0Q7q4cCvrPQ3Zmg8mD/wTewZ6zRvTXLYjMcFAw9TONgul/elvMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JL4/J8sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JL4/J8sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D66C4CEF7;
	Thu, 26 Mar 2026 03:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774495621;
	bh=cwXrj9Y7FiV29MXA6b78yRDazXwUHUd7jhxwJ5UqswM=;
	h=Date:To:From:Subject:From;
	b=JL4/J8sASyn9OOfyRqLtjOhUJvjnrBv5K5JzoffgfVZ9T+tchaXfIautA8Kmd2CVZ
	 iuwx6QfaDgQQhvTWqou42fCx0/7yOrjYOk3aekaHpHjXL7X1xPemyqb4rDROeLcZ2t
	 g9LXKPn4mAV77SAQRnDT0mP8Njg2sXEBBgQzABqI=
Date: Wed, 25 Mar 2026 20:27:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state-fix.patch added to mm-new branch
Message-Id: <20260326032700.F1D66C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: fix unexpected massive positive number in memcg_state_val_in_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: fix unexpected massive positive number in memcg_state_val_in_pages()
Date: Wed, 25 Mar 2026 22:13:25 +0800

In memcg_state_val_in_pages(), if the passed val is negative, the
expression val * unit / PAGE_SIZE could be implicitly converted to a
massive positive number when compared with 1UL in the max() macro.  This
leads to returning an incorrect massive positive value.

Fix this by using abs(val) to calculate the magnitude first, and then
restoring the sign of the value before returning the result. 
Additionally, use mult_frac() to prevent potential overflow during the
multiplication of val and unit.

Link: https://lkml.kernel.org/r/e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state-fix
+++ a/mm/memcontrol.c
@@ -787,11 +787,14 @@ static int memcg_page_state_unit(int ite
 static long memcg_state_val_in_pages(int idx, long val)
 {
 	int unit = memcg_page_state_unit(idx);
+	long res;
 
 	if (!val || unit == PAGE_SIZE)
 		return val;
-	else
-		return max(val * unit / PAGE_SIZE, 1UL);
+
+	res = max(mult_frac(abs(val), unit, PAGE_SIZE), 1UL);
+
+	return val < 0 ? -res : res;
 }
 
 #ifdef CONFIG_MEMCG_V1
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch
mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch
mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch
mm-do-not-open-code-lruvec-lock.patch
mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch
mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state.patch
mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch
mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch
mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state-fix.patch
mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch

