Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230D639AF4
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957153; cv=none; b=ttT2ci4qoAkudBLgFmkRUYV05o7RXlHyoga8j5C9a/czdMY/GzD41RZvjYP+NO6LPXTnoOCyxKvc3TmB45BK6BsDMit4wOkkjQjZBcGXF9BnlJEvAUorwv90ziVYcBW0UYmdIS6UXztirrwMHVlkddLIWaGmiM14xGfHdINy1eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957153; c=relaxed/simple;
	bh=VTtU6073yMh4XYRf0Tcq9pXI1/s+tT2YdwkqvonPEaU=;
	h=Date:To:From:Subject:Message-Id; b=QuV4O6+kI1hizHps0bY4z0XYSgP2eO5FjeQIwi9ylk7ai+zXUs4tme6I4oXNkgvNexvuNsJuWQKHiRnBJrkddynpGwuo6MxEyOqLjCT2rZZtIEWy55e/rsMpQCfCAnN95ws8XrT8y8GfYH1SG9lUvF5m3Cxg5Dfj5OGDn41MYCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EAzi/uNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EAzi/uNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA843C116B1;
	Mon,  6 May 2024 00:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957153;
	bh=VTtU6073yMh4XYRf0Tcq9pXI1/s+tT2YdwkqvonPEaU=;
	h=Date:To:From:Subject:From;
	b=EAzi/uNHmyDiYxlTt6VD+0XQGf9nARqJfddN+EPUTyanIiZyG3SVhRFE9Uf+iUXr0
	 tv2v60MzxOOOF3vZEF50lmLRJ86qExsmmcnnBH1m2peo98r9G9kRMMxfWMt45d5ZSE
	 nmxJ0N+3KvgEWWjRWFVWnHolrc82zi/5IxshLuk4=
Date: Sun, 05 May 2024 17:59:12 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-cleanup-__mod_memcg_lruvec_state.patch removed from -mm tree
Message-Id: <20240506005912.EA843C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: cleanup __mod_memcg_lruvec_state
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-__mod_memcg_lruvec_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: cleanup __mod_memcg_lruvec_state
Date: Wed, 1 May 2024 10:26:14 -0700

There are no memcg specific stats for NR_SHMEM_PMDMAPPED and
NR_FILE_PMDMAPPED.  Let's remove them.

Link: https://lkml.kernel.org/r/20240501172617.678560-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~memcg-cleanup-__mod_memcg_lruvec_state
+++ a/mm/memcontrol.c
@@ -1009,8 +1009,6 @@ static void __mod_memcg_lruvec_state(str
 		case NR_ANON_MAPPED:
 		case NR_FILE_MAPPED:
 		case NR_ANON_THPS:
-		case NR_SHMEM_PMDMAPPED:
-		case NR_FILE_PMDMAPPED:
 			WARN_ON_ONCE(!in_task());
 			break;
 		default:
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


