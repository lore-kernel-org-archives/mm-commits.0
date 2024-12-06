Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A16FBF;
	Fri,  6 Dec 2024 03:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457316; cv=none; b=QXk5rLPfu3pwNzLH7qE/4vsxXsnJ5Itzh00LDEQMTCwzK6rmw2+y8p/m6QHsiMEZ3CJi1jnMd7PyKVAyLrN9U3fFqcPYOmRIPLzxSwhWg+lJkCKmvQEYbjotQwWxql4RHTCzFlIy0c5wtwWYpy1JqVa0lqhBJczQkSYDKMwMe6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457316; c=relaxed/simple;
	bh=IX8KFEHGwygT3gVCV6Ml5zKf3qO6MAAUFEMmltLh+Tc=;
	h=Date:To:From:Subject:Message-Id; b=DvvprEr18VxDH/9bzk29hkkdb6PzUU7NnT+dQcp3JIRzyGVLE0xSjsXtqo6vU8Kgv7AsIvlJJrsNK1hScjKvIBRtYeKd9vsBKQDnMrazNN6FXWr9+N+cQlfBUw8H0WMuFF5Zqy6g5pnAhvKamUZa5F0t7U7c8gtrORQ4BxRy2gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0Nome3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0Nome3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBEBC4CED1;
	Fri,  6 Dec 2024 03:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457315;
	bh=IX8KFEHGwygT3gVCV6Ml5zKf3qO6MAAUFEMmltLh+Tc=;
	h=Date:To:From:Subject:From;
	b=O0Nome3W/qepUFMt+7OFuYooeijdcgxvHwzkGQj8rK08EsWMw5XyUwfH1Witt15co
	 QsfgLsIVwcy3KnvqeHcn5E8PMXS/ViOZPSiCpgcEpgxOrl7SGhLpz8qO317P4X1tmW
	 VozoAFON1Ef6d6aNJVMKMTnOXnqlhwzZjDf2Elrg=
Date: Thu, 05 Dec 2024 19:55:15 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jkangas@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-make-report_lock-a-raw-spinlock.patch removed from -mm tree
Message-Id: <20241206035515.DCBEBC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: make report_lock a raw spinlock
has been removed from the -mm tree.  Its filename was
     kasan-make-report_lock-a-raw-spinlock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 342a93247e08 ("locking/spinlock: Provide RT variant header: <linux/spinlock_rt.h>")
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
@@ -201,7 +201,7 @@ static inline void fail_non_kasan_kunit_
 
 #endif /* CONFIG_KUNIT */
 
-static DEFINE_SPINLOCK(report_lock);
+static DEFINE_RAW_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
@@ -212,7 +212,7 @@ static void start_report(unsigned long *
 	lockdep_off();
 	/* Make sure we don't end up in loop. */
 	report_suppress_start();
-	spin_lock_irqsave(&report_lock, *flags);
+	raw_spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
 }
 
@@ -222,7 +222,7 @@ static void end_report(unsigned long *fl
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


