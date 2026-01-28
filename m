Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A0D35A93C;
	Wed, 28 Jan 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769624017; cv=none; b=MLTDcz6uW6WvCsxrkS3w5Kcbghs5wwuW+/tzHTe8m/7l/x6JBwOZVTtO7aK8GxVFMXl+cGYGaTOCNBpyPuhdrUHhHR/GmqXV9PUVJFbeaq3vbn0D2W4mq4o96Kn6dP3DFUg2TvIoZ+5bzQZDB9IFdpgQZ4XxUVJJ3LDZQQpTHHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769624017; c=relaxed/simple;
	bh=FNTeVPL/7h0F29bmgKcXfoiBpwnhcjzlPRUqsspWBBI=;
	h=Date:To:From:Subject:Message-Id; b=GhxiCbE8Jl5ug9H0D2m/DRAfFJO2DQK5d/ecOBXdDBd7gu4HAnFcymBUR37288KZE3ahP6V8nRLLUwWHf1O1MSF03VbyubMOXGRpZy6kSi3wayIoC/wqedlC/5pjgqty2ymGl8jcg5qn5avF+gJgz1dZ2+NkouJ1y8V1kD7YEqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ta6HgQEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ta6HgQEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A426C4CEF1;
	Wed, 28 Jan 2026 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769624017;
	bh=FNTeVPL/7h0F29bmgKcXfoiBpwnhcjzlPRUqsspWBBI=;
	h=Date:To:From:Subject:From;
	b=Ta6HgQEEXCYfVMUN1UcDbe0AvktSvDEdag0cOwxyoQ4bGEA2ylTDByTtGchzT2ehd
	 PJd3trDq3z+WwvvJIQRWSkaUwwbi5eWfuVi4WNWMxDI6LMATp7mxDe+XH8g06kYCnV
	 TBIQJObHPOBagMGO00Jz7dkGE9wK/IjrthlqvnIE=
Date: Wed, 28 Jan 2026 10:13:36 -0800
To: mm-commits@vger.kernel.org,zhang.run@zte.com.cn,tglx@linutronix.de,stable@vger.kernel.org,pmladek@suse.com,mingo@kernel.org,broonie@kernel.org,hu.shengming@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch added to mm-nonmm-unstable branch
Message-Id: <20260128181337.0A426C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup: fix sample ring index wrap in need_counting_irqs()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch

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
From: Shengming Hu <hu.shengming@zte.com.cn>
Subject: watchdog/softlockup: fix sample ring index wrap in need_counting_irqs()
Date: Mon, 19 Jan 2026 21:59:05 +0800

cpustat_tail indexes cpustat_util[], which is a NUM_SAMPLE_PERIODS-sized
ring buffer. need_counting_irqs() currently wraps the index using
NUM_HARDIRQ_REPORT, which only happens to match NUM_SAMPLE_PERIODS.

Use NUM_SAMPLE_PERIODS for the wrap to keep the ring math correct even if
the NUM_HARDIRQ_REPORT or  NUM_SAMPLE_PERIODS changes.

Link: https://lkml.kernel.org/r/tencent_7068189CB6D6689EB353F3D17BF5A5311A07@qq.com
Fixes: e9a9292e2368 ("watchdog/softlockup: Report the most frequent interrupts")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Run <zhang.run@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs
+++ a/kernel/watchdog.c
@@ -550,7 +550,7 @@ static bool need_counting_irqs(void)
 	u8 util;
 	int tail = __this_cpu_read(cpustat_tail);
 
-	tail = (tail + NUM_HARDIRQ_REPORT - 1) % NUM_HARDIRQ_REPORT;
+	tail = (tail + NUM_SAMPLE_PERIODS - 1) % NUM_SAMPLE_PERIODS;
 	util = __this_cpu_read(cpustat_util[tail][STATS_HARDIRQ]);
 	return util > HARDIRQ_PERCENT_THRESH;
 }
_

Patches currently in -mm which might be from hu.shengming@zte.com.cn are

watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch

