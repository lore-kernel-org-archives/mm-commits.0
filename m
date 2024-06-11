Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551422CCB7
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142152; cv=none; b=u2Bo8zeb22wEvzz0QKuKorYVWL9FYSWgFuK7ajCsu8M74mmKEFcB3Yjf5+Sfx3wcSrV0HQmGS9Jqr3spn1Vw2tIbI+vUIfbA7boY/6al8lPoFEh4d6RZLHMg8vx6umz+tXCRxYnoIZHIn8fnuD5g1Her3oS/I6+rBDVGfz+kqfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142152; c=relaxed/simple;
	bh=gWdJFS7uy0HeY0ooEAt0hbGTPRtlc+IuPuGZwNVMYvs=;
	h=Date:To:From:Subject:Message-Id; b=nmO3+MbLQYOCa8UHj5UrEJMq2hAYAYPOZ6z68FEtAyGWhgkhcT8HhCPGWIqSY4/wxpev0gCKZ8S0NZi9abgsXzGykIiKpvWA3XMc2pNrVUBYATDvlDdbGnkRDzYUzWA9G2TpoKLAr+idQYnf+lXVsxCbcrD00wb7raAM1Ev+fh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzowUB22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzowUB22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DD2C3277B;
	Tue, 11 Jun 2024 21:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718142151;
	bh=gWdJFS7uy0HeY0ooEAt0hbGTPRtlc+IuPuGZwNVMYvs=;
	h=Date:To:From:Subject:From;
	b=QzowUB22CUjNBy6rI6ApgB0iMhxLgFXc6oe0ZL2IVsok35/Up+PC70RgO5B3ucyBa
	 pFVIvDIqM1CgKbYwcksRLBGJXQRPaF7smMgWYKFiyr8U+zABdF1lDEofQRSQx31vsP
	 WRiO8wfj3Lh9WJiA7dg3DG8dmYR2FlKU50bitkww=
Date: Tue, 11 Jun 2024 14:42:31 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,abelova@astralinux.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-prevent-accessing-by-index=-1.patch added to mm-unstable branch
Message-Id: <20240611214231.B7DD2C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: prevent accessing by index=-1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-prevent-accessing-by-index=-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-prevent-accessing-by-index=-1.patch

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
From: Anastasia Belova <abelova@astralinux.ru>
Subject: mm/memory_hotplug: prevent accessing by index=-1
Date: Thu, 6 Jun 2024 11:06:59 +0300

nid may be equal to NUMA_NO_NODE=-1.  Prevent accessing node_data array by
invalid index with check for nid.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20240606080659.18525-1-abelova@astralinux.ru
Fixes: e83a437faa62 ("mm/memory_hotplug: introduce "auto-movable" online policy")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-prevent-accessing-by-index=-1
+++ a/mm/memory_hotplug.c
@@ -839,7 +839,6 @@ static bool auto_movable_can_online_mova
 	unsigned long kernel_early_pages, movable_pages;
 	struct auto_movable_group_stats group_stats = {};
 	struct auto_movable_stats stats = {};
-	pg_data_t *pgdat = NODE_DATA(nid);
 	struct zone *zone;
 	int i;
 
@@ -850,6 +849,8 @@ static bool auto_movable_can_online_mova
 			auto_movable_stats_account_zone(&stats, zone);
 	} else {
 		for (i = 0; i < MAX_NR_ZONES; i++) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+
 			zone = pgdat->node_zones + i;
 			if (populated_zone(zone))
 				auto_movable_stats_account_zone(&stats, zone);
_

Patches currently in -mm which might be from abelova@astralinux.ru are

mm-memory_hotplug-prevent-accessing-by-index=-1.patch

