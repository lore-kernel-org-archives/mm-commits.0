Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304CC2C1595;
	Wed, 15 Apr 2026 01:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776215702; cv=none; b=cbeOhFvr1xU32mCeVXrEtyyGrbf3DtgC2bubCn8Prgp3t3quToECrGsG5MTvY1m1K1Fotz5JsoW56xjhifIJEc1Ecku4dQS7tshtmfx6veLR0/8tm2lGdOceFiNWO1lcSiSQbH+uaG05MHBJHz6YaWSP41saosvajZeS8nSdPL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776215702; c=relaxed/simple;
	bh=zN8meoFlbPFkB/1NvjW+rIGOo+gAkht+/oBYFBE0QXo=;
	h=Date:To:From:Subject:Message-Id; b=rjCbxgtE75eckCNErXBjiAuosjYaahLBTU+b5YPoOUmGphSokuDJVTW1DmNWR4l5IUm6uF8Ez+Nzvw/rQO13LALkhoLylhxwQ33MOaaFvpIKUjaAGWxcFihOGMkSnRSQXj3aOgVOVG91l6yRnJCpZJbDs/gbAHvzn8FS+hqqiMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ZVOaoJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ZVOaoJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61ABC19425;
	Wed, 15 Apr 2026 01:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776215701;
	bh=zN8meoFlbPFkB/1NvjW+rIGOo+gAkht+/oBYFBE0QXo=;
	h=Date:To:From:Subject:From;
	b=2ZVOaoJqZWYq4F0698dNDIopiFUaXIWoO3PD5WHPp235m8qfXWGrGMhg2mcO4K27Q
	 QIlz/ho0rlJVGDR7wbUUcpydkDb/mjzRO2W9/oSZY4jvyWBUL0XYf6mA+4TwrxrjMS
	 3OPA5fiJbaMIFVB2snqWHtKQgUGp2i7TnSz9ytVc=
Date: Tue, 14 Apr 2026 18:14:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,nueralspacetech@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-fix-double-unlock.patch added to mm-hotfixes-unstable branch
Message-Id: <20260415011500.E61ABC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: fix double unlock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate_device-fix-double-unlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-fix-double-unlock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sunny Patel <nueralspacetech@gmail.com>
Subject: mm/migrate_device: fix double unlock
Date: Tue, 14 Apr 2026 02:45:49 +0530

migrate_vma_collect_huge_pmd() calls spin_unlock(ptl) after
softleaf_entry_wait_on_locked(), which already releases the ptl.

Link: https://lkml.kernel.org/r/20260413211559.20969-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-double-unlock
+++ a/mm/migrate_device.c
@@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(
 
 		if (softleaf_is_migration(entry)) {
 			softleaf_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
 			return -EAGAIN;
 		}
 
_

Patches currently in -mm which might be from nueralspacetech@gmail.com are

mm-migrate_device-fix-double-unlock.patch

