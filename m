Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB813FE1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eXGoW3P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C49DC433C7;
	Fri, 29 Dec 2023 20:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881416;
	bh=MhtYC6PdGfGUoi5pr0fLlAA+VCphSsFBBAP/4kycf3M=;
	h=Date:To:From:Subject:From;
	b=eXGoW3P8Dv/Y8C7sNoOz5C9YgHxx+MMTQdR6jO+GiQXkH19yEArhRiDiKVqZ+QeVr
	 ktlIUiIr92i2AKiJJ6lb/jW8zRmVIdCf4ReZ8TYW6qGtcKytPoDGQt4qh1OJqzIu40
	 WPI+31WuYmAB8UTXFv9wUv98ve7WbV/YzVLWI928=
Date: Fri, 29 Dec 2023 12:23:35 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,lizhe.67@bytedance.com,lecopzer.chen@mediatek.com,kernelfans@gmail.com,john.ogness@linutronix.de,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-if-panicking-and-we-dumped-everything-dont-re-enable-dumping.patch removed from -mm tree
Message-Id: <20231229202336.3C49DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: if panicking and we dumped everything, don't re-enable dumping
has been removed from the -mm tree.  Its filename was
     watchdog-if-panicking-and-we-dumped-everything-dont-re-enable-dumping.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog: if panicking and we dumped everything, don't re-enable dumping
Date: Wed, 20 Dec 2023 13:15:37 -0800

If, as part of handling a hardlockup or softlockup, we've already dumped
all CPUs and we're just about to panic, don't reenable dumping and give
some other CPU a chance to hop in there and add some confusing logs right
as the panic is happening.

Link: https://lkml.kernel.org/r/20231220131534.4.Id3a9c7ec2d7d83e4080da6f8662ba2226b40543f@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/watchdog.c~watchdog-if-panicking-and-we-dumped-everything-dont-re-enable-dumping
+++ a/kernel/watchdog.c
@@ -192,7 +192,8 @@ void watchdog_hardlockup_check(unsigned
 
 		if (sysctl_hardlockup_all_cpu_backtrace) {
 			trigger_allbutcpu_cpu_backtrace(cpu);
-			clear_bit_unlock(0, &hard_lockup_nmi_warn);
+			if (!hardlockup_panic)
+				clear_bit_unlock(0, &hard_lockup_nmi_warn);
 		}
 
 		if (hardlockup_panic)
@@ -548,7 +549,8 @@ static enum hrtimer_restart watchdog_tim
 
 		if (softlockup_all_cpu_backtrace) {
 			trigger_allbutcpu_cpu_backtrace(smp_processor_id());
-			clear_bit_unlock(0, &soft_lockup_nmi_warn);
+			if (!softlockup_panic)
+				clear_bit_unlock(0, &soft_lockup_nmi_warn);
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
_

Patches currently in -mm which might be from dianders@chromium.org are


