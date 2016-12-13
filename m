From: akpm@linux-foundation.org
Subject: [patch 086/123] kasan: support panic_on_warn
Date: Mon, 12 Dec 2016 16:44:53 -0800
Message-ID: <584f4485.cCGeTOpIOmNv9UIu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcLMAoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: support panic_on_warn

If user sets panic_on_warn, he wants kernel to panic if there is anything
barely wrong with the kernel.  KASAN-detected errors are definitely not
less benign than an arbitrary kernel WARNING.

Panic after KASAN errors if panic_on_warn is set.

We use this for continuous fuzzing where we want kernel to stop and reboot
on any error.

Link: http://lkml.kernel.org/r/1476694764-31986-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/kasan/report.c~kasan-support-panic_on_warn mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-support-panic_on_warn
+++ a/mm/kasan/report.c
@@ -136,6 +136,8 @@ static void kasan_end_report(unsigned lo
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
+	if (panic_on_warn)
+		panic("panic_on_warn set ...\n");
 	kasan_enable_current();
 }
 
_
