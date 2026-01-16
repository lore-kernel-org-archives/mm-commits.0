Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2312347BC1
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 06:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768545558; cv=none; b=CsDw1q817b6AFN+5EYADZHfseLhtASksum7RGo5rjRAepx7qsc9gP7bmUGXkR4wuoZasmFZDFq3+iKNZB1uvpdXs/WxF3G1Kgzof2H8CLNUBVvpfj0kzbB8KF7DET878qk6jKgWDi6Pcb3V84NrgxXj0fAlcWGsAE1dMa3zk8ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768545558; c=relaxed/simple;
	bh=uHqPBs67k304jvS15DRsENqBSyMFo4VpuDmEEPffI9E=;
	h=Date:To:From:Subject:Message-Id; b=nisivPqcQJij1PxKpsLx1Z2f92luYMrpokNKDsHC39sio7EHbAPGTCdK4DSO7uizj8lg5ElRtFUOjIFmqckUv4fTWoCk61x0P7TImStXOaIKyH8E0uOe+qWZfcW9BFbTMDZ5IUotXQK02AYxLGLl2dboq/DSwtdPkwxu43XFhl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j8SVp1Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8SVp1Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E04C116C6;
	Fri, 16 Jan 2026 06:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768545558;
	bh=uHqPBs67k304jvS15DRsENqBSyMFo4VpuDmEEPffI9E=;
	h=Date:To:From:Subject:From;
	b=j8SVp1TkLkKti6ImyQ5nELHFfm1dBxKZvNzQVMV7Sn4zukiKR8K1sC2r8Bm/d+pIN
	 /eCgRH//a6FR9wpq/+Jqlvw75h4FExtOgnLECQvZ6r1ws/k5Y6yvVIRHfjrXA2S6ph
	 FejRbbyTHNehSmIbLPLiu70M8MH9GgBQS2G1JN4w=
Date: Thu, 15 Jan 2026 22:39:17 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fixup-read_block_state-fix-2.patch added to mm-unstable branch
Message-Id: <20260116063918.32E04C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram-fixup-read_block_state-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fixup-read_block_state-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fixup-read_block_state-fix-2.patch

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
Subject: zram-fixup-read_block_state-fix-2
Date: Thu Jan 15 10:30:48 PM PST 2026

fix build

drivers/block/zram/zram_drv.c: In function 'read_block_state':
drivers/block/zram/zram_drv.c:1582:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'int' [-Werror=format=]
 1582 |                         "%12zd %12u.%06lu %c%c%c%c%c%c\n",
      |                                     ~~~~^
      |                                         |
      |                                         long unsigned int
      |                                     %06u
 1583 |                         index, zram->table[index].attr.ac_time, 0,
      |                                                                 ~
      |                                                                 |
      |                                                                 int

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fixup-read_block_state-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -1589,7 +1589,7 @@ static ssize_t read_block_state(struct f
 			goto next;
 
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
+			"%12zd %12u.%06d %c%c%c%c%c%c\n",
 			index, zram->table[index].attr.ac_time, 0,
 			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
zram-fixup-read_block_state-fix.patch
zram-fixup-read_block_state-fix-2.patch
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

