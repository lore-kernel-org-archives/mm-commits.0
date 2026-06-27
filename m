Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0562524BBFD
	for <mm-commits@vger.kernel.org>; Sat, 27 Jun 2026 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782523376; cv=none; b=X5iGHytB3l9Xat2wpQD1cD/9fecilEjOlZO5RnvdssIw7lz1iz0aZ8/ovetbjGTT+7L0jmdh13haxsb0csGmtwP65vMOtjlG8k4JjNyheQ15r7kfxQkJxVsLa1vAsqND9gqGXpYjuvwE6cqFM8rSB6/zzyiPwPJ6Yh0kror52sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782523376; c=relaxed/simple;
	bh=njPiOihsYurGr4H8iEiQtVBviE0ufmrz5MiZGxZFBCo=;
	h=Date:To:From:Subject:Message-Id; b=tHBb2wM3hac0DJ7EYeh4o+yQdKWHlhKURtLDy1Oi/iq15RxZehaY3sbA/M32dBsGaXx5XAShpXKLyzq0dwUqDtxshPajqQP0GeOKwiWHAGPehM4ZVuPecJnkA0jqf8gGR8BpXV5fds5UMw7tHBrywcmvI+xu+x1/zHCnCzOKvoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xpYlN2sd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xpYlN2sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DAB1F00A3F;
	Sat, 27 Jun 2026 01:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782523374;
	bh=0Olj1nNfLys0BDqB+INcd8OXZ/jwEXQTC3Cu+F46nQY=;
	h=Date:To:From:Subject;
	b=xpYlN2sdyW7i67+RXnSgfB14xyRmParDsWbxMWB07OkV3kpKZkAG45gDSJC3TMEku
	 RFsyKjrUYvCIWQgHByR7EWSjhVZ15g7HMIssDnGcpAOx1m3wDe6vUI/cUxHczbHhlz
	 LAGH5tI0tjwva5eW1323uG2Pt24Uqzr6SnUiR90k=
Date: Fri, 26 Jun 2026 18:22:53 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch added to mm-new branch
Message-Id: <20260627012254.63DAB1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: skip the remaining scan phases when interrupted
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

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
Subject: mm/kmemleak: skip the remaining scan phases when interrupted
Date: Fri, 26 Jun 2026 10:56:23 -0700

kmemleak_scan() scans the per-cpu sections, the struct page ranges and the
task stacks in sequence.  Each loop now bails out once scan_block()
reports the scan was interrupted, but the later phases are still entered
and only bail on their first scan_block() call.

Jump straight to the gray list scan once a phase reports an interrupted
scan, so the remaining scan phases are not entered at all.  This does not
change the scan results, it only avoids the pointless re-entry.

Link: https://lore.kernel.org/20260626-kmemleak_improve-v1-1-d40c7616f64f@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted
+++ a/mm/kmemleak.c
@@ -1850,6 +1850,7 @@ static void kmemleak_scan(void)
 	int __maybe_unused i;
 	struct xarray dedup;
 	int new_leaks = 0;
+	int stop = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1896,7 +1897,7 @@ static void kmemleak_scan(void)
 	for_each_possible_cpu(i) {
 		if (scan_large_block(__per_cpu_start + per_cpu_offset(i),
 				     __per_cpu_end + per_cpu_offset(i)))
-			break;
+			goto scan_gray;
 	}
 #endif
 
@@ -1908,7 +1909,6 @@ static void kmemleak_scan(void)
 		unsigned long start_pfn = zone->zone_start_pfn;
 		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
-		int stop = 0;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
@@ -1933,6 +1933,8 @@ static void kmemleak_scan(void)
 			break;
 	}
 	put_online_mems();
+	if (stop)
+		goto scan_gray;
 
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
@@ -1944,6 +1946,7 @@ static void kmemleak_scan(void)
 	 * Scan the objects already referenced from the sections scanned
 	 * above.
 	 */
+scan_gray:
 	scan_gray_list();
 
 	/*
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch

