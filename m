Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D315624B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742189; cv=none; b=jWwS6LkTOU29cUs01a1HiS8ITpvPpetrO+Z9P0oWtdid1cbBe4/igtoAzJVgQZKpbI+Rlt9w8iOFhUzLJNBMvk0dSHHOm2hVh+DIhtfJPlgELaHUiLOUcIUGAK0PT+KLzPw7jenF7FqQZyicAj0kluDi7Xu+es8FhyBREMzhXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742189; c=relaxed/simple;
	bh=yeX3riTTIoy8XVDilmmZvjHJTK05qnGHsDZBqCK61rg=;
	h=Date:To:From:Subject:Message-Id; b=WjsfNdqgivyykiHmJEouUF82LH0QO8otD8Yybk7fpAtN4F+57rJtPErfFa2JntalDo0DZBujN3SODbpa38qvl33LRtqzMztYy8TXvss3d1JtWiN/pFWdXl2EN2P2+PpHk1Qkej5zmIu8ZLxn8XnR4V6tMokkjEa0ZQOp4VDBrac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tDOOVCd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tDOOVCd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF89AC4CED6;
	Mon, 13 Jan 2025 04:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742189;
	bh=yeX3riTTIoy8XVDilmmZvjHJTK05qnGHsDZBqCK61rg=;
	h=Date:To:From:Subject:From;
	b=tDOOVCd1C1ROnX6HSwEerxObQIDgoTsr4Ds2wZorVewQO+8BeyVjm9EZOA9Kdnscy
	 o+MfebgW6hGfG7YMZSIV3018JM6nmuGbBwl+dSfrD2g0e6OPwOTUfQxkfQvvhM3/vl
	 WU8dStjeWHutBQ5t9jZq1Bulcy/KZJLGOFr3YT70=
Date: Sun, 12 Jan 2025 20:23:08 -0800
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,song@kernel.org,liusong@linux.alibaba.com,linux@weissschuh.net,john.ogness@linutronix.de,joel.granados@kernel.org,dianders@chromium.org,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-output-this_cpu-when-printing-hard-lockup.patch removed from -mm tree
Message-Id: <20250113042308.EF89AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: output this_cpu when printing hard LOCKUP
has been removed from the -mm tree.  Its filename was
     watchdog-output-this_cpu-when-printing-hard-lockup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: watchdog: output this_cpu when printing hard LOCKUP
Date: Tue, 10 Dec 2024 17:52:38 +0800

When printing "Watchdog detected hard LOCKUP on cpu", also output the
detecting CPU.  It's more intuitive.

Link: https://lkml.kernel.org/r/20241210095238.63444-1-cuiyunhui@bytedance.com
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Liu Song <liusong@linux.alibaba.com>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-output-this_cpu-when-printing-hard-lockup
+++ a/kernel/watchdog.c
@@ -190,7 +190,7 @@ void watchdog_hardlockup_check(unsigned
 		 * with printk_cpu_sync_get_irqsave() that we can still at least
 		 * get the message about the lockup out.
 		 */
-		pr_emerg("Watchdog detected hard LOCKUP on cpu %d\n", cpu);
+		pr_emerg("CPU%u: Watchdog detected hard LOCKUP on cpu %u\n", this_cpu, cpu);
 		printk_cpu_sync_get_irqsave(flags);
 
 		print_modules();
_

Patches currently in -mm which might be from cuiyunhui@bytedance.com are


