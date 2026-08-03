Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A629D2D23A6
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 18:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785782985; cv=none; b=Nd+xzx2ka/L3C+N9gmBibiVSJaeZt+oNs/tzZBYQh0EW7xSZL5UqlM1aZDq668QLPhrIp8AVs2tVeZoqjIWaDsAgJJqK/QvBAfcymj4Qhh5DN0OrrufcySIfagy/3q/C522SB3Mde7JxK219buxXEyQkQKCPrIhOFwYjVMi7eWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785782985; c=relaxed/simple;
	bh=TZ5M6X43hP0lz1IhQcVQzuBi03bUnu8/V+2l+FTADWw=;
	h=Date:To:From:Subject:Message-Id; b=YWQqWeoyK3ntyU01zmdoG55XZhR2ebx8Y1tJKESdm+9tKT1+gm+V+yjtxvxMBiMGHnKdzl/KRTkEc1ruW7dVjLTSA4PP++WEDs/0IUcav7KD5XU7Uaa4+sta3wioTez4f0novm0a6flcNxI7wLCR/t0TLK1yyJyqyobJGoNn/cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0MAe77v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0MAe77v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCEF1F000E9;
	Mon,  3 Aug 2026 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785782984;
	bh=cSLWDdYgs0SUkiSNvzmCF+pwmwvzn10UuHe3KrAfqiw=;
	h=Date:To:From:Subject;
	b=I0MAe77vwE35SyeiOnGi7/bff9zdxKwKrr6vVlByMrwimVe3gnrrraQKGtDUuWX/V
	 3c8wvBjCBMzgaegaviGRiG1QhN2FSAtXP8P7xq1wWlqK1KKxWW99xudBSLL5DBIWFX
	 0Pd5z9wN2WuYPYEvE6cfhL7N8rAsxrcQ2kmTabsI=
Date: Mon, 03 Aug 2026 11:49:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch added to mm-new branch
Message-Id: <20260803184944.4BCEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: kmemleak: document the conditional min_unref_scans default
has been added to the -mm mm-new branch.  Its filename is
     documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Breno Leitao <leitao@debian.org>
Subject: Documentation: kmemleak: document the conditional min_unref_scans default
Date: Fri, 31 Jul 2026 03:13:05 -0700

min_unref_scans now defaults to 2 when CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and
CONFIG_DEBUG_KMEMLEAK_VERBOSE are both enabled, but the documentation
still states that the default is unconditionally 1.

Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-2-7b9689ac77cb@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmemleak.rst |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~documentation-kmemleak-document-the-conditional-min_unref_scans-default
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -198,11 +198,13 @@ systems, because of pointers temporarily
 stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
 the minimum age of an object to be reported as a memory leak.
 
-The ``min_unref_scans`` module parameter (default 1) requires an object to
-be seen unreferenced in that many consecutive scans before it is reported.
-Keeping it at 1 preserves the historical behaviour; higher values filter
-the transient false positives described above, at the cost of delaying
-genuine reports by up to that many scans. It can be set at boot with
+The ``min_unref_scans`` module parameter requires an object to be seen
+unreferenced in that many consecutive scans before it is reported. It
+defaults to 2 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
+periodic scan thread confirms a leak on its own, and to 1 otherwise. A
+value of 1 preserves the historical behaviour; higher values filter the
+transient false positives described above, at the cost of delaying genuine
+reports by up to that many scans. It can be set at boot with
 ``kmemleak.min_unref_scans=<n>`` or at run-time via
 ``/sys/module/kmemleak/parameters/min_unref_scans``.
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

