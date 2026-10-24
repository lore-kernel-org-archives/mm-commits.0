Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828033;
	b=Ji06fTPtpZ/Gy7I3BBxzemuYIHE6O/RMXJSpwOr3xTmYlA2G7cYRtXAUpx4DOsxAm9VC
	 SbQxvFFxxMpXeQ3boTT8aMirHbmM0eE6WRbheH/DLeCEHRSoNJlCrSPqgbmlvb5EYj+te
	 DJs9mDMF1MXuktsDYBbpxcF/YwUknWZayZ7OFVgYnCclSldpCARCEhKn7SeDiIxZe+iSJ
	 vc7UYuiKKS6b+y05G21YNlk0QIyg1LqynbgdNM6TgNVhd83m8yuBIdpu2/Lszr6G8efNL
	 pijgRl3vsrIDQH3JBrHKj/NFmYXx1cbyABi9VU0MMIBDmkBh0qWWJf8YsG7fCWbhfLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828033;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/HmUjp33VWT2ln4qScYyY8rgiOTpMNNhT10TRDGYuok=;
	b=PZIML92cIZCm+AiVtOLX8w2E6J7XRDRzdbMxNvUlmPAu1E8CFpou98gG68SKL+yGC02C
	 y6w5oxlroe+96ZtS0F+LpPXP7+fDw4bF3cCZIJ8rURVADFYgzJ0UdHZG90vAAGccRVUGZ
	 FJohnhCsce2WqiT8r3XZH6PRGCpKItAaQTUujIaEyYJku8BpFk71GDl8bxdyf5dZazic0
	 nUhZZfxXreOtYu1JkIBxnGah6iGXJ9HbvgWbxTeYB6Qd+xmoS2mCNPOROTieKC3/SfzmU
	 oxYOMQQ3IvjiFwld1UMilxGdJtF4nzlWhAylhMZdbjcFFJgLroW19CjStVwFdPzet0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gEsBKvWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB57E606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gEsBKvWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901E91F01825;
	Sat, 24 Oct 2026 07:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828032;
	bh=/HmUjp33VWT2ln4qScYyY8rgiOTpMNNhT10TRDGYuok=;
	h=Date:To:From:Subject;
	b=gEsBKvWj47qaRfL5NoOta1j6XkhReKBA3rj1ryLqas6VSUxlbz0lVer5kht5Dv3Mv
	 wkctdFhm8gGRv9buRwN8DgKoWfEDooAHM9Xv4aZlVd7QsmdK9m9Qr3oFlbVkUGA8AI
	 RnEPjY9whwquF4dyq9LeQsqy0ClWVW5QCvotkwvo=
Date: Sat, 24 Oct 2026 00:47:12 -0700
To: mm-commits@vger.kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,pmladek@suse.com,dianders@chromium.org,brads@mainlining.org,tzungbi@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-force-console-verbose-when-reporting-lockups.patch removed from -mm tree
Message-Id: <20261024074712.901E91F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: watchdog: force console verbose when reporting lockups
has been removed from the -mm tree.  Its filename was
     watchdog-force-console-verbose-when-reporting-lockups.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


