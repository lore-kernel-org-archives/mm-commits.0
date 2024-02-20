Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DCD77655
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 19:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708455633; cv=none; b=QqSMm0ebrgEXKLqCR2FewvKFssLieA30hBtQCl7O/LNA6Jcpfd2ltZ07lNOZQyD3J3pMJbcFjWIfyLLKjXAOHj3sL7H9697eLDRMz1YDuM7AbCdnnaP1Zf9dmRRlJR1eK6aHnV+CQHNk9YHPnwYq3mK5FgmnDb5Cgt91RxvW+YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708455633; c=relaxed/simple;
	bh=brMezQNacijoDKPR1jbcDblF6DCBFIHEkdVWxR3R9Hc=;
	h=Date:To:From:Subject:Message-Id; b=Df3hP2sdeVE9ECu2E6FeyfMZB0rp11t4tLQRqzAbvcnyCB2mICORyXq9kReKTWdDn2ToRvbRMFNfjy8S+BvTrNus68qgPvLVaIGFYfvYCsAxMMRwyZb0NPFydRLSuZemLF8lvpCV0399iRnFv/I+sSSktBAIQFbcFmmmi80veNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vJmhtMJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vJmhtMJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A7AC433F1;
	Tue, 20 Feb 2024 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708455633;
	bh=brMezQNacijoDKPR1jbcDblF6DCBFIHEkdVWxR3R9Hc=;
	h=Date:To:From:Subject:From;
	b=vJmhtMJUZtBthl4ZAlzbN3AMffmoWruXEG7hJVwgKkm7BFoEOxQAF7VWEb9U216Tb
	 un48h0fq16ko7KM4FnIuGp50FoK/bspXT98GQMWpa8dBRDEbefY96KHyL2yMTDK08r
	 nlZPs/8nHV0L72GANOchrvTCjAbJYEc0a47BYoW0=
Date: Tue, 20 Feb 2024 11:00:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,mcgrof@kernel.org,da.gomez@samsung.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch added to mm-unstable branch
Message-Id: <20240220190033.36A7AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix
Date: Tue Feb 20 10:59:48 AM PST 2024

restore static storage for loop counter

Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix
+++ a/lib/test_xarray.c
@@ -728,7 +728,7 @@ static noinline void *test_get_entry(str
 {
 	XA_STATE(xas, xa, index);
 	void *p;
-	unsigned int loops = 0;
+	static unsigned int loops = 0;
 
 	rcu_read_lock();
 repeat:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

