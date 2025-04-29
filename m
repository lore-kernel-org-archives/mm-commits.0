Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783AF26FD9E
	for <mm-commits@vger.kernel.org>; Tue, 29 Apr 2025 22:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745966342; cv=none; b=PehyPqiYOUhyJ4QQ5IPn+Wdpxsqt+OSQVd2iKJvbpImiSfNrsms5Ut7oNQtE/Ia2aLzgucGLAEthKLQoS9DwNH80QE/GtYUoAv9E7GeoKNSG+Sy5yJB9lMRgZ2PGEJ8FF/wzTgn93lcOZ6CJOLxUtwPvx/nVgM3Z5Rcm9zwQHfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745966342; c=relaxed/simple;
	bh=AkLvXcloY93YEhL+1QbgQ1u98ib/eSetNkRnWe5jBgI=;
	h=Date:To:From:Subject:Message-Id; b=XUO4bO86aABBdaKRTEMZWOFma4MgiaXdr1TvdCeWRynb8Zt9dOxiuSTJrWI98V/jKyucnQ6KzSw95i8zfm/IGonQOskUkIjVw88cr/rLj/HyG38bDXwoTAW6XFXr3cr2tARUd6Vhvt80HqSjQfI7gEfXlXPSx9q0KaOjyl9+IKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dN/xRVH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dN/xRVH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FD0C4CEE3;
	Tue, 29 Apr 2025 22:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745966342;
	bh=AkLvXcloY93YEhL+1QbgQ1u98ib/eSetNkRnWe5jBgI=;
	h=Date:To:From:Subject:From;
	b=dN/xRVH+5vgxtIr2nd6oEcGIU3i6mD1cEx5qEEqbqIWgMqK+dzQaO8nXr9h1pXcsA
	 UXH3EZUt4/Ea04Tl9/j9HreJpiS3ofkV5IuVbHnAniXPvaBb7zy5pQumupHRmJ1c+Y
	 VORiQaqXJqCo05/Op8/ApFNTIxI4v3GIzwP+NFrE=
Date: Tue, 29 Apr 2025 15:39:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-multi-memcg-percpu-charge-cache-fix-3.patch added to mm-unstable branch
Message-Id: <20250429223902.26FD0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-multi-memcg-percpu-charge-cache-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-multi-memcg-percpu-charge-cache-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-multi-memcg-percpu-charge-cache-fix-3.patch

This patch will later appear in the mm-unstable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: memcg-multi-memcg-percpu-charge-cache-fix-3
Date: Tue, 29 Apr 2025 02:40:07 -0700 (PDT)

Fix 2 has been giving me lots of memcg OOM kills not seen before: it's
better to stock nr_pages than the uninitialized stock_pages.

Link: https://lkml.kernel.org/r/d542d18f-1caa-6fea-e2c3-3555c87bcf64@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>	
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix-3
+++ a/mm/memcontrol.c
@@ -1952,7 +1952,7 @@ static void refill_stock(struct mem_cgro
 		}
 		css_get(&memcg->css);
 		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		WRITE_ONCE(stock->nr_pages[i], nr_pages);
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
_

Patches currently in -mm which might be from hughd@google.com are

memcg-multi-memcg-percpu-charge-cache-fix-3.patch

