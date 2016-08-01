From: akpm@linux-foundation.org
Subject: +
 kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 13:30:51 -0700
Message-ID: <579fb17b.zHvtZsg7kStaGGy6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix
has been added to the -mm tree.  Its filename is
     kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kasan-avoid-overflowing-quarantine-size-on-low-memory-systems-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

