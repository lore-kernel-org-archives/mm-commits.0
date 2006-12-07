From: akpm@osdl.org
Subject: + fault-injection-defaults-likely-to-please-a-new.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:23:14 -0800
Message-ID: <200612072023.kB7KNEkr024377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163281AbWLGUX1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:23:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwm@meer.net, akinobu.mita@gmail.com


The patch titled
     fault-injection: defaults likely to please a new user
has been added to the -mm tree.  Its filename is
     fault-injection-defaults-likely-to-please-a-new.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault-injection: defaults likely to please a new user
From: Don Mullis <dwm@meer.net>

Assign defaults most likely to please a new user:
 1) generate some logging output
    (verbose=2)
 2) avoid injecting failures likely to lock up UI
    (ignore_gfp_wait=1, ignore_gfp_highmem=1)

Signed-off-by: Don Mullis <dwm@meer.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fault-inject.h |    1 +
 mm/page_alloc.c              |    2 ++
 mm/slab.c                    |    1 +
 3 files changed, 4 insertions(+)

diff -puN include/linux/fault-inject.h~fault-injection-defaults-likely-to-please-a-new include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-defaults-likely-to-please-a-new
+++ a/include/linux/fault-inject.h
@@ -52,6 +52,7 @@ struct fault_attr {
 		.times = ATOMIC_INIT(1),			\
 		.require_end = ULONG_MAX,			\
 		.stacktrace_depth = 32,				\
+		.verbose = 2,					\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff -puN mm/page_alloc.c~fault-injection-defaults-likely-to-please-a-new mm/page_alloc.c
--- a/mm/page_alloc.c~fault-injection-defaults-likely-to-please-a-new
+++ a/mm/page_alloc.c
@@ -914,6 +914,8 @@ static struct fail_page_alloc_attr {
 
 } fail_page_alloc = {
 	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_wait = 1,
+	.ignore_gfp_highmem = 1,
 };
 
 static int __init setup_fail_page_alloc(char *str)
diff -puN mm/slab.c~fault-injection-defaults-likely-to-please-a-new mm/slab.c
--- a/mm/slab.c~fault-injection-defaults-likely-to-please-a-new
+++ a/mm/slab.c
@@ -3117,6 +3117,7 @@ static struct failslab_attr {
 
 } failslab = {
 	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_wait = 1,
 };
 
 static int __init setup_failslab(char *str)
_

Patches currently in -mm which might be from dwm@meer.net are

kconfig-refactoring-for-better-menu-nesting.patch
fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-stacktrace-filtering.patch
fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
sched-improve-migration-accuracy-fix.patch

