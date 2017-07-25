From: akpm@linux-foundation.org
Subject: [to-be-updated] kasan-avoid-wmaybe-uninitialized-warning.patch
 removed from -mm tree
Date: Tue, 25 Jul 2017 13:07:44 -0700
Message-ID: <5977a510.2EsTJYC/mJuYGBEZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbdGYUHp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 16:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, andreyknvl@google.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: avoid -Wmaybe-uninitialized warning
has been removed from the -mm tree.  Its filename was
     kasan-avoid-wmaybe-uninitialized-warning.patch

This patch was dropped because an updated version will be merged

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
in the other code path gets rid of the warning.

Fixes: b235b9808664 ("kasan: unify report headers")
Link: https://patchwork.kernel.org/patch/9641417/
Link: http://lkml.kernel.org/r/20170721210251.3378996-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/kasan/report.c~kasan-avoid-wmaybe-uninitialized-warning mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-avoid-wmaybe-uninitialized-warning
+++ a/mm/kasan/report.c
@@ -111,6 +111,9 @@ static const char *get_wild_bug_type(str
 {
 	const char *bug_type = "unknown-crash";
 
+	/* shut up spurious -Wmaybe-uninitialized warning */
+	info->first_bad_addr = (void *)(-1ul);
+
 	if ((unsigned long)info->access_addr < PAGE_SIZE)
 		bug_type = "null-ptr-deref";
 	else if ((unsigned long)info->access_addr < TASK_SIZE)
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

