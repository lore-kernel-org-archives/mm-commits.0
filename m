Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72CA22081;
	Fri, 22 Nov 2024 06:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732256961; cv=none; b=SlQ+0lzbrgkuDXgubBr4l262nePrnkp4cycfAJ2GzS+U/pHGwDb1h4Nmwn/BAFirbC4Xwcl/lKZedO+uiTno8BTy3pEp95DV6G9MN/oAXqkBc0alEOVK77K8Fc8z3DM0U+dIBHYRGcj/uxR/7yo5g+N6ehfB304G6qgQjuteTgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732256961; c=relaxed/simple;
	bh=rzFBx4VLmeUs/UI1rjEJ5lDc1PmG9LRavihD9L0ix48=;
	h=Date:To:From:Subject:Message-Id; b=ZTLWdUXzvOrzhZ8bFgbbQsO3W3OEnNoTgORs5Pc3Cv4WiFWTBH87XRaQIeu9wt1Tfa2aSGjoe8+ZAQcUpNooHJbQS445gwpUA2U+7PZZKK+jVF8pu7YEN1zwWQHEFT1DMc49B4F3smbWuJO9G9QCc9H3sNh7nYyLt6A8sd78Nnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxY09lPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxY09lPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1CBC4CED3;
	Fri, 22 Nov 2024 06:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732256960;
	bh=rzFBx4VLmeUs/UI1rjEJ5lDc1PmG9LRavihD9L0ix48=;
	h=Date:To:From:Subject:From;
	b=fxY09lPbYojscSb69iaeqZ96f9whshgJE0jpiQSUWzSyy4ViEkyvN9LqpPQSZebUW
	 tbEwqW/iHYBAiaR8syoRt9Dh07cVi240uPIalMB9/LQghrCks9+wyZwjcHaktJ3+Ut
	 yuE33jg8Nc66ivVJY8vi94ZWNm2kgn335I20B1JQ=
Date: Thu, 21 Nov 2024 22:29:16 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jkangas@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-make-report_lock-a-raw-spinlock.patch added to mm-hotfixes-unstable branch
Message-Id: <20241122062919.7D1CBC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: make report_lock a raw spinlock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-make-report_lock-a-raw-spinlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-make-report_lock-a-raw-spinlock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jared Kangas <jkangas@redhat.com>
Subject: kasan: make report_lock a raw spinlock
Date: Tue, 19 Nov 2024 13:02:34 -0800

If PREEMPT_RT is enabled, report_lock is a sleeping spinlock and must not
be locked when IRQs are disabled.  However, KASAN reports may be triggered
in such contexts.  For example:

        char *s = kzalloc(1, GFP_KERNEL);
        kfree(s);
        local_irq_disable();
        char c = *s;  /* KASAN report here leads to spin_lock() */
        local_irq_enable();

Make report_spinlock a raw spinlock to prevent rescheduling when
PREEMPT_RT is enabled.

Link: https://lkml.kernel.org/r/20241119210234.1602529-1-jkangas@redhat.com
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-make-report_lock-a-raw-spinlock
+++ a/mm/kasan/report.c
@@ -200,7 +200,7 @@ static inline void fail_non_kasan_kunit_
 
 #endif /* CONFIG_KUNIT */
 
-static DEFINE_SPINLOCK(report_lock);
+static DEFINE_RAW_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
@@ -211,7 +211,7 @@ static void start_report(unsigned long *
 	lockdep_off();
 	/* Make sure we don't end up in loop. */
 	report_suppress_start();
-	spin_lock_irqsave(&report_lock, *flags);
+	raw_spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
 }
 
@@ -221,7 +221,7 @@ static void end_report(unsigned long *fl
 		trace_error_report_end(ERROR_DETECTOR_KASAN,
 				       (unsigned long)addr);
 	pr_err("==================================================================\n");
-	spin_unlock_irqrestore(&report_lock, *flags);
+	raw_spin_unlock_irqrestore(&report_lock, *flags);
 	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		check_panic_on_warn("KASAN");
 	switch (kasan_arg_fault) {
_

Patches currently in -mm which might be from jkangas@redhat.com are

kasan-make-report_lock-a-raw-spinlock.patch

