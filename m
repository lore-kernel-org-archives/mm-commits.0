Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640AE7580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942892; cv=none; b=t0XtVv8UyWyWdxfUFiGW2SdWLWNGHdvuO6iL+OmEy/4R84dT5z5vYw65vvSEhC0odPzdDDLZIje37ypMJMuKmcXbjFym05Hi6pLRwDeM2Bg051j9Gd8JUr40y04I1S9FfDvizq5mq4Hv126sx0rodUqywp8KcV8BXiVy/Xi8y1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942892; c=relaxed/simple;
	bh=3PCENLPHaY9oRAEyKrO1ZwpY3YeQ13nlzjLk6mNej7Q=;
	h=Date:To:From:Subject:Message-Id; b=e7FdoTQ4QIrAhNxD0LetFohIg5OrOaWfLjk1r+AvRZy+3rC35w96zoIXRmGBa5me3fc+x+mZILmrYZaNybdmyVS/WVKo+E4vSC4yuY04OrMh7GqhbNBqXVxL9KqFjNqdP2mNdfKV4jdI4tAwgymYKQokteGgYjnrecPpFxeCNkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QsJ+FXG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QsJ+FXG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BC5C4AF66;
	Sun,  5 May 2024 21:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942891;
	bh=3PCENLPHaY9oRAEyKrO1ZwpY3YeQ13nlzjLk6mNej7Q=;
	h=Date:To:From:Subject:From;
	b=QsJ+FXG0EOgyrFgeJwnJga88pgFFTc8Vnx2dGB0WalPA6Q2zhXorNNaSOGB1BqBXS
	 LyK/UBDrHF3s/n8jS1mK6paNWPLvOwKsFo5O5fEhzx9wyojttIMRh87Cg9gsj9iUzU
	 r01VvCuiF4XRRiljnCH+DAddZzHVUbYF2uy1P++U=
Date: Sun, 05 May 2024 14:01:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,song@kernel.org,peterz@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-watchdog_perfc-tidy-up-kerneldoc.patch added to mm-nonmm-unstable branch
Message-Id: <20240505210131.C1BC5C4AF66@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/watchdog_perf.c: tidy up kerneldoc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-watchdog_perfc-tidy-up-kerneldoc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-watchdog_perfc-tidy-up-kerneldoc.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kernel/watchdog_perf.c: tidy up kerneldoc
Date: Sat May  4 04:41:07 PM PDT 2024

It is unconventional to have a blank line between name-of-function and
description-of-args.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/watchdog_perf.c~kernel-watchdog_perfc-tidy-up-kerneldoc
+++ a/kernel/watchdog_perf.c
@@ -148,7 +148,6 @@ static int hardlockup_detector_event_cre
 
 /**
  * watchdog_hardlockup_enable - Enable the local event
- *
  * @cpu: The CPU to enable hard lockup on.
  */
 void watchdog_hardlockup_enable(unsigned int cpu)
@@ -167,7 +166,6 @@ void watchdog_hardlockup_enable(unsigned
 
 /**
  * watchdog_hardlockup_disable - Disable the local event
- *
  * @cpu: The CPU to enable hard lockup on.
  */
 void watchdog_hardlockup_disable(unsigned int cpu)
@@ -277,7 +275,6 @@ int __init watchdog_hardlockup_probe(voi
 
 /**
  * hardlockup_config_perf_event - Overwrite config of wd_hw_attr.
- *
  * @str: number which identifies the raw perf event to use
  */
 void __init hardlockup_config_perf_event(const char *str)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch
kernel-watchdog_perfc-tidy-up-kerneldoc.patch

