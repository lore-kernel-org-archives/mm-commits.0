From: akpm@linux-foundation.org
Subject: [folded] use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:06:12 -0700
Message-ID: <200906162206.n5GM6CJg002435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbZFPWGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:06:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, mingo@elte.hu, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     clean up printk_once of get_cpu_vendor
has been removed from the -mm tree.  Its filename was
     use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

This patch was dropped because it was folded into use-printk_once-in-several-places.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clean up printk_once of get_cpu_vendor
From: Minchan Kim <minchan.kim@gmail.com>

It remove unnecessary variable and change two static variable
with one.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor
+++ a/arch/x86/kernel/cpu/common.c
@@ -486,7 +486,6 @@ out:
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
-	static int printed;
 	int i;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
@@ -504,8 +503,8 @@ static void __cpuinit get_cpu_vendor(str
 	}
 
 	printk_once(KERN_ERR
-		    "CPU: vendor_id '%s' unknown, using generic init.\n", v);
-	printk_once(KERN_ERR "CPU: Your system may be unstable.\n");
+			"CPU: vendor_id '%s' unknown, using generic init.\n" \
+			"CPU: Your system may be unstable.\n", v);
 
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch
mm-remove-config_unevictable_lru-config-option.patch
mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch
mm-remove-file-argument-from-swap_readpage.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
vmscan-report-vm_flags-in-page_referenced.patch
vmscan-make-mapped-executable-pages-the-first-class-citizen.patch
vmscan-merge-duplicate-code-in-shrink_active_list.patch
vmscan-handle-may_swap-more-strictly.patch
oom-only-oom-kill-exiting-tasks-with-attached-memory.patch
mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch
use-printk_once-in-several-places.patch
use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

