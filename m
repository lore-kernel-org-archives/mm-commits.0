Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E69733D4E8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671959; cv=none; b=Qo3wrZh+RWbakXG3XlZbbv1yI9HeVzh4eumNFz7Qf1KDN2ilJxErFKy1qy4FLw1B9+eZcZWB/9LPP1PCG0jaXpf5eShcEKPFFG7G2t/eeFQMUm9NJwbz+b5fIVYLkYjq1tR5Tmr3LRzxS73OLNjZWv1lPEtu62u2z9Vdx2juotQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671959; c=relaxed/simple;
	bh=C3z8P799n1Zxhj68rxLwC6KGNpWnU/idkNm750VEnLY=;
	h=Date:To:From:Subject:Message-Id; b=grX5RVpdVFX/C4sRp/xg64uiiPo1WCKQ+JmEgwGOyIN+8nJ02POXUaL8o4gxjf5HevfMNUhcEzJh1u35Muti9jGSXh8PoYGUFw5l0f36IStW6iO0JuT2BkyO/9yuaTr9YBqrMjwxHpHsp4Y3l2bPGRqyve10QB+R/njj7dOtO+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0u3nPjfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0u3nPjfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CEC4CEF7;
	Sat, 28 Mar 2026 04:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671959;
	bh=C3z8P799n1Zxhj68rxLwC6KGNpWnU/idkNm750VEnLY=;
	h=Date:To:From:Subject:From;
	b=0u3nPjfCq//yHKic+2onFJni3j7zwUMBNF/KbT7yzRtwu4GXfKsqeY4vLtc8dv5cs
	 xEzAy7/1DrOBT+NByWaJTeaaHjZLa0fZcjNGX6Ze3yefbDfcuwOHhMD4mQjj8Oxzt2
	 b4VBQ6g/4c8kL8pIrxM+kgcDgwGPdMtes4tZQFGI=
Date: Fri, 27 Mar 2026 21:25:58 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,skhan@linuxfoundation.org,pmladek@suse.com,max.kellermann@ionos.com,lihuafei1@huawei.com,irogers@google.com,eranian@google.com,dianders@chromium.org,cuiyunhui@bytedance.com,corbet@lwn.net,mrungta@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-update-saved-interrupts-during-check.patch removed from -mm tree
Message-Id: <20260328042558.E17CEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: update saved interrupts during check
has been removed from the -mm tree.  Its filename was
     watchdog-update-saved-interrupts-during-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mayank Rungta <mrungta@google.com>
Subject: watchdog: update saved interrupts during check
Date: Thu, 12 Mar 2026 16:22:03 -0700

Currently, arch_touch_nmi_watchdog() causes an early return that skips
updating hrtimer_interrupts_saved.  This leads to stale comparisons and
delayed lockup detection.

I found this issue because in our system the serial console is fairly
chatty.  For example, the 8250 console driver frequently calls
touch_nmi_watchdog() via console_write().  If a CPU locks up after a timer
interrupt but before next watchdog check, we see the following sequence:

  * watchdog_hardlockup_check() saves counter (e.g., 1000)
  * Timer runs and updates the counter (1001)
  * touch_nmi_watchdog() is called
  * CPU locks up
  * 10s pass: check() notices touch, returns early, skips update
  * 10s pass: check() saves counter (1001)
  * 10s pass: check() finally detects lockup

This delays detection to 30 seconds.  With this fix, we detect the lockup
in 20 seconds.

Link: https://lkml.kernel.org/r/20260312-hardlockup-watchdog-fixes-v2-2-45bd8a0cc7ed@google.com
Signed-off-by: Mayank Rungta <mrungta@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Stephane Erainan <eranian@google.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/kernel/watchdog.c~watchdog-update-saved-interrupts-during-check
+++ a/kernel/watchdog.c
@@ -159,21 +159,28 @@ void watchdog_hardlockup_touch_cpu(unsig
 	per_cpu(watchdog_hardlockup_touched, cpu) = true;
 }
 
-static bool is_hardlockup(unsigned int cpu)
+static void watchdog_hardlockup_update(unsigned int cpu)
 {
 	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
 
-	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
-		return true;
-
 	/*
 	 * NOTE: we don't need any fancy atomic_t or READ_ONCE/WRITE_ONCE
 	 * for hrtimer_interrupts_saved. hrtimer_interrupts_saved is
 	 * written/read by a single CPU.
 	 */
 	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
+}
+
+static bool is_hardlockup(unsigned int cpu)
+{
+	int hrint = atomic_read(&per_cpu(hrtimer_interrupts, cpu));
+
+	if (per_cpu(hrtimer_interrupts_saved, cpu) != hrint) {
+		watchdog_hardlockup_update(cpu);
+		return false;
+	}
 
-	return false;
+	return true;
 }
 
 static void watchdog_hardlockup_kick(void)
@@ -191,6 +198,7 @@ void watchdog_hardlockup_check(unsigned
 	unsigned long flags;
 
 	if (per_cpu(watchdog_hardlockup_touched, cpu)) {
+		watchdog_hardlockup_update(cpu);
 		per_cpu(watchdog_hardlockup_touched, cpu) = false;
 		return;
 	}
_

Patches currently in -mm which might be from mrungta@google.com are


