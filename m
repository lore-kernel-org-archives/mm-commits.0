Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4F57082F
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 02:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766455788; cv=none; b=TltmjzzAc6SOaZjlJA/QeaKkGsPamTvc2ralDysPyZ1gDR2QjUe18vo5BSdasFCfkrcFNA2kFm+r2RyY2KDqVihBkxkjR/xjWfpjwUAP6O0rTSrLBOP7rRnQFlxEVcxYtgtstmuppEc9zXLXhA9y+JIrFdP5b85OVLEJlgCXswA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766455788; c=relaxed/simple;
	bh=toOnYb26EVv+QEy0Y/tlAIt/pXmM75N5Nhcb1nL6LlY=;
	h=Date:To:From:Subject:Message-Id; b=RHjBJK3b+PL0YFyojjN+O0HpUpufNK78kjF39tP46n5kc9qLgsOuF6rqJ+noKuhhxFVHeW2PmmqonOtWcRSRI766gTXsTbGlPC28eu25bh8/KANHqFkl5JoCyEAwtrFLI+blyFol+LZTllQt3AeD2tt5GhN4LMvFn69XHzGaxBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7kAHcIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7kAHcIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A34C4CEF1;
	Tue, 23 Dec 2025 02:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455788;
	bh=toOnYb26EVv+QEy0Y/tlAIt/pXmM75N5Nhcb1nL6LlY=;
	h=Date:To:From:Subject:From;
	b=v7kAHcIGAP3ZsgHK9vMK23EZ3VHSPm65rrzPhCz6CCkeIAgePvX/ZaIbOo9VjObiw
	 sZ7f2fv7NAbf8kb8K3Ny4GtH8gqutisY4RpIJL7UnPXFr47EvCdPWV0i75jEy5hoa7
	 jpfzjiDuiEfgWvZzMg1A2iCYjIT+Qb9WkOYWgpso=
Date: Mon, 22 Dec 2025 18:09:47 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,lkp@intel.com,kartikey406@gmail.com,hch@infradead.org,hannes@cmpxchg.org,axboe@kernel.dk,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-block-fs-remove-laptop_mode-fix.patch added to mm-unstable branch
Message-Id: <20251223020947.E3A34C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-block-fs-remove-laptop_mode-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-block-fs-remove-laptop_mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-block-fs-remove-laptop_mode-fix.patch

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
Subject: mm-block-fs-remove-laptop_mode-fix
Date: Mon Dec 22 06:06:52 PM PST 2025

fix Documentation/admin-guide/laptops/index.rst

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512212211.GvfwAGPP-lkp@intel.com/
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/laptops/index.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/admin-guide/laptops/index.rst~mm-block-fs-remove-laptop_mode-fix
+++ a/Documentation/admin-guide/laptops/index.rst
@@ -10,7 +10,6 @@ Laptop Drivers
    alienware-wmi
    asus-laptop
    disk-shock-protection
-   laptop-mode
    lg-laptop
    samsung-galaxybook
    sony-laptop
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch

