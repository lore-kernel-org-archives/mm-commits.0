From: akpm@linux-foundation.org
Subject: + lib-parserc-avoid-overflow-in-match_number-fix.patch added to -mm tree
Date: Thu, 16 Aug 2012 13:20:45 -0700
Message-ID: <20120816202045.EE95F5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57134 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030362Ab2HPUUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 16:20:48 -0400
Received: by faem1 with SMTP id m1so60866fae.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 13:20:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, elder@inktank.com


The patch titled
     Subject: lib-parserc-avoid-overflow-in-match_number-fix
has been added to the -mm tree.  Its filename is
     lib-parserc-avoid-overflow-in-match_number-fix.patch

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
Subject: lib-parserc-avoid-overflow-in-match_number-fix

coding-style tweaks

Cc: Alex Elder <elder@inktank.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/parser.c~lib-parserc-avoid-overflow-in-match_number-fix lib/parser.c
--- a/lib/parser.c~lib-parserc-avoid-overflow-in-match_number-fix
+++ a/lib/parser.c
@@ -142,7 +142,7 @@ static int match_number(substring_t *s, 
 	val = simple_strtol(buf, &endp, base);
 	if (endp == buf)
 		ret = -EINVAL;
-	else if (val < (long) INT_MIN || val > (long) INT_MAX)
+	else if (val < (long)INT_MIN || val > (long)INT_MAX)
 		ret = -ERANGE;
 	else
 		*result = (int) val;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

