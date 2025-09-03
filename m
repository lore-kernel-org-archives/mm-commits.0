Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AB62C187
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 03:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756869846; cv=none; b=Lg+vkN9aX6rn0gfXtgOXDPicvc1VlKvou3nuh6MGZlHsYLOMa/0UrK3cX1+GqTleVF6tgzfZZacoR/emJcNAAgcoPq3UR7agm/vmaqr6Xp/13M8w56P24j6t8uwdctbKumGYpPiA84mzvtta34vKqd3DgiNCvQMkA4ONjJU59ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756869846; c=relaxed/simple;
	bh=pbzFJam+q6GtwoJSIkzzsDZ/RKYqOA5/nG+VEb8djE8=;
	h=Date:To:From:Subject:Message-Id; b=AdsFPnL2v3yDacibEX6kWOON7TqTTM0rVzpOotNa0DaBq+Chp2LHuLKPqMow/DHyU4zOljrsvvA6aWEfMh6z4lIeeSFnER3jNUfcYt7hoIHDC7mJePbkwvRnqwaAE1UkwYY2BA/nzUvSujaXNngRxWQ9wA/5VJihTABIIkJ5SGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtUxdTmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtUxdTmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F92C4CEF0;
	Wed,  3 Sep 2025 03:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756869845;
	bh=pbzFJam+q6GtwoJSIkzzsDZ/RKYqOA5/nG+VEb8djE8=;
	h=Date:To:From:Subject:From;
	b=rtUxdTmcxYJqpcgFFewArD91VOnWxkI8CNq1u8Z70zEDO8hNbak66lOduJ/BQWUHf
	 3dYUj5d9UT6cSQpM5Gj8zgKODagDN9ZIt07SJm79WpKxFYPEY/0azZJ3S4POaxakiw
	 ZHF/UwcopFhxTpeZBSU1AZXz03JvU6sJd9ZXqv38=
Date: Tue, 02 Sep 2025 20:24:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,pyyjason@gmail.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-add-trylock-while-printing-alloc-info-fix.patch added to mm-new branch
Message-Id: <20250903032405.D5F92C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-show_mem-add-trylock-while-printing-alloc-info-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-add-trylock-while-printing-alloc-info-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-add-trylock-while-printing-alloc-info-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm-show_mem-add-trylock-while-printing-alloc-info-fix
Date: Tue Sep  2 08:22:40 PM PDT 2025

fix build with CONFIG_MEM_ALLOC_PROFILING=n

mm/show_mem.c: In function '__show_mem':
mm/show_mem.c:403:32: error: unused variable 'mem_alloc_profiling_spinlock' [-Werror=unused-variable]
  403 |         static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yueyang Pan <pyyjason@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/show_mem.c~mm-show_mem-add-trylock-while-printing-alloc-info-fix
+++ a/mm/show_mem.c
@@ -400,7 +400,9 @@ static void show_free_areas(unsigned int
 
 void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
+#ifdef CONFIG_MEM_ALLOC_PROFILING
 	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
+#endif
 	unsigned long total = 0, reserved = 0, highmem = 0;
 	struct zone *zone;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-show_mem-add-trylock-while-printing-alloc-info-fix.patch

