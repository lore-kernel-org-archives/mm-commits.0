From: akpm@linux-foundation.org
Subject: + kasan-always-taint-kernel-on-report.patch added to -mm tree
Date: Wed, 21 Oct 2015 13:55:28 -0700
Message-ID: <5627fbc0.ebNZw3niaKCMUS59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbbJUUz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: always taint kernel on report
has been added to the -mm tree.  Its filename is
     kasan-always-taint-kernel-on-report.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-always-taint-kernel-on-report.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-always-taint-kernel-on-report.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kasan: always taint kernel on report

Currently we already taint the kernel in some cases.  E.g.  if we hit some
bug in slub memory we call object_err() which will taint the kernel with
TAINT_BAD_PAGE flag.  But for other kind of bugs kernel left untainted.

Always taint with TAINT_BAD_PAGE if kasan found some bug.  This is useful
for automated testing.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/kasan/report.c~kasan-always-taint-kernel-on-report mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-always-taint-kernel-on-report
+++ a/mm/kasan/report.c
@@ -238,6 +238,7 @@ static void kasan_report_error(struct ka
 	}
 	pr_err("================================="
 		"=================================\n");
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, flags);
 	kasan_enable_current();
 }
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

disable-wframe-larger-than-warnings-with-kasan=y.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y.patch
kasan-always-taint-kernel-on-report.patch

