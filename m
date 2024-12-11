Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217F94CB5B
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878701; cv=none; b=CdIzyhNqNy9VvsW3u/Vxhc9W1Vkg9SJkkhzRt6bNq89eysPC/2oav0fzyaR47JThKAUTbEtCNiUXl2o0dDCkQ3WrcBGTdTrs1KgmVw2sJUThUiZ/A/TIOR0GsNjlR4Zd5xOh1jer8cekpszAFZuJq1p8y9GB6aJYR4BPfSpyrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878701; c=relaxed/simple;
	bh=33l3iWwk3GIQGsO+pINRNdTJb+GYw/gLV8VYlI33+7o=;
	h=Date:To:From:Subject:Message-Id; b=oIhdjRqt7mGF9mdtr7U2vvzxbL8IIUgwzSa3ZlMAQp3PWJWvG5rxzFgW/1kBWxkfkrh8S1i6O//6nt5x5s4cA0kEGqOzD+W7cjH7AiAfz5U4TEtU9Zpu/SKJHyhNNhD0+x5uBK0Hcbyj6vJMxG/0MnM9KXcLGtfBodwB0xPcEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JwxzNe2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JwxzNe2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A2DC4CED6;
	Wed, 11 Dec 2024 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878696;
	bh=33l3iWwk3GIQGsO+pINRNdTJb+GYw/gLV8VYlI33+7o=;
	h=Date:To:From:Subject:From;
	b=JwxzNe2JBI/66WFXh5iCYH1TlBCk39o+wv1CVRxoou9fDAPcBxROwGsLNTr/T4FSx
	 8UzPY2/Py0Mic0MzersE3TsHIu/G//+gM3DD5RLls3kcka3DM62GNKBirjBNWcOoLI
	 meeosR64cNAj57t748QgI4LS6qHjOG4L1TFwQFIE=
Date: Tue, 10 Dec 2024 16:58:16 -0800
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,song@kernel.org,liusong@linux.alibaba.com,linux@weissschuh.net,john.ogness@linutronix.de,joel.granados@kernel.org,dianders@chromium.org,cuiyunhui@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-output-this_cpu-when-printing-hard-lockup.patch added to mm-nonmm-unstable branch
Message-Id: <20241211005816.97A2DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog: output this_cpu when printing hard LOCKUP
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-output-this_cpu-when-printing-hard-lockup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-output-this_cpu-when-printing-hard-lockup.patch

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

watchdog-output-this_cpu-when-printing-hard-lockup.patch

