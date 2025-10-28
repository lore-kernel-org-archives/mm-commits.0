Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B9A330338
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 00:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761609631; cv=none; b=ATjRY1Hdelg/DQCQIJXWrXe3Z4z3fdVwriN1kpl6hf79ht0Bi3c9aPcfYkXsUc/IHATH0gtauPIKKg1K2+40tcfjW5mWIDtHxy9IaPOKVdeuXmAbHjLmrGWqi/tsh8soTO7rTomR6rB7bCGeCS3btEg0SZSKP77ku1bZw3NY1Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761609631; c=relaxed/simple;
	bh=s3qCCbRhr1hqvba/NiqECN0uRXjAghgzjDZZK94oEg4=;
	h=Date:To:From:Subject:Message-Id; b=RYFwlWAJWADtQwdyKSEVa4fm++GPu49K5dFwblCJN8CJsG69Eyp33emIG5HDPDPBxSlPsPLn4toP2hLdglDosjbs3MBFZg8oeWQd3az4NBnSlrS2yIUM5wq8sjVMpVveZE38/Xiz2KW2ncr+YFxqxpjJUG9mCaZyVLNlnq0PkQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cT1rlYth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cT1rlYth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E03DC116B1;
	Tue, 28 Oct 2025 00:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761609630;
	bh=s3qCCbRhr1hqvba/NiqECN0uRXjAghgzjDZZK94oEg4=;
	h=Date:To:From:Subject:From;
	b=cT1rlYthKvE9bDkju1rW1jfRHwx1V4AgCAdsajVh/1+nYs3mmqBLSKT1/Obk943Uc
	 rsGHjD1YtA6Uwg7GveaVCOjoREoNloNareY0QnOrceZf+1SU2QBp3ixFF6fasA2nBp
	 Adm5oBXKOPNSN4DeP7fwXN7YOkGOvZZ7j1H1Ki2k=
Date: Mon, 27 Oct 2025 17:00:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hch@infradead.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-manually-uninline-__memcg_memory_event-fix.patch added to mm-unstable branch
Message-Id: <20251028000030.9E03DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-manually-uninline-__memcg_memory_event-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-manually-uninline-__memcg_memory_event-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-manually-uninline-__memcg_memory_event-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-manually-uninline-__memcg_memory_event-fix
Date: Mon Oct 27 04:58:56 PM PDT 2025

use EXPORT_SYMBOL_GPL for __memcg_memory_event, per Michal and Christoph

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-manually-uninline-__memcg_memory_event-fix
+++ a/mm/memcontrol.c
@@ -1655,7 +1655,7 @@ void __memcg_memory_event(struct mem_cgr
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
 }
-EXPORT_SYMBOL(__memcg_memory_event);
+EXPORT_SYMBOL_GPL(__memcg_memory_event);
 
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch

