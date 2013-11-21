From: akpm@linux-foundation.org
Subject: + mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
 added to -mm tree
Date: Thu, 21 Nov 2013 15:40:37 -0800
Message-ID: <528e99f5.7m1bAvh7rbPiPGDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3KUXki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 18:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, caizhiyong@huawei.com, akpm@linux-foundation.org

Subject: + mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,caizhiyong@huawei.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 15:40:37 -0800


The patch titled
     Subject: mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix
has been added to the -mm tree.  Its filename is
     mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch

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
Subject: mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix

fix sector_t printk warnings

Cc: Cai Zhiyong <caizhiyong@huawei.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cmdline-parser.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN block/cmdline-parser.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix block/cmdline-parser.c
--- a/block/cmdline-parser.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix
+++ a/block/cmdline-parser.c
@@ -31,7 +31,8 @@ static int parse_subpart(struct cmdline_
 		new_subpart->size = (sector_t)memparse(partdef, &partdef);
 		if (new_subpart->size < (sector_t)PAGE_SIZE) {
 			pr_warn(PARSER "partition '%s' size '0x%llx' too small.",
-				partorg, new_subpart->size);
+				partorg,
+				(unsigned long long)new_subpart->size);
 			ret = -EINVAL;
 			goto fail;
 		}
@@ -273,7 +274,8 @@ int cmdline_parts_set(struct cmdline_par
 		if (from >= disk_size) {
 			pr_warn(PARSER "partition '%s' offset exceeds device"
 				" '%s' size '0x%llx', ignoring.",
-				subpart->name, parts->name, disk_size);
+				subpart->name, parts->name,
+				(unsigned long long)disk_size);
 			break;
 		}
 
@@ -281,7 +283,8 @@ int cmdline_parts_set(struct cmdline_par
 			if (subpart->size != (sector_t)(~0ULL))
 				pr_warn(PARSER "partition '%s' size exceeds "
 					"device '%s' size '0x%llx', truncating.",
-					subpart->name, parts->name, disk_size);
+					subpart->name, parts->name,
+					(unsigned long long)disk_size);
 			subpart->size = disk_size - from;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

