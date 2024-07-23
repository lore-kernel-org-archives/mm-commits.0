Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E313B58D
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721771128; cv=none; b=r2s6vWQJH/eMuDGylyLRNp7KxKu1N0LW14Klo3AfKJwOxUXuztS2tta59YUToLdu9Hv7hD/xS+er2dy8Fxf3iOy1fM4MZgeG498Nyz5nEffS7G0bn1nX2v7uTEiuW99I7fMaApZiM4pUAUq7dHdg6hpGIRKvNRDoJWUHa33XwPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721771128; c=relaxed/simple;
	bh=bBwn2QrxdwUi1dH957EqbE5HDofdxQcd0REs3nAJmE4=;
	h=Date:To:From:Subject:Message-Id; b=hxY8rlWYADmgpq5Gc/tqovT67OL/5nLdho0auQQ0z+au6aTOsUBmRCG/uIBZNlMm4nRJwpLjWwVDozv85iN7XZrtMVC3sJo7XwXkewP1uiD1cYvSRDvwWuRFeemPyWbU+AYbKfKClS6Esyu0TH53WOVp0TtMjmesX1Q6fd+5jX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GSik7His; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GSik7His"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5F1C4AF09;
	Tue, 23 Jul 2024 21:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721771128;
	bh=bBwn2QrxdwUi1dH957EqbE5HDofdxQcd0REs3nAJmE4=;
	h=Date:To:From:Subject:From;
	b=GSik7HisswuKsn8XIJx08Zt9Pm3XrYATTozeCmmLkHfIucWX0VM8poRmx9Nv4k5nF
	 ynRMMwEad6Gzvc+sBaMj1vOS9gU57HkKLrQ/TIXXCZRPhYLZ2VYf2atpn8DEaC2S2L
	 PqhaWAhKSXC929VZvCpRi65ilMRTZHoBC+A2cDL0=
Date: Tue, 23 Jul 2024 14:45:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,lkp@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-introduce-folio_has_cpupid-check-fix.patch added to mm-unstable branch
Message-Id: <20240723214528.2E5F1C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory-tiering-introduce-folio_has_cpupid-check-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-introduce-folio_has_cpupid-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-introduce-folio_has_cpupid-check-fix.patch

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
Subject: memory-tiering-introduce-folio_has_cpupid-check-fix
Date: Tue Jul 23 02:41:36 PM PDT 2024

fix build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407240024.Lhu1XDok-lkp@intel.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-tiers.c~memory-tiering-introduce-folio_has_cpupid-check-fix
+++ a/mm/memory-tiers.c
@@ -51,6 +51,7 @@ static const struct bus_type memory_tier
 	.dev_name = "memory_tier",
 };
 
+#ifdef CONFIG_NUMA_BALANCING
 /**
  * folio_has_cpupid - check if a folio has cpupid information
  * @folio: folio to check
@@ -66,6 +67,7 @@ bool folio_has_cpupid(struct folio *foli
 	return !(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) ||
 	       node_is_toptier(folio_nid(folio));
 }
+#endif
 
 #ifdef CONFIG_MIGRATION
 static int top_tier_adistance;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-tiering-introduce-folio_has_cpupid-check-fix.patch

