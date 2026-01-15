Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F4523B61E
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768518516; cv=none; b=s5G5ADhAtpjXaTkgb2WiRu0PaSX6wIs0ld4Ij5tRLXWz9tElW6f3uXtZNLFn6Wl3A4LVxCFhjVnDscC/btqwI7GCvYxoAj5nc6hFLh6XQ7p5lxnOzc2GPZcvo+FHU1UImFySYxbTCj4hfT3Fph2QevdU47bRpVB9Y+7nRV7AF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768518516; c=relaxed/simple;
	bh=8/nytu1sm46Tn6Ah34Dno49JS/mLrf5JBbTgaiMldBo=;
	h=Date:To:From:Subject:Message-Id; b=NAFmLSOW9hWTPA1XeXmAqMvtFR+igvud9pHYdhcthlUJZS0IS8m282NYnMu52agyCHv9mEdQWD4r+T0Hnd4BQE400h5YINEO6G0eAahdepvu0J6X4dpMX3VGRmLq8cxyn9yaRSU4lsPU/1aaJscnQ/2sP4km98gslBfCnkzOl5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gEvDIoqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gEvDIoqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF3FC116D0;
	Thu, 15 Jan 2026 23:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768518516;
	bh=8/nytu1sm46Tn6Ah34Dno49JS/mLrf5JBbTgaiMldBo=;
	h=Date:To:From:Subject:From;
	b=gEvDIoqeT3UxmcuRQttccljMHDPcVlIyuNvAyV1prAA+c4Tqx/GXtJdePcY9nesLU
	 L6BNJ19Mj1uHMgvAHrXn3jJkHy/m7FXAWIe+Xhk/gN0TWXt9rsUsVyuY0+6Ginkdzn
	 kAkSICP+2+X+/UEBt8MzBOu7dBdBuhNRsqp7oI+Q=
Date: Thu, 15 Jan 2026 15:08:35 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,senozhatsky@chromium.org,richardycc@google.com,minchan@google.com,clm@meta.com,bgeffon@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fixup-read_block_state-fix.patch added to mm-unstable branch
Message-Id: <20260115230836.3CF3FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram-fixup-read_block_state-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fixup-read_block_state-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fixup-read_block_state-fix.patch

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
Subject: zram-fixup-read_block_state-fix
Date: Thu Jan 15 03:07:56 PM PST 2026

remove now-unused local `ts'

Cc: Brian Geffon <bgeffon@google.com>
Cc: Chris Mason <clm@meta.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fixup-read_block_state-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1570,7 +1570,6 @@ static ssize_t read_block_state(struct f
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct timespec64 ts;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
zram-fixup-read_block_state-fix.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

