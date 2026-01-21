Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3733A960C
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022085; cv=none; b=Xhitw/zQ2ai/OAJfgfZQfOrnyCsblMZWnI95TwwGF3nPhZW4l5s0RavjW/C8EUa4jINTp4xWq44JB4UgoP3m2DMG2TGDwGV1oD6qRDRovwiajM13wid7xs7dSNliLsr3PPq0cOBR1GHp08tPcLUCexlO5x6WDeTZ2s3MoGZ8SvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022085; c=relaxed/simple;
	bh=rm3g5mecbEpnjgMahoWyzYyJD8w98Pi0xI8ZIXbumSw=;
	h=Date:To:From:Subject:Message-Id; b=aO+pgV1xO4Jdkr0FsebHBAFBYqMlqnY8MNmiDkfTtGj+BihkwTf3b2+TVkQk8M+O+dtb0sOHQRcTzjej69STJ/lIfOlBQNfRqJSpsyTUrsk4Jb3SNqdwKDPDbnX/yJdU4fZnO+REYy6ug9cjsiIue8zr7/mkZ70tTGBGtEaH6P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7icDZWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7icDZWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576D4C19422;
	Wed, 21 Jan 2026 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769022084;
	bh=rm3g5mecbEpnjgMahoWyzYyJD8w98Pi0xI8ZIXbumSw=;
	h=Date:To:From:Subject:From;
	b=h7icDZWxkQ4cyLRO7UzbcEd4LtSdy8cUCQhWZZOuEaErhQO87EePdl+ZPF0n9AgOi
	 LML8c90cHeE7kv19mveSuVHmGUrBShGjmuBHCerosplxvAMrv7Hj2F7ibiHMwn0Qpr
	 4G0SHSeM08WZe0mJtJ7Mray0dt7igfmSQTfNLmAg=
Date: Wed, 21 Jan 2026 11:01:23 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch added to mm-unstable branch
Message-Id: <20260121190124.576D4C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-relocate-the-page-table-ceiling-and-floor-definitions-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch

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
Subject: mm-relocate-the-page-table-ceiling-and-floor-definitions-fix
Date: Wed Jan 21 10:58:00 AM PST 2026

remove stray newline, per SeongJae

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pgtable.h~mm-relocate-the-page-table-ceiling-and-floor-definitions-fix
+++ a/include/linux/pgtable.h
@@ -1660,7 +1660,6 @@ void arch_sync_kernel_mappings(unsigned
 #define FIRST_USER_ADDRESS	0UL
 #endif
 
-
 /*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

