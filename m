Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C31239E7E
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755644095; cv=none; b=P7CbGO475UkA128v/6NQ9Kjs3hHgvp3nM3aYHAM9BgxWgTfliO+jYxr1si9XI29/8n9wGiy55bq+GkCrYixtpsQbzwDqDgaoEke/SIo8zffU23EqiD9UXZLAl5zC4oJFZF8IfAdqhN8NWKkSWyVb0pKIrDB3kfLab+iy4VkhXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755644095; c=relaxed/simple;
	bh=jzO0FtU+A3tYdK1+KZUdurgde06uNdds7r8ePpTMvqw=;
	h=Date:To:From:Subject:Message-Id; b=C83DNUblv0IvFxhZw4ZNM9SK1nHjMI0fZu3Sr2qSLVaqQ9PeIyKVgRAaZ2XmvBqQ7zODVthFgNM+8XR8EgOv+3AWKLEYOgWt3HruoG10UY2JS/QzCII0dmYaCz3P4hJQ4+oKmGx74AdPZNiElPCB20ePfT8m5bAoCoaCR2dsowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ouw8HFWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ouw8HFWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6539EC4CEF1;
	Tue, 19 Aug 2025 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755644092;
	bh=jzO0FtU+A3tYdK1+KZUdurgde06uNdds7r8ePpTMvqw=;
	h=Date:To:From:Subject:From;
	b=Ouw8HFWC1semLy3up1xMkX0nKtRD5h2RUM5Leh+pOHXIIwVavhom1wAFaT3PDhmNa
	 FPyZYnHhJBwzL8iSe4F/q7Toivn+ydqx9eUYZSOkJsGkoY5weSoLmRWsuXH0ONVQl9
	 0WO0iEO37xQEiBjMgAdl/yav/P+53YFw2IknrZYM=
Date: Tue, 19 Aug 2025 15:54:51 -0700
To: mm-commits@vger.kernel.org,yaoma@linux.alibaba.com,tglx@linutronix.de,max.kellermann@ionos.com,lihuafei1@huawei.com,yaozhenguo1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20250819225452.6539EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup:Fix incorrect CPU utilization output during softlockup
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2.patch

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
Date: Mon, 18 Aug 2025 16:14:38 +0800

make get_16bit_precision() more accurate, fix comment layout

Link: https://lkml.kernel.org/r/20250818081438.40540-1-yaozhenguo@jd.com
Signed-off-by: ZhenguoYao <yaozhenguo1@gmail.com>
Cc: Bitao Hu <yaoma@linux.alibaba.com>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2
+++ a/kernel/watchdog.c
@@ -425,7 +425,11 @@ static DEFINE_PER_CPU(u8, cpustat_tail);
  */
 static u16 get_16bit_precision(u64 data_ns)
 {
-	return data_ns >> 24LL; /* 2^24ns ~= 16.8ms */
+	/*
+	 * 2^24ns ~= 16.8ms
+	 * Round to the nearest multiple of 16.8 milliseconds.
+	 */
+	return (data_ns + (1 << 23)) >> 24LL;
 }
 
 static void update_cpustat(void)
@@ -444,7 +448,8 @@ static void update_cpustat(void)
 		old_stat = __this_cpu_read(cpustat_old[i]);
 		new_stat = get_16bit_precision(cpustat[tracked_stats[i]]);
 		util = DIV_ROUND_UP(100 * (new_stat - old_stat), sample_period_16);
-		/* Since we use 16-bit precision, the raw data will undergo
+		/*
+		 * Since we use 16-bit precision, the raw data will undergo
 		 * integer division, which may sometimes result in data loss,
 		 * and then result might exceed 100%. To avoid confusion,
 		 * we enforce a 100% display cap when calculations exceed this threshold.
_

Patches currently in -mm which might be from yaozhenguo1@gmail.com are

watchdog-softlockup-fix-wrong-output-when-watchdog_thresh-3.patch
watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup.patch
watchdog-softlockup-fix-incorrect-cpu-utilization-output-during-softlockup-v2.patch

