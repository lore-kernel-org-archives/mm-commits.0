Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C77A5013DF
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788463647; cv=none; b=Zjwnm8WkLZKhQ0HZSeYFsKAJwCrUAPL8jwoXTfOZd2L9dj6pcikUynEw8xla2HtH9t3GvbSkW7fGloMqBdPxX8JbiqnBObKLA9gzFIejji0aCnXGo/CeWpqN4JIlTp12p4pagAAvQf854Nmi8YZqAMac99X8E7I/f6yYwhZOePo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788463647; c=relaxed/simple;
	bh=jDNT579G/YgbvE5U2IgJB3eaxZ64VCRQoYr/klq21iU=;
	h=Date:To:From:Subject:Message-Id; b=OQvvojei/yxmaUVdKdc6dVdaFcLyaEStcBHa7p5hRYzTRPt+A3D/bs2TOC973hfR3nMdBY5ut2KPjOg1edBppaJFXFhpb127ElCvaVdNdzm1SZKduRmKjuhDGrye/aLjSYgwl2kUCh7Cg5ff/sC5M2XAg4xPHK9Ynsr6IDxxBr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mfh6dbph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mfh6dbph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F9C1F00A3D;
	Thu,  3 Sep 2026 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788463634;
	bh=U0qivrcuD8ks/zk5QatwZdGpIWgcLLElT3HwXNG/IS0=;
	h=Date:To:From:Subject;
	b=Mfh6dbphmaf5NK5KQxTtb0AdU6gNO1s5J3k/Emg3YlSYirwEreBCbv5/wI9B72FEI
	 g7X4DWXGzCm6ETcl4q27YIUTLwHEpHwSa6uZYuxdWtATiRH+/Q2dXJ2QXPPOLHZumd
	 DJBLolJrqk1V3Mnn2Vy5trS1pINy8pbzxSKR05ew=
Date: Thu, 03 Sep 2026 12:27:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch added to mm-new branch
Message-Id: <20260903192714.94F9C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: preserve original free_pid/free_tgid during folio migration
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/page_owner: preserve original free_pid/free_tgid during folio migration
Date: Thu, 3 Sep 2026 17:21:26 +0800

__update_page_owner_free_handle() accepts pid and tgid, but ignores them,
always storing current->pid and current->tgid.

__folio_copy_owner() forwards the original free pid/tgid during folio
migration, yet these values were overwritten by the migrating task.

Store the passed-in pid/tgid so the migrated folio keeps the original free
attribution.

Link: https://lore.kernel.org/20260903092126.24685-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration
+++ a/mm/page_owner.c
@@ -307,8 +307,8 @@ static inline void __update_page_owner_f
 			page_owner->free_handle = handle;
 		}
 		page_owner->free_ts_nsec = free_ts_nsec;
-		page_owner->free_pid = current->pid;
-		page_owner->free_tgid = current->tgid;
+		page_owner->free_pid = pid;
+		page_owner->free_tgid = tgid;
 	}
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch
mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch

