From: akpm@osdl.org
Subject: - fault-injection-defaults-likely-to-please-a-new.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:48 -0800
Message-ID: <200612082011.kB8KBmoP002951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946688AbWLHUM1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: defaults likely to please a new user
has been removed from the -mm tree.  Its filename was
     fault-injection-defaults-likely-to-please-a-new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -910,6 +910,8 @@ static struct fail_page_alloc_attr {
 
 } fail_page_alloc = {
 	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_wait = 1,
+	.ignore_gfp_highmem = 1,
 };
 
 static int __init setup_fail_page_alloc(char *str)
diff -puN mm/slab.c~fault-injection-defaults-likely-to-please-a-new mm/slab.c
--- a/mm/slab.c~fault-injection-defaults-likely-to-please-a-new
+++ a/mm/slab.c
@@ -3102,6 +3102,7 @@ static struct failslab_attr {
 
 } failslab = {
 	.attr = FAULT_ATTR_INITIALIZER,
+	.ignore_gfp_wait = 1,
 };
 
 static int __init setup_failslab(char *str)
_

Patches currently in -mm which might be from dwm@meer.net are

fault-injection-defaults-likely-to-please-a-new.patch
kconfig-refactoring-for-better-menu-nesting.patch
sched-improve-migration-accuracy-fix.patch

