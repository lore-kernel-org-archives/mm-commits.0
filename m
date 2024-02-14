Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6605D732
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707932070; cv=none; b=MqygXZfASFO3PPbxm4GfmZ+xxbJjSIEAa50q2iz/PFbx54f7fAgSTHKSwe87+yAagjGMpA77HzCIK8Gx+l9zwDF4MEegyJfoVJFE6E+KQNueUegNMnP3YyiksubX1gMdRscRQB9uVikw6POIioPXnf4x68dmFiuklL8Yl3yThpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707932070; c=relaxed/simple;
	bh=WeyVK0XSGLWIlyq39P1ejkCCjFcfa8OJSnVzsQ30GH0=;
	h=Date:To:From:Subject:Message-Id; b=d5I5Mv8sV9Wt4+7CECsnwaZ53hZaDo/U03GAwj/njaoujjQgMBOraEErJByUDKMZ5XGIOg2gY4f2FyUpzNzHVnQN5GMlyT62k5LY5VK3bF9OjczKZvouYL9Jhbzg0YS+7ZLmFVTtOTb7dbWx31SXIiaLhKqWJKHCHArZ6rka35w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPb6k6pR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPb6k6pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FA3C433C7;
	Wed, 14 Feb 2024 17:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707932069;
	bh=WeyVK0XSGLWIlyq39P1ejkCCjFcfa8OJSnVzsQ30GH0=;
	h=Date:To:From:Subject:From;
	b=CPb6k6pRY7OFZFxM2mf1RrvSMc1D4pqd7f+0vxOQ2D1TTPWKL0dVWGxaQ4f80pi7n
	 fpUWGa0EoMcq8wPvmJW/ZUNvGA0j+vs7DaDu+xSKkIvXSkapMtxYFTwjt5SZa//c5K
	 U3znEq7bSTkBNA++b1G3j/tDNUNbb75S/9nDuYBI=
Date: Wed, 14 Feb 2024 09:34:29 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@suse.com,jonas@wielicki.name,debianlists@actiu.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240214173429.B3FA3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: clarify swapaccount=0 deprecation warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clarify swapaccount=0 deprecation warning
Date: Tue, 13 Feb 2024 03:16:34 -0500

The swapaccount deprecation warning is throwing false positives.  Since we
deprecated the knob and defaulted to enabling, the only reports we've been
getting are from folks that set swapaccount=1.  While this is a nice
affirmation that always-enabling was the right choice, we certainly don't
want to warn when users request the supported mode.

Only warn when disabling is requested, and clarify the warning.

Link: https://lkml.kernel.org/r/20240213081634.3652326-1-hannes@cmpxchg.org
Fixes: b25806dcd3d5 ("mm: memcontrol: deprecate swapaccounting=0 mode")
Cc: stable@vger.kernel.org
Reported-by: "Jonas Schäfer" <jonas@wielicki.name>
Reported-by: Narcis Garcia <debianlists@actiu.net>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-clarify-swapaccount=0-deprecation-warning
+++ a/mm/memcontrol.c
@@ -7971,9 +7971,13 @@ bool mem_cgroup_swap_full(struct folio *
 
 static int __init setup_swap_account(char *s)
 {
-	pr_warn_once("The swapaccount= commandline option is deprecated. "
-		     "Please report your usecase to linux-mm@kvack.org if you "
-		     "depend on this functionality.\n");
+	bool res;
+
+	if (!kstrtobool(s, &res) && !res)
+		pr_warn_once("The swapaccount=0 commdandline option is deprecated "
+			     "in favor of configuring swap control via cgroupfs. "
+			     "Please report your usecase to linux-mm@kvack.org if you "
+			     "depend on this functionality.\n");
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

