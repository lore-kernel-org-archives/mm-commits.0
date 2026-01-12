Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B079032B9A2
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768248862; cv=none; b=owBPaoo7jov8cS3VvKBjV+A2Gw3ZoZZ2vwl4cr3ZedmEECZfHGTzt1lLhf/m1EVfcoljOGN8cjmlSr9gq2dasjTTc3bhPVmGDrM+PQkSghYLA6l2O0qFumWg4mSdbHxjDWxTp6j/NYkJmppKX6qjfVq+yC0ymQ7TUkkPqFFpvkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768248862; c=relaxed/simple;
	bh=an4rvjj2GiFGbNw0tJI4LjDTNybFL9eL5wb6ikaoAhA=;
	h=Date:To:From:Subject:Message-Id; b=dZilzO4ugHSbZus5zJW/l3Qeu8CvGT2AT0rJZwhwY3ux0MYPkp7MRoXLmpZoVyGqL1Ktp3WGGSJbiUF4D5NOEFlZbtN7S6eiH2Vy/Mn2hVp7WSR1H3PiYZpw0mGa6tGnKLsC2cMk2d7yfFc8+febydNMOmuokBucXWMf4AILBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZdeLE2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZdeLE2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF45C16AAE;
	Mon, 12 Jan 2026 20:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768248862;
	bh=an4rvjj2GiFGbNw0tJI4LjDTNybFL9eL5wb6ikaoAhA=;
	h=Date:To:From:Subject:From;
	b=FZdeLE2NtEB9ZMxa/WPWG9ECJlLFhl1mWTMPoRd01m6IaJHzM3K5CvjubvaMj/z7Y
	 24DczOO0TeMkdLwAMRLOxULKcDIeYcQviE75KuwxAx11aCvgS540lcYKhcJKbymTaw
	 dpu+xjCR8i39wzVvzZeGpeUVfLF8JD1AAxdDyza8=
Date: Mon, 12 Jan 2026 12:14:21 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@kernel.org,rppt@kernel.org,mingo@kernel.org,link@vivo.com,lillian@star-ark.net,kernel@pengutronix.de,guoweikang.kernel@gmail.com,francesco@valla.it,dianders@chromium.org,chenhuacai@kernel.org,alexander.shishkin@linux.intel.com,a.fatoum@pengutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260112201422.3AF45C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix
Date: Mon Jan 12 12:11:32 PM PST 2026

move ramdisk_execute_command_set into __initdata

Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huan Yang <link@vivo.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lillian Berry <lillian@star-ark.net>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix
+++ a/init/main.c
@@ -162,7 +162,7 @@ static size_t initargs_offs;
 
 static char *execute_command;
 static char *ramdisk_execute_command = "/init";
-static bool ramdisk_execute_command_set;
+static bool __initdata ramdisk_execute_command_set;
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

