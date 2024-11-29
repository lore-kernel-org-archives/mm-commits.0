Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303BD14C5B0;
	Fri, 29 Nov 2024 10:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732875215; cv=none; b=kMPaHzk/rXMuBtfCF+dgbrkjfZhc4UJE/wmXLtFiEVAeUsD5LjAFlWZ8sY0sa3qdiw2Y2HxkxUyeS+qenA1FTCALW+kcxrSAYjdpG/V9os/GZ8jNFYxzgUxPe6Sk8dMNPuQcKiKaN8N/Mit+o5ulX3ewn9OggvrOr2HqSPwIF3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732875215; c=relaxed/simple;
	bh=NPa3oFkWv04US7sf8nc10gt6uF2uaPgqqgmQ2Hgvi98=;
	h=Date:To:From:Subject:Message-Id; b=fm8/QEgTIMH/auaYJeQPv/f2hOoPNQRHwQeJJNF9bOGIyMX7hwfz/TsoNqfHmPXSCwUC+7eYOE2IzH6GKThIhSjuEdcifs64ZE1JobdLZwAI6Y3or0rocghj8v+CYZorp6Pw3alJiUE70899gc9weQlBwjVQ32tIP23ZAyoFiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VurmnLxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VurmnLxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B71C4CECF;
	Fri, 29 Nov 2024 10:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732875214;
	bh=NPa3oFkWv04US7sf8nc10gt6uF2uaPgqqgmQ2Hgvi98=;
	h=Date:To:From:Subject:From;
	b=VurmnLxEBD2MotHFQJREdG7nd7AtVovDcp+5HfpaXupVR8O+nQnIcl2zyITO/72yJ
	 qWdW48HQuvye+TTB16e+DEWEZRiaBQ6xZlVdckMYr8woLn87SydVT9+Jipi+SkAMtS
	 2cHCUAX3x8GFT64xPPAnUXG9b0F2052cqQiHUVCU=
Date: Fri, 29 Nov 2024 02:13:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,jsperbeck@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-declare-do_memsw_account-inline.patch added to mm-hotfixes-unstable branch
Message-Id: <20241129101334.D5B71C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: declare do_memsw_account inline
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-declare-do_memsw_account-inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-declare-do_memsw_account-inline.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: John Sperbeck <jsperbeck@google.com>
Subject: mm: memcg: declare do_memsw_account inline
Date: Thu, 28 Nov 2024 12:39:59 -0800

In commit 66d60c428b23 ("mm: memcg: move legacy memcg event code into
memcontrol-v1.c"), the static do_memsw_account() function was moved from a
.c file to a .h file.  Unfortunately, the traditional inline keyword
wasn't added.  If a file (e.g., a unit test) includes the .h file, but
doesn't refer to do_memsw_account(), it will get a warning like:

mm/memcontrol-v1.h:41:13: warning: unused function 'do_memsw_account' [-Wunused-function]
   41 | static bool do_memsw_account(void)
      |             ^~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241128203959.726527-1-jsperbeck@google.com
Fixes: 66d60c428b23 ("mm: memcg: move legacy memcg event code into memcontrol-v1.c")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol-v1.h~mm-memcg-declare-do_memsw_account-inline
+++ a/mm/memcontrol-v1.h
@@ -38,7 +38,7 @@ void mem_cgroup_id_put_many(struct mem_c
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
 /* Whether legacy memory+swap accounting is active */
-static bool do_memsw_account(void)
+static inline bool do_memsw_account(void)
 {
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
 }
_

Patches currently in -mm which might be from jsperbeck@google.com are

mm-memcg-declare-do_memsw_account-inline.patch

