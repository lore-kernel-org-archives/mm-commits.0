Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555759;
	b=FXB+RaX10bjUFQuofRcVEyIWshQtQ7e2JsgQ8hG93HUeisiDzKKLCYEaVLnJsQsSP111
	 oCbtbFvcAGDZBrQCyuhOGwT4Aa0p+ZmrS1jc46zun45ABnUDPKBoUw7vTxvqXaOLNtpHm
	 dvWRrKvgD2mW7SOa/333igkYNdExtfGV8kOhQu/wqJ52fO5uHJDj3CKuDTOO5GhwppHPC
	 1g8amXLHHzj8QBimyNSlnYNbycTw79p7YOtRsX4X40Jkv6/TufgErCVsSYcE87cHPJHFw
	 fPK0DEjDfulZeIYlZPCt13j03PlFcGDfzWahdBzSElm/g5VBFa2Pz0XVySeAIFfxoWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555759;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=73sIXLKTwtG8bQRdXGMaGOTBn3Y0qk223b3F6B2LH9k=;
	b=NtqwEneZ1SLZlwHcfO3kiY1aYE/Y8/spO+NRWKW7n0QcgLi7VmNGZFBsNo0am6RnNJ3+
	 E/x+aGKFzPeVwP7KdES71/SNoMlPwiZ6R9vVd4EroJF4GCUmP8u95WJweHeAVN8cySvYh
	 wIdi86QM2znzT1vFBhZFRfFRBf1uy8FjU8wjiyNCspOAilQtktEu3ukwwJVJZV7HvrpF1
	 sBcptjm6EKRQ8Hj7eX3Wmy0yAo6MmiHNgVSgkrIeC1oPtpgrTdvtAQ7sLwSD/QuaHOUDk
	 1EoB51JUKRRJSyb7Pr3osVdPrkQdHb4f2DcwgfRqUIcHKaDdOvi5ENBV61ZiP7s8O3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pthUGAIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A868A606A319
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 04:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pthUGAIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288A21F000C9;
	Wed, 21 Oct 2026 04:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792555758;
	bh=73sIXLKTwtG8bQRdXGMaGOTBn3Y0qk223b3F6B2LH9k=;
	h=Date:To:From:Subject;
	b=pthUGAIxE5caxUUzReNAe8PDl5o4/sAvXPba0+E59YJyJdol7DPC4ChmXqaAficwl
	 SG2/W5I31XYpd6hZyc9W0cl/4sr8RYtdK4VYivoatwogUEzXX1o3C4Fb59TXb66zsx
	 NcF33LjguOryKN8UjNkgOH0kcq+a+WGFMCQich+I=
Date: Tue, 20 Oct 2026 21:09:17 -0700
To: mm-commits@vger.kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,pmladek@suse.com,dianders@chromium.org,brads@mainlining.org,tzungbi@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-force-console-verbose-when-reporting-lockups.patch added to mm-nonmm-unstable branch
Message-Id: <20261021040918.288A21F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: watchdog: force console verbose when reporting lockups
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-force-console-verbose-when-reporting-lockups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-force-console-verbose-when-reporting-lockups.patch

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
From: Tzung-Bi Shih <tzungbi@kernel.org>
Subject: watchdog: force console verbose when reporting lockups
Date: Wed, 07 Oct 2026 05:17:26 +0000

When a hard or soft lockup is detected, the watchdog prints a header at
KERN_EMERG (<0>), followed by diagnostic details (modules, registers, and
backtraces) at KERN_WARNING/KERN_DEFAULT (<4>) and KERN_INFO (<6>).  If
console_loglevel is quiet (<= 4), the console skips those <4>/<6>
diagnostic messages before vpanic() has a chance to call
console_verbose().  With the buddy detector, this leaves only the detector
CPU's panic stack on the console and nothing about the locked CPU:

  <0>[ 1535.991833][    C6] watchdog: Watchdog detected hard LOCKUP on cpu 7
  <0>[ 1535.995960][    C6] Kernel panic - not syncing: Hard LOCKUP
  <4>[ 1535.995970][    C6] CPU: 6 UID: 0 PID: 0 Comm: swapper/6 ...
  <4>[ 1535.995997][    C6] Call trace:
  ...
  <4>[ 1535.996063][    C6]  watchdog_hardlockup_check+0x1e0/0x288
  <4>[ 1535.996075][    C6]  watchdog_buddy_check_hardlockup+0xb4/0xc0

Similar to commit 168e06f7937d ("kernel/hung_task.c: force console verbose
before panic"), call console_verbose() before printing the lockup report
so the diagnostic output is not suppressed.

Link: https://lore.kernel.org/20261007051726.4154849-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Tested-by: Bradley Morgan <brads@mainlining.org> # Power10 / ARM64
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Tomasz Figa <tfiga@chromium.org>
---

 kernel/watchdog.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-force-console-verbose-when-reporting-lockups
+++ a/kernel/watchdog.c
@@ -255,6 +255,9 @@ void watchdog_hardlockup_check(unsigned
 			return;
 	}
 
+	if (hardlockup_panic)
+		console_verbose();
+
 	/*
 	 * NOTE: we call printk_cpu_sync_get_irqsave() after printing
 	 * the lockup message. While it would be nice to serialize
@@ -880,6 +883,10 @@ static enum hrtimer_restart watchdog_tim
 		/* Start period for the next softlockup warning. */
 		update_report_ts();
 
+		thresh_count = duration / get_softlockup_thresh();
+		if (softlockup_panic && thresh_count >= softlockup_panic)
+			console_verbose();
+
 		printk_cpu_sync_get_irqsave(flags);
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
@@ -901,7 +908,6 @@ static enum hrtimer_restart watchdog_tim
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		sys_info(softlockup_si_mask & ~SYS_INFO_ALL_BT);
-		thresh_count = duration / get_softlockup_thresh();
 
 		if (softlockup_panic && thresh_count >= softlockup_panic)
 			panic("softlockup: hung tasks");
_

Patches currently in -mm which might be from tzungbi@kernel.org are

watchdog-force-console-verbose-when-reporting-lockups.patch

