Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D0F1509BC;
	Thu, 11 Jul 2024 21:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720731716; cv=none; b=OYcLOilXqRV21cU7T6AqIGqCfB6r1gC/4yjxRGr/xBjb86b2OhHW1VIsJVXiF9MOMGc5h6410T4bmGYsvU3v36YI/bwV//wMsyiYY5dNHrN/5Gs4Ue2gCIc8a5TYkTu64tXLPYf8GC6/mT2Kq5uS8We/221y01KSEzkWwcYcN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720731716; c=relaxed/simple;
	bh=CH9kwbqKZOaytKVKB101X7KuoptUaxaYENlsZcICc7I=;
	h=Date:To:From:Subject:Message-Id; b=G04To83emuX4FdgUkSIeO73cUbWCUAtXfBaPm2tOWSgNu1kNsuIDjgRaCK71qMKu2JEdLe/uNfEiLoxqDHvKQypTwS8djbiSBGjrjWb77J0XoahyRGYLlKTddsu8uMGEBe3olxygXm61iquONbT+/2zvpmBNFLpf8cfUHfxmiCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KNmmhxVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KNmmhxVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C291C116B1;
	Thu, 11 Jul 2024 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720731715;
	bh=CH9kwbqKZOaytKVKB101X7KuoptUaxaYENlsZcICc7I=;
	h=Date:To:From:Subject:From;
	b=KNmmhxVAVFMJGZoPPZQO2dUTADVS+StSpDKmYBKs8EtxLIPDcZTg36FCgyw9OkvE/
	 9rzaoKuKCCb4Xvcl7ESc8HzTqWg9TuxZnEHz3gMdmUqXiNaQ06QMbzyteV2dM+owV2
	 eOq8nID1bgARY1tbGW4W7TQn/y4+kiTc7+yS+Cag=
Date: Thu, 11 Jul 2024 14:01:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,arjan@linux.intel.com,tglx@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-perf-properly-initialize-the-turbo-mode-timestamp-and-rearm-counter.patch added to mm-nonmm-unstable branch
Message-Id: <20240711210155.6C291C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/perf: Properly initialize the turbo mode timestamp and rearm counter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-perf-properly-initialize-the-turbo-mode-timestamp-and-rearm-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-perf-properly-initialize-the-turbo-mode-timestamp-and-rearm-counter.patch

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
From: Thomas Gleixner <tglx@linutronix.de>
Subject: watchdog/perf: Properly initialize the turbo mode timestamp and rearm counter
Date: Thu, 11 Jul 2024 22:25:21 +0200

For systems on which the performance counter can expire early due to turbo
modes the watchdog handler has a safety net in place which validates that
since the last watchdog event there has at least 4/5th of the watchdog
period elapsed.

This works reliably only after the first watchdog event because the per
CPU variable which holds the timestamp of the last event is never
initialized.

So a first spurious event will validate against a timestamp of 0 which
results in a delta which is likely to be way over the 4/5 threshold of the
period.  As this might happen before the first watchdog hrtimer event
increments the watchdog counter, this can lead to false positives.

Fix this by initializing the timestamp before enabling the hardware event.
Reset the rearm counter as well, as that might be non zero after the
watchdog was disabled and reenabled.

Link: https://lkml.kernel.org/r/87frsfu15a.ffs@tglx
Fixes: 7edaeb6841df ("kernel/watchdog: Prevent false positives with turbo modes")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-perf-properly-initialize-the-turbo-mode-timestamp-and-rearm-counter
+++ a/kernel/watchdog_perf.c
@@ -75,11 +75,15 @@ static bool watchdog_check_timestamp(voi
 	__this_cpu_write(last_timestamp, now);
 	return true;
 }
-#else
-static inline bool watchdog_check_timestamp(void)
+
+static void watchdog_init_timestamp(void)
 {
-	return true;
+	__this_cpu_write(nmi_rearmed, 0);
+	__this_cpu_write(last_timestamp, ktime_get_mono_fast_ns());
 }
+#else
+static inline bool watchdog_check_timestamp(void) { return true; }
+static inline void watchdog_init_timestamp(void) { }
 #endif
 
 static struct perf_event_attr wd_hw_attr = {
@@ -161,6 +165,7 @@ void watchdog_hardlockup_enable(unsigned
 	if (!atomic_fetch_inc(&watchdog_cpus))
 		pr_info("Enabled. Permanently consumes one hw-PMU counter.\n");
 
+	watchdog_init_timestamp();
 	perf_event_enable(this_cpu_read(watchdog_ev));
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

watchdog-perf-properly-initialize-the-turbo-mode-timestamp-and-rearm-counter.patch

