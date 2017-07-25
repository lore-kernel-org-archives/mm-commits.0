From: akpm@linux-foundation.org
Subject: + kasan-avoid-wmaybe-uninitialized-warning-v3.patch added to -mm
 tree
Date: Tue, 25 Jul 2017 13:08:16 -0700
Message-ID: <5977a530.8F3g+ZFv8r1hK3PQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753536AbdGYUIR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 16:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: avoid -Wmaybe-uninitialized warning
has been added to the -mm tree.  Its filename is
     kasan-avoid-wmaybe-uninitialized-warning-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-avoid-wmaybe-uninitialized-warning-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-avoid-wmaybe-uninitialized-warning-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: avoid -Wmaybe-uninitialized warning

gcc-7 produces this warning:

mm/kasan/report.c: In function 'kasan_report':
mm/kasan/report.c:351:3: error: 'info.first_bad_addr' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   print_shadow_for_address(info->first_bad_addr);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/kasan/report.c:360:27: note: 'info.first_bad_addr' was declared here

The code seems fine as we only print info.first_bad_addr when there is a shadow,
and we always initialize it in that case, but this is relatively hard
for gcc to figure out after the latest rework. Adding an intialization
to the most likely value together with the other struct members
shuts up that warning.

Fixes: b235b9808664 ("kasan: unify report headers")
Link: https://patchwork.kernel.org/patch/9641417/
Link: http://lkml.kernel.org/r/20170725152739.4176967-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Alexander Potapenko <glider@google.com>
Suggested-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/kasan/report.c~kasan-avoid-wmaybe-uninitialized-warning-v3 mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-avoid-wmaybe-uninitialized-warning-v3
+++ a/mm/kasan/report.c
@@ -401,6 +401,7 @@ void kasan_report(unsigned long addr, si
 	disable_trace_on_warning();
 
 	info.access_addr = (void *)addr;
+	info.first_bad_addr = (void *)addr;
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning-v3.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

