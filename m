Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618622877DE
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100350; cv=none; b=MJVpWUEsjACAmkMzCYzRM+JZhLdsPbGO9nEjaJhAxxXahF4lmC+yv7apRF9M6VQV6kF0L+Y2oUnFdSe//T+b2wqeZ34C9VTART954jEeoaNNf2mG8Xp+CtlCKw5/kJlga3oyBOZU/FKLopP8QCvnUdVyqTDST4rWuzjHmV/9F+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100350; c=relaxed/simple;
	bh=9HRi+XBVqf48VzoQ4ah32Of0cnBd07bruHUKOL45dcw=;
	h=Date:To:From:Subject:Message-Id; b=mDJZIe2WqJDuBZnXyHXum6en80OgJSgSiKHjyRY7a6qqQjqS7v8M5ft0q5+/+Emr9hplG0J0T0KN5XgooHmgOU7yoptol6bmbSP0C/Oe2b9Weyd85htDaLNBJ2Nl8TSkX+6pUkNm00JIRJjjIeyOD13FAJhhA7SkPKCTwaEwqaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEQG5Jmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEQG5Jmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE57C4CEFB;
	Thu, 18 Dec 2025 23:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766100348;
	bh=9HRi+XBVqf48VzoQ4ah32Of0cnBd07bruHUKOL45dcw=;
	h=Date:To:From:Subject:From;
	b=xEQG5JmuDFL7V55N2tcfu/vkkqN8+VsPb9idAYSF8PTa9e457FNF+gv5JcxZAF4h+
	 pjYkbPw1M8h7Lo2qeMQoNVv0DuMimGAI6bD+heOpd/C7LNsRH3EOrKuQYNfmaHUVSd
	 tFs+XRO3ZYfcGR2jfRrmh5V5R7X1cPRds4IGBvsM=
Date: Thu, 18 Dec 2025 15:25:48 -0800
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,npiggin@gmail.com,martin.lau@linux.dev,lance.yang@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20251218232548.CAE57C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2.patch

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
From: Li RongQing <lirongqing@baidu.com>
Subject: watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2
Date: Thu, 18 Dec 2025 02:43:00 -0500

add a temp variable thresh_count
chang config to 0 in kernel/configs/debug.config 

Link: https://lkml.kernel.org/r/20251218074300.4080-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |    2 +-
 kernel/watchdog.c           |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/configs/debug.config~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2
+++ a/kernel/configs/debug.config
@@ -84,7 +84,7 @@ CONFIG_SLUB_DEBUG_ON=y
 # Debug Oops, Lockups and Hangs
 #
 CONFIG_BOOTPARAM_HUNG_TASK_PANIC=0
-# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=0
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_PANIC_ON_OOPS=y
--- a/kernel/watchdog.c~watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2
+++ a/kernel/watchdog.c
@@ -774,8 +774,8 @@ static enum hrtimer_restart watchdog_tim
 {
 	unsigned long touch_ts, period_ts, now;
 	struct pt_regs *regs = get_irq_regs();
-	int duration;
 	int softlockup_all_cpu_backtrace;
+	int duration, thresh_count;
 	unsigned long flags;
 
 	if (!watchdog_enabled)
@@ -879,9 +879,9 @@ static enum hrtimer_restart watchdog_tim
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		sys_info(softlockup_si_mask & ~SYS_INFO_ALL_BT);
-		duration = duration / get_softlockup_thresh();
+		thresh_count = duration / get_softlockup_thresh();
 
-		if (softlockup_panic && duration >= softlockup_panic)
+		if (softlockup_panic && thresh_count >= softlockup_panic)
 			panic("softlockup: hung tasks");
 	}
 
_

Patches currently in -mm which might be from lirongqing@baidu.com are

watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds.patch
watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2.patch

