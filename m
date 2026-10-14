Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A469F3B9D8C
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792019413; cv=none; b=KJxwRMYar0FChYPcvZHY5/FKmFuT7aUAnwtyioMwZA1pj4a8jNRZBXjPGpG0aYMt4szasaD6ykI2Uyq/AosIMXywKUP383ht0lGeLFwn49760CMvKLD7SzJ0cX+trIhLtqgn1Nov8HyIlHiFxoS5TR4LaE4MvP6xzMsv79Ya/dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792019413; c=relaxed/simple;
	bh=pUUJN8CMDP8jv0+SndwudtHDDkP6+iBvlVXU7SfIihg=;
	h=Date:To:From:Subject:Message-Id; b=noFxf6pJTbmU9DMrdjBMEiKnzuTcBh0aF3De8FTynXa8G3EHuHcTzONNVfknPDGqnSSq6AV/cPFauhTGVhoKzFWo45D2Nchct3dIHWB/95Q5Kjsm4iEnAOMa6A5seGPTlrmG4wYjfc7QJhM791UwfeRcbzeBourxGMdWxvOd+/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eFd3Td9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eFd3Td9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0831F000C4;
	Wed, 14 Oct 2026 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792019412;
	bh=uGo4BGy7F5MYlBbGQtLfNEpOBI9WWrypYsIFDdBq6tg=;
	h=Date:To:From:Subject;
	b=eFd3Td9NWn+Bw4RJdL3dHCykBhRp9oeJPCTJU4vjsOZ7tRLJCB5ohCWaUHNbn3HbZ
	 bU+dN9OkRVlmouvz/rUd935iINXr+xDwYeH6GiG4mBA8MG2zdr4Em3Xi9gFeGbCpVl
	 97qkrfSpWFVxh2d43UJm4UehtsvKHRocY/piRLOE=
Date: Wed, 14 Oct 2026 16:10:11 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path.patch added to mm-unstable branch
Message-Id: <20261014231012.2F0831F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Wed, 14 Oct 2026 17:00:23 +0800

MGLRU evict_folios() isolates folios from the LRU without updating the
NR_ISOLATED_ANON/FILE counters, unlike the legacy shrink_inactive_list()
path.  This causes compaction's too_many_isolated() check to under-count
isolated pages when MGLRU reclaim is active.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using the
existing nr_isolated which holds the original isolated count.

Link: https://lore.kernel.org/141901355a7d9e4bbca5c4840ae32ea5c65fe3b6.1791968227.git.zhuhui@kylinos.cn
Link: https://lore.kernel.org/cover.1791968227.git.zhuhui@kylinos.cn
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 mm/vmscan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path
+++ a/mm/vmscan.c
@@ -5081,6 +5081,9 @@ static int evict_folios(unsigned long nr
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -5149,6 +5152,8 @@ retry:
 		goto retry;
 	}
 
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmscan-fix-missing-nr_isolated-counter-update-in-mglru-reclaim-path.patch

