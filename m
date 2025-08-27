Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AF61F7580
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756265786; cv=none; b=TeMae7mpb89cn/CiI5I42lbcvjVu4XBbVPMtbhjlVPvgjGnTcwnfccYggwN3xH1aOYKTcSqjkjTae2uv76gZWc8v5X7ZNfchthxLsYNY80m4swTzp/IH0fKe2e9pUMr2RgR78QAZf+KFsPUwNpJVWq0d6CSDdRhBLGKxlCU7uB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756265786; c=relaxed/simple;
	bh=q+42ZWeXcEeLPTl3P9FEfuWmdqceknFkSR3p/BhMYEk=;
	h=Date:To:From:Subject:Message-Id; b=fJFSoavDoDa8tfJf4V6inO99QbUPKsMQnDgjAHr/1DptP7W0YJW0+W/mDB3HR2DtzW6LvzGOGcaAP+bMlJeahXguYw38VhXLGKUiTyPssYjZ5ZfESbt0zKUYkCL+fEyi5sLtzw8k5g68UGzT008r0Vsd9WuLGg5xtqHwFpUUJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGdcJTk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGdcJTk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D959CC4CEEB;
	Wed, 27 Aug 2025 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756265785;
	bh=q+42ZWeXcEeLPTl3P9FEfuWmdqceknFkSR3p/BhMYEk=;
	h=Date:To:From:Subject:From;
	b=HGdcJTk1Skh0ULrSo7QzC1K2CG+FK1SrXpU8vB4q/d1g6PvhT40mj45KuhW/tRs4X
	 PRFDSGX95B7cbyC3yPNLzzGjcJ+OZULZ8xSjyYhJ0uKenRIuD76cQJJ/KYG/3h7QZj
	 8LDkM5FY38KR0WRcCXhlHQVxKgTbDrf5F22TCKlM=
Date: Tue, 26 Aug 2025 20:36:25 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lkp@intel.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch added to mm-new branch
Message-Id: <20250827033625.D959CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
has been added to the -mm mm-new branch.  Its filename is
     revert-hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
Date: Tue, 26 Aug 2025 11:09:55 +0800

Commit f8142cf94d47 ("hugetlb: make hugetlb depends on SYSFS or SYSCTL")
added dependency on SYSFS or SYSCTL but hugetlb can be used without SYSFS
or SYSCTL.  So this dependency is wrong and should be removed.

This reverts commit f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b.

Link: https://lkml.kernel.org/r/20250826030955.2898709-1-linmiaohe@huawei.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508222032.bwJsQPZ1-lkp@intel.com/
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/Kconfig~revert-hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl
+++ a/fs/Kconfig
@@ -250,7 +250,6 @@ config ARCH_SUPPORTS_HUGETLBFS
 menuconfig HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on ARCH_SUPPORTS_HUGETLBFS
-	depends on (SYSFS || SYSCTL)
 	select MEMFD_CREATE
 	select PADATA if SMP
 	help
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

revert-hugetlb-make-hugetlb-depends-on-sysfs-or-sysctl.patch

