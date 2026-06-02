Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABF33BCD04
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439196; cv=none; b=e5qLgMXzknAqvNcIct2zIy6OJ4uafNJp6gUjelYkngrh4eGY92yXTTBtPpjn/iU8XpMcxyEc5VsrxFPHz4FKXRMqYMsgQhALSo+as450zhS30oU/lmV+NnZX9jfP3NVXVAU1dY5fHBzvRPaRb+jy6/s0Ug1D2gU3gMDuJE3a3Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439196; c=relaxed/simple;
	bh=jbm9j6sBb/Kqlx7WRxMnPCIA/JFjulQKny9o4AkUgKs=;
	h=Date:To:From:Subject:Message-Id; b=CS4KwpLy+2nj3fdiaD2EgMWhEeyqV2GXGI6Kl5NfVWIgYBFgZm8QOG7ODRDQz8BA1RobxLBrvWsgbEMqZSNjXMyc1kLMK2JEqHXciRcYLjFmDzvEoddyKL/XCuhi6TvgpdmHZZbIsWPjVGV3hbIdp2LZioXeOhHriGLquLoB9I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CqI5A/0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CqI5A/0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556A81F00893;
	Tue,  2 Jun 2026 22:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439195;
	bh=CH9HinY8fK3bs0P0jwsbJsc9k2kqVEUBdebnwd+qs1w=;
	h=Date:To:From:Subject;
	b=CqI5A/0NJN1k2oOl+cwaMWY5w6B+IEb9eK4OWihssvGhA/9oVdEczjMOl2rJRtLoV
	 bsMe4J075EA+tWzLnK0BPhSwst98zbaR8iyWY5VgF2CDwy+pN6EQ2gSQhr8A6eZff6
	 6hAU3bkHhXRb8adTUcUsdoba9VbLzX7Piu4GKuRo=
Date: Tue, 02 Jun 2026 15:26:34 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-sc-unqueued_dirty.patch removed from -mm tree
Message-Id: <20260602222635.556A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove sc->unqueued_dirty
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-sc-unqueued_dirty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/vmscan: remove sc->unqueued_dirty
Date: Tue, 28 Apr 2026 02:07:05 +0800

No one is using it now, just remove it.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-14-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
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

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-sc-unqueued_dirty
+++ a/mm/vmscan.c
@@ -169,7 +169,6 @@ struct scan_control {
 
 	struct {
 		unsigned int dirty;
-		unsigned int unqueued_dirty;
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
@@ -2039,7 +2038,6 @@ static unsigned long shrink_inactive_lis
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
_

Patches currently in -mm which might be from kasong@tencent.com are


