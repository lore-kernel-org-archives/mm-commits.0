Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D7537647B
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 22:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769119914; cv=none; b=sxhyOQpFQ9t5+SxPeSuPtBBzVTN6wbVWpXanlWbOJvomCqza/NJMhFk2dYfmJWvfg/mXvcpjNtw8fpDD+k/dSX2JJPJif66Bn5Fv0w5Sy/73UhUkvTxZms/GUZ8FPUA5lHyXSCG3ibnCuGWFirWDpyBCEZk4tPYmXLB1F/zr5rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769119914; c=relaxed/simple;
	bh=GlXwM1uYludSVBD7w7WiWYBoCN9zqj2V+du4QL2aUsg=;
	h=Date:To:From:Subject:Message-Id; b=c6wWjibpyE0wFyvJPuX8F69XlLMrJoIHiLhaUy9it1NCurRQl08I3KW3qr16CPHZ52zxaYqX+wRrX7u/z+FwhSKyNmiDoSHMVbe9/rTWT4VNOiCkZiOyUuQ3ZwrjbFscVlSnOIlAmKAN9Lli+BDnyJUQMGTeTSAlTFznQBPstu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K6AJ/PkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6AJ/PkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7626C116C6;
	Thu, 22 Jan 2026 22:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769119911;
	bh=GlXwM1uYludSVBD7w7WiWYBoCN9zqj2V+du4QL2aUsg=;
	h=Date:To:From:Subject:From;
	b=K6AJ/PkYLFDnTF+3c8wONHLbXgJLCgfuRo1AKvVeSScU5wwxs1T42CAaeYCRSaAIj
	 bYp+vQxSbj6kikdXmX5w0ay/9hWlG8CtLips5PWFuceH/ockb5bRZD+5JI94FHAcCX
	 eLhH5A1Jr7l5x/yTUV/MfLIuRnimp0Z8mi1pUKns=
Date: Thu, 22 Jan 2026 14:11:51 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-unnecessary-sync-argument-from-start_report.patch added to mm-new branch
Message-Id: <20260122221151.D7626C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: remove unnecessary sync argument from start_report()
has been added to the -mm mm-new branch.  Its filename is
     kasan-remove-unnecessary-sync-argument-from-start_report.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-remove-unnecessary-sync-argument-from-start_report.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Maninder Singh <maninder1.s@samsung.com>
Subject: kasan: remove unnecessary sync argument from start_report()
Date: Thu, 22 Jan 2026 09:45:56 +0530

commit 7ce0ea19d50e ("kasan: switch kunit tests to console tracepoints")
removed use of sync variable, thus removing that extra argument also.

Link: https://lkml.kernel.org/r/20260122041556.341868-1-maninder1.s@samsung.com
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

kasan-remove-unnecessary-sync-argument-from-start_report.patch

