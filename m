Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3719D3F9F2
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707426284; cv=none; b=F5Pjvgg83Emd17r2s3yoV4LLPjNBrb+aDblKg2MBIya6aBpPi8n7ag5oqB/IrIZnbVaUvLx6aWEMpU5D1xplMx+GkLLBGEiTPvtx4a76nwH3Y2m7nyLM31rHQIVtN+udYZZI9kOhxfeSlK0w9WaHN51DS96BGW0QDqSLi+7SC+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707426284; c=relaxed/simple;
	bh=E5fiAodMpSzkflZfr/rJMvETNq28mgWizFUfqyY5lto=;
	h=Date:To:From:Subject:Message-Id; b=c4cWCqjkcFj8tckOlMQKfnQtLjweuXici33C6xX6bwFPZB+mgaZ56mDseTwR2s4eRDMZZm5o95h3veQjB4MWGZd4Mw9lmx9gyjvtDtCGxqYTBj0cSXCgwe1wF/eSy+XxXTnyCU2Qq9KUVV8tnqyD0vltOwwRgwzieTpsQnTVhXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hyKdh/uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hyKdh/uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9633C433C7;
	Thu,  8 Feb 2024 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707426283;
	bh=E5fiAodMpSzkflZfr/rJMvETNq28mgWizFUfqyY5lto=;
	h=Date:To:From:Subject:From;
	b=hyKdh/uziaUJee1Tdh9rLI2lhypUdieBISWh5+w8VU3l+MWr8W8rloD9gbAt28bWn
	 IznbZ3s7kiSpkcKHxK2ca4kPUH4xKycjClSzIly12aLe6tijTwB5J2nuFjd0tOcvvY
	 SquOkDjc5qLrotIVo6u2tjZs1DmVo1mzEjqHZlQU=
Date: Thu, 08 Feb 2024 13:04:43 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-mm-and-memcg-entries.patch added to mm-unstable branch
Message-Id: <20240208210443.C9633C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update mm and memcg entries
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-update-mm-and-memcg-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-mm-and-memcg-entries.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: MAINTAINERS: update mm and memcg entries
Date: Thu, 8 Feb 2024 07:57:27 +0200

Add F: lines for memory management and memory cgroup include files.

Link: https://lkml.kernel.org/r/20240208055727.142387-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-update-mm-and-memcg-entries
+++ a/MAINTAINERS
@@ -5383,6 +5383,7 @@ R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/memcontrol.h
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
@@ -14097,15 +14098,24 @@ T:	git git://git.kernel.org/pub/scm/linu
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
+F:	include/linux/memfd.h
+F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
+F:	include/linux/memory-tiers.h
+F:	include/linux/mempolicy.h
+F:	include/linux/mempool.h
+F:	include/linux/memremap.h
 F:	include/linux/mm.h
+F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
+F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/rmap.h
 F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
 F:	tools/testing/selftests/mm/
+N:	include/linux/page[-_]*
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-update-mm-and-memcg-entries.patch

