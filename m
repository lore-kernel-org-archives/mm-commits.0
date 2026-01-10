Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4562FAD24
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 23:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768088834; cv=none; b=KL/sj15sl/k9WhqEfkanpqtDNNUKSg0xMEO/XBdLLm8P0oPEo8dNGE7QLoIRgJLPtpMaGgdilW08OrAGQwzs2IgNvrqqG/O3v8Rm5PQcuxicoo/M5xYIumPrYnkpkY9n4oqT3JULFw5ql1YGYowoQBsLaD6NunHOzqOtSQZyjbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768088834; c=relaxed/simple;
	bh=qALSTcoksQ6kHhcZNx79cCRSPAzwywyNtApKOkNXn0o=;
	h=Date:To:From:Subject:Message-Id; b=B/71gIzqn2v1AklJVoSuPAnva6e7+f1rpi54ERlR/tDKH3lWozVK5hCqxfHudbBP055TXA4BMJzdL3qmgxbLDbY93eYE4tcpDQmhqJ6cGwNp8qV/ZLDt0vb98ipvDMBuWSP6ARL/l6Fl2YoHCaRT6s5tTWusgGXOnlZK25M0xBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eM/arcab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eM/arcab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A211AC4CEF1;
	Sat, 10 Jan 2026 23:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768088833;
	bh=qALSTcoksQ6kHhcZNx79cCRSPAzwywyNtApKOkNXn0o=;
	h=Date:To:From:Subject:From;
	b=eM/arcabzQZmakcZUCT2gqCLG3CaKCDtjRQji7lmq9MvclUb4f4o4cpArw2GTUkxz
	 ufnPY8g/I+yDA3e4fo2gXv3bcoUfQz/Q7rQAMEkAAJ6ofA5j2Oh2PDgVwc8Z9hw/f2
	 2HhVSxm2aX3oiBbQA5D5wxoQ0BMGLfw1bHiD6ZJs=
Date: Sat, 10 Jan 2026 15:47:13 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tj@kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,longman@redhat.com,lkp@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,axelrasmussen@google.com,akinobu.mita@gmail.com,bingjiao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list-fix.patch added to mm-new branch
Message-Id: <20260110234713.A211AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix uninitialized variable in demote_folio_list()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Bing Jiao <bingjiao@google.com>
Subject: mm/vmscan: fix uninitialized variable in demote_folio_list()
Date: Sat, 10 Jan 2026 03:38:21 +0000

Commit d92027a5f30a6c ("mm/vmscan: select the closest preferred node in
demote_folio_list()") refactored the selection logic for demotion target
nodes.  However, it removed the initial assignment of 'target_nid' while
leaving a premature check for 'NUMA_NO_NODE' in place.

Since 'target_nid' is now assigned further down in the function based on
preferred and allowed node masks, the initial check at line 1046 is
redundant.

Remove the redundant check to resolve the compiler warning.

Link: https://lkml.kernel.org/r/20260109055937.3739860-1-bingjiao@google.com
Link: https://lkml.kernel.org/r/20260110033830.443638-1-bingjiao@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list-fix
+++ a/mm/vmscan.c
@@ -1043,10 +1043,6 @@ static unsigned int demote_folio_list(st
 	if (list_empty(demote_folios))
 		return 0;
 
-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
_

Patches currently in -mm which might be from bingjiao@google.com are

mm-vmscan-fix-demotion-targets-checks-in-reclaim-demotion.patch
mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list.patch
mm-vmscan-select-the-closest-preferred-node-in-demote_folio_list-fix.patch

