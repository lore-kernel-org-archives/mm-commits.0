Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6907E33439F
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898385; cv=none; b=UpEk/8vhfIj+adiplU45R1kAp1dYfR4Q1jlIQR6jpgn4JjZoq3KshCoOMH07u82332EtmDUsUfag3q2+P3eRNbt0RVaERdirEw5cs9nnj44Jalue+u9NDFLjTPV4Rs7x+F/ORi1z0OXspWM+Vf8heuAufNvQ8j7hpBTr06hhcGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898385; c=relaxed/simple;
	bh=hCyp4soF/CTuAOC1FwTMDmXO0rz5S1a6+VJhBABrJxo=;
	h=Date:To:From:Subject:Message-Id; b=SmjJi7WkNL2JzXF2ZlvKcHZgLfrzoqhtaYoVmpqUXtEazqYPIDP5O5avDjAN3BcSbiq2czkrSO5v0EOHY3OlCT0DvHvPEBj+aPdZaHgfbG4dHEzlJIRStPlzWk3XcxLlkhLkdtCf6RGaFPGjlhETHWb/pMBQzeVVzEk6qxv8WY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhV4DD0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhV4DD0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B84C4CEF1;
	Sat, 31 Jan 2026 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898385;
	bh=hCyp4soF/CTuAOC1FwTMDmXO0rz5S1a6+VJhBABrJxo=;
	h=Date:To:From:Subject:From;
	b=yhV4DD0NA9HnqvOc2nq/xiBS4opatMapTgdWdIPiHgq7SUm+Ui8ZIvQkfmH0ahG+F
	 q3rDnSswPshzhn3V/ePMm0AfI7DKkS977fICfdsrGkePd8KVpufNWh/5wkr1SdC3A0
	 RhW5RT3HTbMTg2VFSFHvxc7/Pebui5pKCn5kd8yI=
Date: Sat, 31 Jan 2026 14:26:24 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-remove-unnecessary-sync-argument-from-start_report.patch removed from -mm tree
Message-Id: <20260131222625.37B84C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: remove unnecessary sync argument from start_report()
has been removed from the -mm tree.  Its filename was
     kasan-remove-unnecessary-sync-argument-from-start_report.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: kasan: remove unnecessary sync argument from start_report()
Date: Thu, 22 Jan 2026 09:45:56 +0530

commit 7ce0ea19d50e ("kasan: switch kunit tests to console tracepoints")
removed use of sync variable, thus removing that extra argument also.

Link: https://lkml.kernel.org/r/20260122041556.341868-1-maninder1.s@samsung.com
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kasan/report.c~kasan-remove-unnecessary-sync-argument-from-start_report
+++ a/mm/kasan/report.c
@@ -203,7 +203,7 @@ static inline void fail_non_kasan_kunit_
 
 static DEFINE_RAW_SPINLOCK(report_lock);
 
-static void start_report(unsigned long *flags, bool sync)
+static void start_report(unsigned long *flags)
 {
 	fail_non_kasan_kunit_test();
 	/* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
@@ -543,7 +543,7 @@ void kasan_report_invalid_free(void *ptr
 	if (unlikely(!report_enabled()))
 		return;
 
-	start_report(&flags, true);
+	start_report(&flags);
 
 	__memset(&info, 0, sizeof(info));
 	info.type = type;
@@ -581,7 +581,7 @@ bool kasan_report(const void *addr, size
 		goto out;
 	}
 
-	start_report(&irq_flags, true);
+	start_report(&irq_flags);
 
 	__memset(&info, 0, sizeof(info));
 	info.type = KASAN_REPORT_ACCESS;
@@ -615,7 +615,7 @@ void kasan_report_async(void)
 	if (unlikely(!report_enabled()))
 		return;
 
-	start_report(&flags, false);
+	start_report(&flags);
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous fault: no details available\n");
 	pr_err("\n");
_

Patches currently in -mm which might be from maninder1.s@samsung.com are


