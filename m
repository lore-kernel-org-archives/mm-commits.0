Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4057C1B81CA
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 23:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769296966; cv=none; b=MKiGpZGpn+ngNuScoO39RdOvbQ3RUra6A9EC+tLyc8rafTHxLTC9ljEGp1G9G8nEnpgPLx2YsVTfMTxCXExLxzLgaUmdDHoWbIoRSHBgRbG5TCuVV7Pij6gM2VaqxCvpp99ZOVdbWtDSAGb9PyRu1scThFBZqAlR1pDD2AKR1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769296966; c=relaxed/simple;
	bh=BGUzGVbcd/sOCl8pvzt0gUrKsNuvpdki1LoKbsaPDnA=;
	h=Date:To:From:Subject:Message-Id; b=TIv248BgnIaYIz/phBNiCUNA80p1rgBKVO+EfxufGKpLqgzGHPdmsWwhpxaCVv4M6V2Pr2Xw3h81vzwWsiKYEa+hIqS0NVrvbRRCs3yOB2rpEEnRVK6BCv1Q/XQ3A1Wk0eMVpTVgYYYhIrrj7lwlYAdbX8X50l8sS5BmHfbHmro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zwOW6RLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zwOW6RLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26DBC116D0;
	Sat, 24 Jan 2026 23:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769296965;
	bh=BGUzGVbcd/sOCl8pvzt0gUrKsNuvpdki1LoKbsaPDnA=;
	h=Date:To:From:Subject:From;
	b=zwOW6RLiPYUYRUm0EklGysz/RQPnzkyo6xP7rWfE0vJyC6rOVnMLLgR5PEhbPWj9v
	 sKnAVsyo23jF59ipD3pKKUm02N9fisu6BAWLEfmAyjVaKkWGvcbg/E6qAKY2ZpChki
	 w2jh/P1GS+Ya9o/ZdYRk1qaXENSHUqk04sa/k4Uw=
Date: Sat, 24 Jan 2026 15:22:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,marco.crivellari@suse.com,bigeasy@linutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch added to mm-unstable branch
Message-Id: <20260124232245.D26DBC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch

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
Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
Date: Sat Jan 24 03:20:32 PM PST 2026

fix kmem_cache_init_late() properly, per Sebastian

Cc: Marco Crivellari <marco.crivellari@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
+++ a/mm/slub.c
@@ -8542,11 +8542,9 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-#ifndef CONFIG_SLUB_TINY
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
-#endif
 }
 
 struct kmem_cache *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

