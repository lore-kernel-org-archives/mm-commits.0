Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDD720D4FF
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394098; cv=none; b=thsN2yFWSaj+CNrmuBurEKqINE6EvTvrjXlk/wVYhuQ+WJqVQbkfN02+JTzXIp4raFCJ6Xs6TGsQFO8T3DIB+kJGE/LPjSNAiqnRTQ9PmqnwE0kBSM4UoWMk03etb6MA+vcT5Ukj3qqUeQq1X7D9FuquM8Zh1L9fklVZotA9N/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394098; c=relaxed/simple;
	bh=Srw1LUEQ9nhrxqhm7+jo1q/7vkboomXxLA/VWrVXrtM=;
	h=Date:To:From:Subject:Message-Id; b=lSCMZqn/rBrxsHWLcAcAwQpldKChng0dwyNonp0ThIXnMRxU16sBRdPNm+NiDSf7QYpVD2M02M5VPTI1AYsiMSxdEVZWY4FXHPSHDSvTY3n11vahTmyKaV6B/7VnvHT2i2Smrzl5uwIdVlFNDX9WrTobw/2eGKJ3TkdF0LfB76s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CG6wxrmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CG6wxrmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FCAC19424;
	Tue, 24 Mar 2026 23:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394097;
	bh=Srw1LUEQ9nhrxqhm7+jo1q/7vkboomXxLA/VWrVXrtM=;
	h=Date:To:From:Subject:From;
	b=CG6wxrmz3sEmDFBOs+VrOP678dbn1Jsgcts3KlVPckQDM3px7lZ2TNKRsaHwvgacc
	 5vkjNu4PVPDbZaopoQBAFVJbYPzYDVB3RoeGXW/A8Y/qBD6IaEs9KJIMbcCTFvDG+W
	 5CmE/5NYvXtqCNwcI5ZrH+l1sih9WxweWU6Sm5r0=
Date: Tue, 24 Mar 2026 16:14:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch removed from -mm tree
Message-Id: <20260324231457.C8FCAC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix: mm: vmscan: prepare for reparenting MGLRU folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch

This patch was dropped because it was folded into mm-vmscan-prepare-for-reparenting-mglru-folios.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: fix: mm: vmscan: prepare for reparenting MGLRU folios
Date: Tue, 24 Mar 2026 19:49:37 +0800

The lru_to_folio() returns the tail folio, and the lruvec_add_folio() adds
folio to the head, so the tail page is colder.  Since we always assume
that the folios in child memcg (about to go offline) are always colder, we
should use list_splice_tail_init() to reparent the child folios to the
tail of the lru list of parent memcg.

Link: https://lkml.kernel.org/r/20260324114937.28569-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Harry Yoo <harry.yoo@oracle.com>
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
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

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-prepare-for-reparenting-mglru-folios-fix
+++ a/mm/vmscan.c
@@ -4513,8 +4513,8 @@ static void __lru_gen_reparent_memcg(str
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
 		/* Assuming that child pages are colder than parent pages */
-		list_splice_init(&child_lrugen->folios[gen][type][zone],
-				 &parent_lrugen->folios[gen][type][zone]);
+		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
+				      &parent_lrugen->folios[gen][type][zone]);
 
 		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
 		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
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
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch

