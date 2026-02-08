Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441053019B2;
	Sun,  8 Feb 2026 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538459; cv=none; b=ImUy7YL29lJQ3yUTOKukIiPaZuZSlBqOsYJYaJxjJYEa8/CCJSddxJtQ6UMs03zm4gjEVKIaLtw+b0VNe20cMW9T4l/JJ4k1fCkl9C2J0ggWfVpsippXAGEuG0rHlCHGIdNzKm0jXowLTCRQrVBJEVVeqmDoxU/fWOgE59mwlJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538459; c=relaxed/simple;
	bh=oKKz82qtg+QXZkynbOp8eKODtYiTFpHTBOvA+JjcKR8=;
	h=Date:To:From:Subject:Message-Id; b=JRa63v4nroPcGP4GBMIEq+B35iBvj+R97lBTNd2pj6Jm2HIccX+LAqibyKh32n6PQM6D2RiMle8VZwXVBNmMA/ktR8qt35hg+fFh5LOw1C4hYOnCDvicSotHf3UWeKh9LbPkEHEgIVdJYwEqA57YTkthc8/GaRdRfhLMlbQDe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krpWoVOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krpWoVOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D50C4CEF7;
	Sun,  8 Feb 2026 08:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538459;
	bh=oKKz82qtg+QXZkynbOp8eKODtYiTFpHTBOvA+JjcKR8=;
	h=Date:To:From:Subject:From;
	b=krpWoVOG+eQo8W38baYk8MdQLztlukulOjUMG8xoviCsRaXSwdwu3e85YeSzodBFh
	 Z10mHnf4VIzgl6sWkFdz104qsahUIzXLLWSIvtlcASpC9j5tQxtvzRpeLc0AMISGNG
	 kClmrxlkF/TSk9j+xwjmNdgib7cY4hb5NL+naeWo=
Date: Sun, 08 Feb 2026 00:14:18 -0800
To: mm-commits@vger.kernel.org,zhang.run@zte.com.cn,tglx@linutronix.de,stable@vger.kernel.org,pmladek@suse.com,mingo@kernel.org,broonie@kernel.org,hu.shengming@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch removed from -mm tree
Message-Id: <20260208081419.19D50C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/softlockup: fix sample ring index wrap in need_counting_irqs()
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-fix-sample-ring-index-wrap-in-need_counting_irqs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch

