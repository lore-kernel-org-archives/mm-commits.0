Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B5C345CCE;
	Thu,  6 Nov 2025 23:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762473031; cv=none; b=WjQWsyom7K3bRtniHT+fQgG082kC4rNNUBUqtlisB5N5zQwfc2ROX4q4JyLDueDtyZjJpf5b1o0svNAuQhnq8SMBNST/WCJ+lpM873RpD1QHC0/4vsWNK0tFOkJhELtUSLJoWypjYBA1YYb/Jn3bUXQ9yrUKOhFzWMXqABD/hTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762473031; c=relaxed/simple;
	bh=xBC6Hnm4q12qpMgYKu6iarDHwId//8HRoDyOwlnD8Go=;
	h=Date:To:From:Subject:Message-Id; b=NX/Qu/Bmf/L/HZDw8TZ6ywxFhH/Wz0/nedBiyicXlkF58o39v+cJBnj1f3crG7HVChkqT4WxDl2Y29UqC4UoPaJBKf5rqoPls0GRuYZmjSBZ7eaPgfYy40fgeJilBUQivGDYk1zxAvFA5nyzRyGGtVNgYp7Frxa+2mb8BZWawqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WnLGc7xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WnLGc7xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FB0C19422;
	Thu,  6 Nov 2025 23:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762473030;
	bh=xBC6Hnm4q12qpMgYKu6iarDHwId//8HRoDyOwlnD8Go=;
	h=Date:To:From:Subject:From;
	b=WnLGc7xhqWI2jUCCQiH00K3HSRkOKozaUg+6NAAtVR8c2R03QPBZptalC4vayhPw+
	 gw+KUWJoWvzpdPorQWXcXhfj8PTPyBvGaPgD9TtZEb2tUtP0MH9AcClqGUsURDC+BK
	 +21/rxev6WPixBFcw2FtBGq9xh1sfsCp8xJvmiWg=
Date: Thu, 06 Nov 2025 15:50:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,oliver.sang@intel.com,graf@amazon.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_kho-check-if-kho-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20251106235030.82FB0C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_kho: check if KHO is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-test_kho-check-if-kho-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_kho-check-if-kho-is-enabled.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: lib/test_kho: check if KHO is enabled
Date: Thu, 6 Nov 2025 17:06:35 -0500

We must check whether KHO is enabled prior to issuing KHO commands,
otherwise KHO internal data structures are not initialized.

Link: https://lkml.kernel.org/r/20251106220635.2608494-1-pasha.tatashin@soleen.com
Fixes: b753522bed0b ("kho: add test for kexec handover")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.com
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/test_kho.c~lib-test_kho-check-if-kho-is-enabled
+++ a/lib/test_kho.c
@@ -301,6 +301,9 @@ static int __init kho_test_init(void)
 	phys_addr_t fdt_phys;
 	int err;
 
+	if (!kho_is_enabled())
+		return 0;
+
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
 	if (!err)
 		return kho_test_restore(fdt_phys);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area.patch
liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix-2.patch
liveupdate-kho-increase-metadata-bitmap-size-to-page_size.patch
liveupdate-kho-allocate-metadata-directly-from-the-buddy-allocator.patch
lib-test_kho-check-if-kho-is-enabled.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
maintainers-update-kho-maintainers.patch

