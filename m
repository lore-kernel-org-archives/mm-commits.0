From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch
 removed from -mm tree
Date: Tue, 02 Aug 2016 13:41:33 -0700
Message-ID: <57a1057d.c1ZXnt4bUYg6Q6GM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbcHBUle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix
has been removed from the -mm tree.  Its filename was
     kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch

This patch was dropped because it was folded into kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix

cleanup: use WARN_ONCE return value

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/kasan/quarantine.c~kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix
+++ a/mm/kasan/quarantine.c
@@ -217,14 +217,11 @@ void quarantine_reduce(void)
 	new_quarantine_size = (READ_ONCE(totalram_pages) << PAGE_SHIFT) /
 		QUARANTINE_FRACTION;
 	percpu_quarantines = QUARANTINE_PERCPU_SIZE * num_online_cpus();
-	if (new_quarantine_size < percpu_quarantines) {
-		WARN_ONCE(1,
-			"Too little memory, disabling global KASAN quarantine.\n",
-		);
+	if (WARN_ONCE(new_quarantine_size < percpu_quarantines,
+		"Too little memory, disabling global KASAN quarantine.\n"))
 		new_quarantine_size = 0;
-	} else {
+	else
 		new_quarantine_size -= percpu_quarantines;
-	}
 	WRITE_ONCE(quarantine_size, new_quarantine_size);
 
 	last = global_quarantine.head;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-avoid-overflowing-quarantine-size-on-low-memory-systems.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

