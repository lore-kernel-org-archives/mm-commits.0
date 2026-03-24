Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109529BDB1
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774378554; cv=none; b=HSSSlOjoMi/NIgm8rA+hT685Y1vA9sjcHh2Ms4uY/7M1VsMI/G8XJbI3ZnvFuHdbsHv689x/Ox9r1NQsAUpI3Xh2w/vibcL/fACmxW+HNYquuh4CYeelFUiPXuZUBgS4xRfFDThUWeIeT11A2LaLj/D7g8q6P8vnDo19AKsGfGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774378554; c=relaxed/simple;
	bh=5B6e64nu5Zb9sC3IdE9+RHG2kHdUiq8f88LzOGBfj8E=;
	h=Date:To:From:Subject:Message-Id; b=ZidBumNSWc6+ydpv/8LEJVhrX+Az+iEoZg2IULOy79EcRmuFHwtgajUxtmsCFTuHXork0JlwDyuZgOC9s12ix+uDXhxkOCWJ7BPleBWqAclEdv9bjQ+Vy2LssHhpcbf9QSxalB4ri1JsA0PyDGRup/wgxmS3au6A4qHUWqv7ltI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GnsGcGEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GnsGcGEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC66C4AF09;
	Tue, 24 Mar 2026 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774378553;
	bh=5B6e64nu5Zb9sC3IdE9+RHG2kHdUiq8f88LzOGBfj8E=;
	h=Date:To:From:Subject:From;
	b=GnsGcGEVZiyIQC09pSKBwsqTVXQ1npwQXdNnJgv68HPeVDXRqIhpCLmgrRtdo5hX6
	 0oUjau0lKw9CrJ+aLgH7QyxFKgeaE3KmCOqY/JGadnlxZXNtJYEzTKuW/3QubVwbK+
	 j+daEjidBlgSX0TIGRErBOC12Jjx3yHwX/I4wUDY=
Date: Tue, 24 Mar 2026 11:55:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch added to mm-unstable branch
Message-Id: <20260324185553.7EC66C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix: mm: vmscan: prepare for reparenting MGLRU folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch

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
mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch
mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state.patch
mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix.patch

