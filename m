From: akpm@linux-foundation.org
Subject: +
 mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch added to -mm tree
Date: Mon, 25 Jan 2016 14:44:54 -0800
Message-ID: <56a6a566.69ueM66EHX0WIa7+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbcAYWoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 17:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@fedoraproject.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch

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
Subject: mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#14: 
(lkml.kernel.org/g/<20160119112812.GA10818@mwanda>)

ERROR: code indent should use tabs where possible
#251: FILE: mm/page_poison.c:15:
+        if (!buf)$

WARNING: please, no spaces at the start of a line
#251: FILE: mm/page_poison.c:15:
+        if (!buf)$

ERROR: code indent should use tabs where possible
#252: FILE: mm/page_poison.c:16:
+                return -EINVAL;$

WARNING: please, no spaces at the start of a line
#252: FILE: mm/page_poison.c:16:
+                return -EINVAL;$

ERROR: code indent should use tabs where possible
#254: FILE: mm/page_poison.c:18:
+        if (strcmp(buf, "on") == 0)$

WARNING: please, no spaces at the start of a line
#254: FILE: mm/page_poison.c:18:
+        if (strcmp(buf, "on") == 0)$

ERROR: code indent should use tabs where possible
#255: FILE: mm/page_poison.c:19:
+                want_page_poisoning = true;$

WARNING: please, no spaces at the start of a line
#255: FILE: mm/page_poison.c:19:
+                want_page_poisoning = true;$

ERROR: code indent should use tabs where possible
#259: FILE: mm/page_poison.c:23:
+        return 0;$

WARNING: please, no spaces at the start of a line
#259: FILE: mm/page_poison.c:23:
+        return 0;$

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#352: FILE: mm/page_poison.c:116:
+		printk(KERN_ERR "pagealloc: single bit error\n");

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#354: FILE: mm/page_poison.c:118:
+		printk(KERN_ERR "pagealloc: memory corruption\n");

total: 6 errors, 7 warnings, 311 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_poison.c~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes mm/page_poison.c
--- a/mm/page_poison.c~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes
+++ a/mm/page_poison.c
@@ -12,15 +12,15 @@ static bool want_page_poisoning __read_m
 
 static int early_page_poison_param(char *buf)
 {
-        if (!buf)
-                return -EINVAL;
+	if (!buf)
+		return -EINVAL;
 
-        if (strcmp(buf, "on") == 0)
-                want_page_poisoning = true;
+	if (strcmp(buf, "on") == 0)
+		want_page_poisoning = true;
 	else if (strcmp(buf, "off") == 0)
 		want_page_poisoning = false;
 
-        return 0;
+	return 0;
 }
 early_param("page_poison", early_page_poison_param);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

