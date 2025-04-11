Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42E188006
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 05:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744347991; cv=none; b=BiAf4OVOiByK/tueoY+N9KUP3nGIYh4ncubo9H84vGyulAcgAu2/rUhgKADEBQZXu8wjrqK7UmZoVB38HvrNS8IcD/WqOmDtD9fOd6NSAnodP1ruNmONO6x7uLIX+CUknc7dzAx0jukoZ0+Y758CYbqipcmTSF9MAMGTrl/T6W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744347991; c=relaxed/simple;
	bh=oa4NvcBhAPoxLeY4SE2fUw6PtrhkrkPmKdOZuTJKBl0=;
	h=Date:To:From:Subject:Message-Id; b=nOOq7ocs2uszAV8n5CKE2EhA8xVOQ2MocxbSwW9zVfXpBNiMA3cfyp6nji8mcJ2/DwkEFWQfFwhDgNsg2O6CSYz9Vv+F1vsgY6wwYUh1oiG9T8mnPoW/me8EQi1tAMuFqq5S3m+jFx+HaWtPAYus2C3y6/dy1zxStXd6YTNVpkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rk1APnAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rk1APnAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF759C4CEE2;
	Fri, 11 Apr 2025 05:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744347990;
	bh=oa4NvcBhAPoxLeY4SE2fUw6PtrhkrkPmKdOZuTJKBl0=;
	h=Date:To:From:Subject:From;
	b=Rk1APnAm3EA4tcE09iZvinLU+jZIJwahvC8aUd6FPhatvtX9MkdmnA9OkX2Wk4p19
	 h8kgTWZhdU0aOqaXpkjNFtwIZt4CgP6MMJ+LfPBFHcyew/UPL41d2UaX1W8mcEFzpr
	 hUMCpcG3D5CJI1q6OS2SrymdaPWQABD5wrssLtVQ=
Date: Thu, 10 Apr 2025 22:06:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch added to mm-new branch
Message-Id: <20250411050630.CF759C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix
has been added to the -mm mm-new branch.  Its filename is
     memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch

This patch will later appear in the mm-new branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix
Date: Thu Apr 10 10:02:52 PM PDT 2025

fix build: s/flag/flags/ in memcg_hotplug_cpu_dead

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix
+++ a/mm/memcontrol.c
@@ -1964,10 +1964,10 @@ static int memcg_hotplug_cpu_dead(unsign
 
 	stock = &per_cpu(memcg_stock, cpu);
 
-	local_irq_save(flag);
+	local_irq_save(flags);
 	/* stock of a remote dead cpu, no need for stock_lock. */
 	__drain_obj_stock(stock);
-	local_irq_restore(flag);
+	local_irq_restore(flags);
 
 	drain_stock(stock);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch

