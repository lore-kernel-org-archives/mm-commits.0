Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9A1FE47B
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 20:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750883055; cv=none; b=O4Z31OpwXUxVyO1XBxZIIl3Jjm4FQdPEVHmZU9XSs8KDEUW3i4kbweYyoEDw1qWFs9BwdcA31o5PSGTt0s2PT1tGx8QdtD+uTu6cM7gzuzwsGmtLovqk/Gd766XfU4sMLRfMV4gP6cMeUGvcT7FXgtQZAIzJ+fg7clvXKjU7Hc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750883055; c=relaxed/simple;
	bh=GuATBZg7cAnH3YMlwnqw/A6tszPVEw6uuHIOElvEgJ4=;
	h=Date:To:From:Subject:Message-Id; b=MHMEpRfwYeR574klpx0PMcSNrHmt8pOCvbzSfsDcrvm6fgyo4mbLme4+qdo7zrJ4s3Voo1TM5jVqiQkeoQkc9I57PyLfG5FLpbwDVDLy/4apkek9cZI/Vyfg3/ZX8rcQTM1EzLZWt4uIUKq5p85EBYxvkxdbX9jz1iwYcQzANGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2dQ2U//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2dQ2U//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62508C4CEEA;
	Wed, 25 Jun 2025 20:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750883054;
	bh=GuATBZg7cAnH3YMlwnqw/A6tszPVEw6uuHIOElvEgJ4=;
	h=Date:To:From:Subject:From;
	b=N2dQ2U//nD69lB7UGMKK2ztELSUDFL6eSipnPd9yUcakCDus+rwL3/rujyZzE9DTQ
	 ynAJxeCcFG45jpSiwbEMl720yh71v+G9WFMqgRP3hMkeCf+lsXmqcRjSuBSeFJ8wN8
	 WwY9mLSiWaRxFn44086SUu2aZ63trD6dKyAi5hsA=
Date: Wed, 25 Jun 2025 13:24:15 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lkp@intel.com,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-make-memoryreclaim-interface-generic-fix.patch added to mm-unstable branch
Message-Id: <20250625202414.62508C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-make-memoryreclaim-interface-generic-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-make-memoryreclaim-interface-generic-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-make-memoryreclaim-interface-generic-fix.patch

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
Subject: mm-memcg-make-memoryreclaim-interface-generic-fix
Date: Tue Jun 24 02:08:06 PM PDT 2025

fix CONFIG_NUMA=n build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506250208.ZOcoZLb6-lkp@intel.com/
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/internal.h~mm-memcg-make-memoryreclaim-interface-generic-fix
+++ a/mm/internal.h
@@ -516,8 +516,16 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+#ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
+#else
+static inline int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat)
+{
+	return 0;
+}
+#endif
 
 /*
  * in mm/rmap.c:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

