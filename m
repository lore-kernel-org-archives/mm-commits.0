Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16091246BAA
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755483574; cv=none; b=J2Yw4EsctLV04WTOTF/Uddntm3bVRS6BIrZYWN2Tng0+MXYRFB84O1dcD0yKgKgSm9p1jH4d9Sd5LfwB5YHAG+W07d17MxX4KK5CiiGILZ9b3r35kFe/ReIluBlmtTEDl0ySNv8aP+lu4GodCAnI72/EF4mPR/0G0cx9cGaisMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755483574; c=relaxed/simple;
	bh=bxGZuwBqR4r56TOu5vJEisYbOj3TwzSA1VTWFjT5X3g=;
	h=Date:To:From:Subject:Message-Id; b=R6HNGzd9oNnuGOW7E8Tt6qsSyfxPCKcnxPssVnYWbktbAj4vyHqDqH0+okYL3najnoCGE2WMI81SIq2zAw0s2RtHrq2FOMUBR4owppM555iw2zx9GgyLci4OVSfmBQ8nuy85vNFQoYm3IVILA1NU8k01Qqx2OEIrr0G2oibEWWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SfPf0YE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SfPf0YE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE0CC4CEEB;
	Mon, 18 Aug 2025 02:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755483573;
	bh=bxGZuwBqR4r56TOu5vJEisYbOj3TwzSA1VTWFjT5X3g=;
	h=Date:To:From:Subject:From;
	b=SfPf0YE+xuv05knR6ODjUPYqTR1NoJqtC7Y/rjwBsaM0OWXO7yn6iCCf5xzyT3Hs9
	 WiynM2Dbp91WWH97iHFb56DPIXpHZbDkz2i8tNzPGyz76sQjZfnmgW4o9e7S2K8cuA
	 I1KNckPa0EIfEjBYMKZknWWCUZbGGeKZd7tENMyY=
Date: Sun, 17 Aug 2025 19:19:32 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,tglx@linutronix.de,max.kellermann@ionos.com,lihuafei1@huawei.com,yaozhenguo1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch added to mm-nonmm-unstable branch
Message-Id: <20250818021933.9AE0CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup:Fix incorrect CPU utilization output during softlockup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch

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
From: ZhenguoYao <yaozhenguo1@gmail.com>
Subject: watchdog/softlockup:Fix incorrect CPU utilization output during softlockup
Date: Tue, 12 Aug 2025 16:25:10 +0800

Since we use 16-bit precision, the raw data will undergo integer division,
which may sometimes result in data loss.  This can lead to slightly
inaccurate CPU utilization calculations.  Under normal circumstances, this
isn't an issue.  However, when CPU utilization reaches 100%, the
calculated result might exceed 100%.  For example, with raw data like the
following:

sample_period 400000134 new_stat 83648414036 old_stat 83247417494

sample_period=400000134/2^24=23
new_stat=83648414036/2^24=4985
old_stat=83247417494/2^24=4961
util=105%

Below log will output：

CPU#3 Utilization every 0s during lockup:
    #1:   0% system,          0% softirq,   105% hardirq,     0% idle
    #2:   0% system,          0% softirq,   105% hardirq,     0% idle
    #3:   0% system,          0% softirq,   100% hardirq,     0% idle
    #4:   0% system,          0% softirq,   105% hardirq,     0% idle
    #5:   0% system,          0% softirq,   105% hardirq,     0% idle

To avoid confusion, we enforce a 100% display cap when calculations exceed
this threshold.

Link: https://lkml.kernel.org/r/20250812082510.32291-1-yaozhenguo@jd.com
Signed-off-by: ZhenguoYao <yaozhenguo1@gmail.com>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/watchdog.c~watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup
+++ a/kernel/watchdog.c
@@ -444,6 +444,13 @@ static void update_cpustat(void)
 		old_stat = __this_cpu_read(cpustat_old[i]);
 		new_stat = get_16bit_precision(cpustat[tracked_stats[i]]);
 		util = DIV_ROUND_UP(100 * (new_stat - old_stat), sample_period_16);
+		/* Since we use 16-bit precision, the raw data will undergo
+		 * integer division, which may sometimes result in data loss,
+		 * and then result might exceed 100%. To avoid confusion,
+		 * we enforce a 100% display cap when calculations exceed this threshold.
+		 */
+		if (util > 100)
+			util = 100;
 		__this_cpu_write(cpustat_util[tail][i], util);
 		__this_cpu_write(cpustat_old[i], new_stat);
 	}
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are

watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch
watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch

