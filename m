From: akpm@linux-foundation.org
Subject: + kasan-change-report-header.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:23:44 -0800
Message-ID: <58b9fb00.dBXbIT/hYXTsmPPA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752220AbdCCXXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:23:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: change report header
has been added to the -mm tree.  Its filename is
     kasan-change-report-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-change-report-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-change-report-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: change report header

Change report header format from:

BUG: KASAN: use-after-free in unwind_get_return_address+0x28a/0x2c0 at addr ffff880069437950
Read of size 8 by task insmod/3925

to:

BUG: KASAN: use-after-free in unwind_get_return_address+0x28a/0x2c0
Read of size 8 at addr ffff880069437950 by task insmod/3925

The exact access address is not usually important, so move it to the
second line. This also makes the header look visually balanced.

Link: http://lkml.kernel.org/r/20170302134851.101218-6-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/kasan/report.c~kasan-change-report-header mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-change-report-header
+++ a/mm/kasan/report.c
@@ -130,11 +130,11 @@ static void print_error_description(stru
 {
 	const char *bug_type = get_bug_type(info);
 
-	pr_err("BUG: KASAN: %s in %pS at addr %p\n",
-		bug_type, (void *)info->ip, info->access_addr);
-	pr_err("%s of size %zu by task %s/%d\n",
+	pr_err("BUG: KASAN: %s in %pS\n",
+		bug_type, (void *)info->ip);
+	pr_err("%s of size %zu at addr %p by task %s/%d\n",
 		info->is_write ? "Write" : "Read", info->access_size,
-		current->comm, task_pid_nr(current));
+		info->access_addr, current->comm, task_pid_nr(current));
 }
 
 static inline bool kernel_or_module_addr(const void *addr)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-introduce-helper-functions-for-determining-bug-type.patch
kasan-unify-report-headers.patch
kasan-change-allocation-and-freeing-stack-traces-headers.patch
kasan-simplify-address-description-logic.patch
kasan-change-report-header.patch
kasan-improve-slab-object-description.patch
kasan-print-page-description-after-stacks.patch
kasan-improve-double-free-report-format.patch
kasan-separate-report-parts-by-empty-lines.patch

