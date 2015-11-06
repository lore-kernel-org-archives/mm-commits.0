From: akpm@linux-foundation.org
Subject: [merged] kasan-always-taint-kernel-on-report.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:17:57 -0800
Message-ID: <563d0af5.MKs5rdPCoseTiQhh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161810AbbKFUR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: always taint kernel on report
has been removed from the -mm tree.  Its filename was
     kasan-always-taint-kernel-on-report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
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


