Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF163E1200
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314200; cv=none; b=Y9TQcObtCeLXHBy2LbPJM1rPKZP3GDGzKn9WJXCu40/pVsHDTjlJhHgN3Hcdd/KcCK1PF52i6bafopnhj8c9FCE78Uxjpj0AOfiCJ6wzmOfePoJvtDL7nTrGmVwy7s1oKrR5DQ4utjzNEhKFDlVSZJlQCqajHNAapnIBQC+gTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314200; c=relaxed/simple;
	bh=0AGu1nd9/zRX4vIePLiAqpzzbCLQxxsxQKTaIZ4gIh4=;
	h=Date:To:From:Subject:Message-Id; b=IW7J7W6c6aN/Fulo1jvH0thSpJSRePeVs16td8MUY0C1Rg7zCipuBcoC8GNivV0muqcYcM311GLtlVVjUD4SzFeNOkZD2nh2A3eURzSVWMJNTdvAAGcc3BZhR3s321UPYIYgSRXO7IPXrCyipEyMbrcMfMrUYQDtGS7qAXXC0TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQVUhin7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQVUhin7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5840AC2BCB5;
	Mon, 27 Apr 2026 18:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314200;
	bh=0AGu1nd9/zRX4vIePLiAqpzzbCLQxxsxQKTaIZ4gIh4=;
	h=Date:To:From:Subject:From;
	b=AQVUhin7nF3GDpm1VAhQx7YymJSR+8EtapfvC30QHDBFRH6ahN6M8L9w3vSWs3WK2
	 b7pC1h3ZE3E6Bd6L/NVYQ69K++pK81T+WJkgW5tWWi9SgwNk8PMm+qQ8TswZGRwQhH
	 K0X4qbuW21d1SnpGprbq6zAggUtg1WQeLdLsUUQo=
Date: Mon, 27 Apr 2026 11:23:19 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch added to mm-new branch
Message-Id: <20260427182320.5840AC2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: avoid reclaim type fall back when isolation makes no progress
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: avoid reclaim type fall back when isolation makes no progress
Date: Tue, 28 Apr 2026 02:06:57 +0800

While isolation makes no progress in scan_folios(), we quickly fall back
to the other type in isolate_folios().  This is incorrect, as the current
type may still have sufficient folios.  Falling back can undermine the
positive_ctrl_err() result from get_type_to_scan(), which is derived from
swappiness.

So just continue scanning this type for another round.

Worth noting if the cold generations are all reclaimed, scan will no
longer make any progress either, which may undermine the swappiness again.
This is not a new issue and hence better be fixed later [1].

Link: https://lore.kernel.org/linux-mm/CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com/ [1]
Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-6-02fabb92dc43@tencent.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress
+++ a/mm/vmscan.c
@@ -4817,8 +4817,13 @@ static int isolate_folios(unsigned long
 			*isolate_scanned = scanned;
 			break;
 		}
-
-		type = !type;
+		/*
+		 * If scanned > 0 and isolated == 0, avoid falling back to the
+		 * other type, as this type remains sufficient. Falling back
+		 * too readily can disrupt the positive_ctrl_err() bias.
+		 */
+		if (!scanned)
+			type = !type;
 	}
 
 	return total_scanned;
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split.patch
mm-mglru-avoid-reclaim-type-fall-back-when-isolation-makes-no-progress.patch
mm-mglru-use-folio_mark_accessed-to-replace-folio_set_active-in-pf.patch

