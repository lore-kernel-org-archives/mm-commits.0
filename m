Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567233971F
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 17:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929999; cv=none; b=EIaYgYcgK0YHXTwqKRfz+avFyET04b2krHNF/ogl793q8U5Y17+46TNTEtHjcS3dTsqjDW0f56HVa+fakeGwFCx+Q3OVgx+99VFJNZ8+hlbXHaQWWzUsQh/dVMgVL/UpT/EexseAXMF7ZqJbTO68uE1gRbSvJHdee4ho4G9LXGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929999; c=relaxed/simple;
	bh=btFyWbGaNh94pPWnVAVlvsfvG4AAZeHtnNDeyCyLKRU=;
	h=Date:To:From:Subject:Message-Id; b=INVhdNXVweIqUacknCMSUDTzvbzh0Yk6IMrupjNn1rmaintbWyXLBit1A7o/BtEoqGbG/pZ4ANiorXhkZDPE8a0HzkuZC1A4qo4OnN90IMSNlrXgowbQCJu2NnvuPzPrllpz1oF80vcl0Ky5ZL9s7Eaqwn5PcIG4sksO5S7fTuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFUFgqqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFUFgqqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0987FC16AAE;
	Tue, 20 Jan 2026 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768929999;
	bh=btFyWbGaNh94pPWnVAVlvsfvG4AAZeHtnNDeyCyLKRU=;
	h=Date:To:From:Subject:From;
	b=IFUFgqqiFgVaoOgelWVFLSWzCf13moSaPr1qMgSXY+bki1iEW9HC5hzgbNUtriJyT
	 M3NYFQLU9hPH9YITAXQO6KP+T2fnBbsfaW/lfCbeVGnP2TNAHq8O3589/XlWPYnG4l
	 Wf9TiWZEFaAnCUMA04zVApuJETef8pJYH7UfEhHo=
Date: Tue, 20 Jan 2026 09:26:38 -0800
To: mm-commits@vger.kernel.org,pnina.feder@mobileye.com,pmladek@suse.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20260120172639.0987FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

This patch was dropped because it was folded into panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes
Date: Thu Jan 15 09:00:36 AM PST 2026

WARNING: braces {} are not necessary for single statement blocks
#168: FILE: kernel/panic.c:383:
+	if (panic_in_progress()) {
+		return false;
+	}

total: 0 errors, 1 warnings, 191 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Petr Mladek <pmladek@suse.com>
Cc: Pnina Feder <pnina.feder@mobileye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/panic.c~panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes
+++ a/kernel/panic.c
@@ -380,9 +380,8 @@ static bool panic_try_force_cpu(char *bu
 		return false;
 
 	/* Another panic already in progress */
-	if (panic_in_progress()) {
+	if (panic_in_progress())
 		return false;
-	}
 
 	/*
 	 * Only one CPU can do the redirect. Use atomic cmpxchg to ensure
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
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu.patch

