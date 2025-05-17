Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D14A4B1E45
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747495917; cv=none; b=LncJfl7TOnP4GQj08Mcyi/GgfiZ/OYOhocnOOdh4EsN8RR4RNJyPzIKlq/KjK414X5ibt2e/JBlWnmkpO5FWIrXZarj8p8IRGnEDzIjjx+kXXLb8ulztW341zI1g4ST/9cm8NZVB7LonhSrnqVaB70DfIZyR+Rktv7vR/Py6AvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747495917; c=relaxed/simple;
	bh=D21maFLCuWIG819fA0YT3NFEHZic7/3L2yL8DBBjJi0=;
	h=Date:To:From:Subject:Message-Id; b=kRdOvHu1sOmhNebDQrjevglzH6PCZ8VrW7Hal7fowGBiu2YBgE/EXeSbMkYFct7bHCI1CWnregLWaVNKhmPQquA1GnTM/c+HtOOOgLCZQd/GQ0x41/NNP/3w9qMOxaPV4o92YLM/MljAMVR6sII1tDfrN3Sn3qfC8qAe/DP8BKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQ6CNN7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQ6CNN7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F51C4CEE3;
	Sat, 17 May 2025 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747495916;
	bh=D21maFLCuWIG819fA0YT3NFEHZic7/3L2yL8DBBjJi0=;
	h=Date:To:From:Subject:From;
	b=JQ6CNN7yLE/zzgJvTstrD/T500wXmeFt0LfFs6cJnKRrxGnyF4uSCAdELm5w8Vk7k
	 Z292HzbQKW3idXImnEi6RRKjvANgvGwmnM7qBusG+tG7vDQ001fIjAbBeaZ1Xna12S
	 hb1oumAqRPVluAntBCgJCTGNHd8BPnMzWAMtwbwc=
Date: Sat, 17 May 2025 08:31:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-memory-policy-section-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250517153156.A0F51C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: add Ying as reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-memory-policy-section-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-memory-policy-section-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: add Ying as reviewer
Date: Thu, 15 May 2025 20:23:27 +0100

Link: https://lkml.kernel.org/r/ed6f0fc2-5608-4eea-b1be-07e3e19be263@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mm-memory-policy-section-fix
+++ a/MAINTAINERS
@@ -15586,6 +15586,7 @@ R:	Joshua Hahn <joshua.hahnjy@gmail.com>
 R:	Rakie Kim <rakie.kim@sk.com>
 R:	Byungchul Park <byungchul@sk.com>
 R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-mm-ksm-section.patch
maintainers-add-mm-memory-policy-section.patch
maintainers-add-mm-memory-policy-section-fix.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

