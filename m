Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073BA30FF1D
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966454; cv=none; b=T2MMo0LGlJvVZA6eJLUYbkjwrWl4zqtz5xJ48Sd+JZxIRUgCaiLjjwXGoUTdyYn4FqTvWyKq38S0VlXJa8TOkeg7mA58vfxgFjP+/wIGPQneOotOq9g33gAbYdkP0qB0Uv/F+NhZujfg+VEHp1BzZhTTw512jMUnQuLn1HMdPhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966454; c=relaxed/simple;
	bh=/P6eSHVGZuNwRarr4dMcC1gXABkkm7Y51VUQONOsjQI=;
	h=Date:To:From:Subject:Message-Id; b=F5DmcUNGWOk6DXH0FqpA2kkOA9glYzYfL+O7wHxEtrAWNAqCjqXZ556LUfZ82d3MHTyP55rJ8hXgArt4o/4TcRr4VDImY8pL41zUPdauUMd2oXO7TsJr/ugWyphkwOu8r/K4+nZOUYsr5QEQXDKjndlRb0RQrbA3f7NbZXf56ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eOa3C/oQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eOa3C/oQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0556C16AAE;
	Wed, 21 Jan 2026 03:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966452;
	bh=/P6eSHVGZuNwRarr4dMcC1gXABkkm7Y51VUQONOsjQI=;
	h=Date:To:From:Subject:From;
	b=eOa3C/oQ3ZA9EctqCCMc6l0D+pdbLXTZ4xG+X9EVc8dldnD+TQqgz/y3Dmxj/H6r3
	 TX1pHECYfuc1Rw/MJTh3xR0cxSvvqD0OIkq1DuaIv1MufBHId+sqgE17MVaxB0c6X4
	 Rdo4MZSZiH6YDWeee4WCboncJ6t0ikQZvRk5ning=
Date: Tue, 20 Jan 2026 19:34:12 -0800
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,npiggin@gmail.com,martin.lau@linux.dev,lance.yang@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,lirongqing@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2.patch removed from -mm tree
Message-Id: <20260121033412.D0556C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds-v2.patch

This patch was dropped because it was folded into watchdog-softlockup-panic-when-lockup-duration-exceeds-n-thresholds.patch

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

