From: akpm@linux-foundation.org
Subject: [alternative-merged]
 include-linux-mempolicyh-add-build_bug-to-mpol_to_str-stub.patch removed
 from -mm tree
Date: Mon, 25 Nov 2013 17:16:55 -0800
Message-ID: <5293f687./E5teq9dLb7jgZa9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3KZBQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Nov 2013 20:16:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: [alternative-merged] include-linux-mempolicyh-add-build_bug-to-mpol_to_str-stub.patch removed from -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 25 Nov 2013 17:16:55 -0800


The patch titled
     Subject: include/linux/mempolicy.h: add BUILD_BUG to mpol_to_str() stub
has been removed from the -mm tree.  Its filename was
     include-linux-mempolicyh-add-build_bug-to-mpol_to_str-stub.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mempolicy.h: add BUILD_BUG to mpol_to_str() stub

mpol_to_str() shouldn't be called if CONFIG_NUMA=n.  If it *is* called,
it's seruiously buggy - it leaves the output string unterminated.

So break the build if this situation occurs.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~include-linux-mempolicyh-add-build_bug-to-mpol_to_str-stub include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~include-linux-mempolicyh-add-build_bug-to-mpol_to_str-stub
+++ a/include/linux/mempolicy.h
@@ -5,7 +5,7 @@
 #ifndef _LINUX_MEMPOLICY_H
 #define _LINUX_MEMPOLICY_H 1
 
-
+#include <linux/bug.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
@@ -309,6 +309,7 @@ static inline int mpol_parse_str(char *s
 
 static inline void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 {
+	BUILD_BUG();
 }
 
 static inline int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

