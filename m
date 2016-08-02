From: akpm@linux-foundation.org
Subject: + kasan-improve-double-free-reports-fix.patch added to -mm tree
Date: Tue, 02 Aug 2016 11:42:31 -0700
Message-ID: <57a0e997.DfuPwSPOlTUeOn7n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbcHBSnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 14:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-improve-double-free-reports-fix
has been added to the -mm tree.  Its filename is
     kasan-improve-double-free-reports-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-double-free-reports-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-double-free-reports-fix.patch

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
Subject: kasan-improve-double-free-reports-fix

Change double free message per Alexander

Link: http://lkml.kernel.org/r/1470153654-30160-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/report.c~kasan-improve-double-free-reports-fix mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-improve-double-free-reports-fix
+++ a/mm/kasan/report.c
@@ -172,7 +172,7 @@ void kasan_report_double_free(struct kme
 	unsigned long flags;
 
 	kasan_start_report(&flags);
-	pr_err("BUG: Double free or corrupt pointer\n");
+	pr_err("BUG: Double free or freeing an invalid pointer\n");
 	pr_err("Unexpected shadow byte: 0x%hhX\n", shadow);
 	kasan_object_err(cache, object);
 	kasan_end_report(&flags);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch
kasan-improve-double-free-reports-fix.patch

