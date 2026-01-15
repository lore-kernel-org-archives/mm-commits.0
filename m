Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B75A2D73BE
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496477; cv=none; b=S13FMTDQb/DVMumvXMAFz9wIc3Wq2+6lSDl22EQrkJV3WlyrxxXdpqxr3rGSN1qAbpXFxeNkOM6CrvwliyjMgvB2ejEGcV84l8PgQpt27lkc523HTUTaIn6tMYUi5WfRrGr913lJto+nRXrx7HmrvzUSszXw7oh0QL5z57sAVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496477; c=relaxed/simple;
	bh=tL5H3m4GdjQ4v+xwu5o5ozPE7K45bTWkhFJxP0D/fxs=;
	h=Date:To:From:Subject:Message-Id; b=eLUnd6HOMrccibLCVVitdOP/xqkCK0bat9hMYLoAa0cyM6qHnvPzCh8JNBQ9nTGFRciN9voNtkwnJKd/H0aX3Wkf3+8gq6CWP+/zszwQ/Wr7U2qSN1MEbBnC5vngImFKCucDqxX74K0erdcQNgyeYaoNPLtubqTJ/u1ZkgEOm/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mAXRM7FR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mAXRM7FR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6043C116D0;
	Thu, 15 Jan 2026 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768496477;
	bh=tL5H3m4GdjQ4v+xwu5o5ozPE7K45bTWkhFJxP0D/fxs=;
	h=Date:To:From:Subject:From;
	b=mAXRM7FRpuxEnBVgPGcBXRRKto+RhZgMm3m1UCMM0h8KH7+DoZLkoHpUGWR5kgS6N
	 gNfZF5zZUmxPZxuTH0bcOgZv2d/V41C8BaM68t5GYrCDzUZQAobjfJTSgL+bJbLoZF
	 FRtQGUCGNBkBqehBtI7WFsLSkiUlGRkqscZtfIZM=
Date: Thu, 15 Jan 2026 09:01:16 -0800
To: mm-commits@vger.kernel.org,pnina.feder@mobileye.com,pmladek@suse.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20260115170116.E6043C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

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
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

