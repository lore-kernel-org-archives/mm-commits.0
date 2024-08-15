Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0C915532E
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762063; cv=none; b=JrtFO6q0CTi8u0bIrCibQAI6CuhSf0WEw8p3JEP/iLDqr7dIkzerkm5g/oPzsx7UKjLg4YV5047rF0+F/x+rcLgKNT5CQrTh+fNmKh3bZHBLaWjasyhC5leFIR2CJS6ejkUKaDgl4FWN3fogrwnFKq8ih1Dg/XB4YV8U6bDK/pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762063; c=relaxed/simple;
	bh=ggISc++j8cOsEHIA66NpMdtCWVxXV1m/EUJFaogyfuM=;
	h=Date:To:From:Subject:Message-Id; b=judfUFonciQeOpcgOrxJo86X0zyGPET+sqqQVcRKyxBgRkf6PaKY7qfBiMUa9Az4O1X/rE0XBucrq38zRmirUT1MqLFmSZjLQTcGLER/F6c0avti0L3qBFpBpsQIlJjxSH151DaD1p0TqZDgJ6hhALwnmKj2YslCg7G/pYyFKVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mByox1vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mByox1vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C99AC32786;
	Thu, 15 Aug 2024 22:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762062;
	bh=ggISc++j8cOsEHIA66NpMdtCWVxXV1m/EUJFaogyfuM=;
	h=Date:To:From:Subject:From;
	b=mByox1vx6pE7NRefJk+BfzHt5uoFWcF7XN9p4shU1Hm7c8MOIgTvBXLGLrwXYkagW
	 ZO4KRsonXMVZiqg9N5qXVcKs4Tup48DTPGLLE5sFvUZIyJRJRzoxcckc883h3ytoG0
	 U2cVn+Jc6HHBdHEg/IPpWzytz7RF67eLW9z9eigQ=
Date: Thu, 15 Aug 2024 15:47:41 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-pgpgin-and-pgpgout-v1-only.patch added to mm-unstable branch
Message-Id: <20240815224742.4C99AC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make PGPGIN and PGPGOUT v1 only
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-make-pgpgin-and-pgpgout-v1-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-pgpgin-and-pgpgout-v1-only.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: make PGPGIN and PGPGOUT v1 only
Date: Wed, 14 Aug 2024 22:04:53 -0700

Currently PGPGIN and PGPGOUT are used and exposed in the memcg v1 only
code.  So, let's put them under CONFIG_MEMCG_V1.

Link: https://lkml.kernel.org/r/20240815050453.1298138-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-make-pgpgin-and-pgpgout-v1-only
+++ a/mm/memcontrol.c
@@ -414,8 +414,10 @@ unsigned long lruvec_page_state_local(st
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
+#ifdef CONFIG_MEMCG_V1
 	PGPGIN,
 	PGPGOUT,
+#endif
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,
 	PGSCAN_KHUGEPAGED,
@@ -1474,10 +1476,11 @@ static void memcg_stat_format(struct mem
 		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
+#ifdef CONFIG_MEMCG_V1
 		if (memcg_vm_event_stat[i] == PGPGIN ||
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
-
+#endif
 		seq_buf_printf(s, "%s %lu\n",
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch

