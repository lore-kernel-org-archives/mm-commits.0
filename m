Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2A7481A3
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 22:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lfrRqFh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D49C433C8;
	Wed, 27 Dec 2023 22:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703714688;
	bh=rYPrOGyGeGlUTjwDRXkSV7lnjifTc4naAiXSWy5kP9U=;
	h=Date:To:From:Subject:From;
	b=lfrRqFh4PlXoR5shZyNjDb8AJW+Uda40Qnklc+irq2ujJNuFF+ogoZXIS3hQubQO7
	 QLTs5JEFLoeEM+s1CQRvzrPs3JXS615WyLDzojHduuHMZIDe06vkStZ7ibPB3EZC2L
	 PNleeZZpOjvO1IcMBZWT20dSyMDY0NiFkgB6KCf4=
Date: Wed, 27 Dec 2023 14:04:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,shy828301@gmail.com,shakeelb@google.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20231227220448.67D49C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix
Date: Wed Dec 27 02:03:52 PM PST 2023

fix comment, per Zi Yan

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix
+++ a/mm/memcontrol.c
@@ -7544,7 +7544,7 @@ void mem_cgroup_migrate(struct folio *ol
 	/* Transfer the charge and the css ref */
 	commit_charge(new, memcg);
 	/*
-	 * If the old folio a large folio and is in the split queue, it needs
+	 * If the old folio is a large folio and is in the split queue, it needs
 	 * to be removed from the split queue now, in case getting an incorrect
 	 * split queue in destroy_large_folio() after the memcg of the old folio
 	 * is cleared.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-split-queue-list-crash-when-large-folio-migration-fix.patch
maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
kasan-stop-leaking-stack-trace-handles-fix.patch

