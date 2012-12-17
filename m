From: akpm@linux-foundation.org
Subject: + mm-memoryc-suppress-warning.patch added to -mm tree
Date: Mon, 17 Dec 2012 14:17:22 -0800
Message-ID: <20121217230752.B2C96200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54560 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2LQXHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:07:55 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so368081wgb.5
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:07:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mgorman@suse.de


The patch titled
     Subject: mm/memory.c: suppress warning
has been added to the -mm tree.  Its filename is
     mm-memoryc-suppress-warning.patch

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
Subject: mm/memory.c: suppress warning

mm/memory.c: In function 'do_pmd_numa_page':
mm/memory.c:3594: warning: no return statement in function returning non-void

gcc-4.4.4 screws this up.

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-memoryc-suppress-warning mm/memory.c
--- a/mm/memory.c~mm-memoryc-suppress-warning
+++ a/mm/memory.c
@@ -3591,6 +3591,7 @@ static int do_pmd_numa_page(struct mm_st
 		     unsigned long addr, pmd_t *pmdp)
 {
 	BUG();
+	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch

