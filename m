Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE03563D8
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769015423; cv=none; b=gruba5+DTNuFjeubfAbQ33Ea5bbc+L3sMcI536AKmlni7tezmEMDV7rxK0Gt6+R2P2lEjO7SpowyLTUx3bAygA8V4tJdkAf7jUQPEqxbmjVbk9jklpxuYFsc+OHK40j67D8Gh37W+seeCfajpvivpV41DikR4F19v87Zr9UMX5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769015423; c=relaxed/simple;
	bh=e3b2+y0lG+frlyqMDUodeWbLimwnRF5jfuFlxn84vBA=;
	h=Date:To:From:Subject:Message-Id; b=axEbXIrFT8Ix1ue7pWGv64Qqh2WvtSDYMqgW6qdpiGpVWU83vtL4RnhhuE9UJBunTrPLEx+JwPsRQDfB5yrE+IIr292n7yngp2H2ACGUN/G4ybb2kUeikg0pkD4IR5WDApVgU1z0j819Kct74PBFlBMntzqzwk5q1Sa+I1T/z0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/vxEFgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/vxEFgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D5FC4CEF1;
	Wed, 21 Jan 2026 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769015423;
	bh=e3b2+y0lG+frlyqMDUodeWbLimwnRF5jfuFlxn84vBA=;
	h=Date:To:From:Subject:From;
	b=E/vxEFgY3JlQDMUN0E4dsqJZdCwmNvdolRgjp8jgJPlPXhLUuekJMzJf4leTK3MUx
	 3RMoQ6e5RSe+K61Ty19ewIXehaeEvMBeAsxO6/t0cChwTL6hwU2Q9SQmxs/C+VGCBw
	 A37+GRX4Zul9STXfj3rjb0rkvJ3y+abhfU57Niq4=
Date: Wed, 21 Jan 2026 09:10:22 -0800
To: mm-commits@vger.kernel.org,kevin.brodsky@arm.com,andreas@gaisler.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch added to mm-unstable branch
Message-Id: <20260121171022.E8D5FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix
Date: Wed Jan 21 09:06:56 AM PST 2026

remove mm/tests/lazy_mmu_mode_kunit.c comment, per Kevin

Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/tests/lazy_mmu_mode_kunit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/tests/lazy_mmu_mode_kunit.c~sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,7 +2,6 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
-/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 
 static void expect_not_active(struct kunit *test)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

