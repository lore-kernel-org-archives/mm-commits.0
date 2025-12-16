Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E9EA59
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765927997; cv=none; b=GuT5D9hUiLMTwRjr2yLPr1YpauH664U7gS35Jflor/shgK3XXafYlvpdFI9CJkuAyqpAZdihqithkmNnCC2jJ14JQqwVKcKAgVAn9QjyDdtGgwr8HZduGRsDdB+PWR/U/qRqcU64zaKpe99bbySwlYYyIjDVn2a1wcug2yKzMFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765927997; c=relaxed/simple;
	bh=YxHUX98MfhIqso7OxfEBh3G/dDladHAR3shmdJnJGps=;
	h=Date:To:From:Subject:Message-Id; b=QIuZqvG/Fn/nxkt/xMjFKCBbLacrshmCfYsDuOtXvcRh4CdU8f+Jp084OBj4GK3I+ycgaeBpANFvUEA2HwljmgvPmcfWT/tmu6MGlbDXnYk4B0zLT72WRbAs+uTYZcvjD/JnhVtShO45bAhgF0TWV8xbm5Kw8Rud8V1xxhOsg/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlKRA5b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlKRA5b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C52CC4CEF1;
	Tue, 16 Dec 2025 23:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765927996;
	bh=YxHUX98MfhIqso7OxfEBh3G/dDladHAR3shmdJnJGps=;
	h=Date:To:From:Subject:From;
	b=PlKRA5b0tt+BtWjVcYChkL5mY5mh5LCLF063ZJIgBrr1dajpCC6ETNhPKJ/vWili8
	 J7eQtVlAmJRamoEwUvrO4PRGeOLQLniYwNMmwYfB5K1E5NeGsB+UWJ+28GAY6QRro/
	 etz4jnLV+9zYXqHxtQxinm7skMXe6hQPnjYTnyCw=
Date: Tue, 16 Dec 2025 15:33:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch added to mm-hotfixes-unstable branch
Message-Id: <20251216233316.4C52CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: fix unit conversion for K() macro in OOM log
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: memcg: fix unit conversion for K() macro in OOM log
Date: Tue, 16 Dec 2025 13:20:54 -0800

The commit bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or
alloc failures") added functionality to dump memcg protections on OOM or
allocation failures.  It uses K() macro to dump the information and passes
bytes to the macro.  However the macro take number of pages instead of
bytes.  It is defined as:

 #define K(x) ((x) << (PAGE_SHIFT-10))

Let's fix this.

Link: https://lkml.kernel.org/r/20251216212054.484079-1-shakeel.butt@linux.dev
Fixes: bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or alloc failures")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Chris Mason <clm@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log
+++ a/mm/memcontrol.c
@@ -5638,6 +5638,6 @@ void mem_cgroup_show_protected_memory(st
 		memcg = root_mem_cgroup;
 
 	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
-		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
-		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
+		K(atomic_long_read(&memcg->memory.children_min_usage)),
+		K(atomic_long_read(&memcg->memory.children_low_usage)));
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch

