From: akpm@osdl.org
Subject: + fault-injection-optimize-and-simplify.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:23:12 -0800
Message-ID: <200612072023.kB7KNCIM024374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35865 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163285AbWLGUX3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwm@meer.net, akinobu.mita@gmail.com


The patch titled
     fault-injection: optimize and simplify should_fail()
has been added to the -mm tree.  Its filename is
     fault-injection-optimize-and-simplify.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault-injection: optimize and simplify should_fail()
From: Don Mullis <dwm@meer.net>

Trivial optimization and simplification of should_fail().

Do cheaper disqualification tests first (performance gain not quantified). 
Simplify logic; eliminate goto.

Signed-off-by: Don Mullis <dwm@meer.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/fault-inject.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN lib/fault-inject.c~fault-injection-optimize-and-simplify lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-optimize-and-simplify
+++ a/lib/fault-inject.c
@@ -142,9 +142,6 @@ bool should_fail(struct fault_attr *attr
 	if (attr->task_filter && !fail_task(attr, current))
 		return false;
 
-	if (!fail_stacktrace(attr))
-		return false;
-
 	if (atomic_read(&attr->times) == 0)
 		return false;
 
@@ -159,12 +156,12 @@ bool should_fail(struct fault_attr *attr
 			return false;
 	}
 
-	if (attr->probability > random32() % 100)
-		goto fail;
+	if (attr->probability <= random32() % 100)
+		return false;
 
-	return false;
+	if (!fail_stacktrace(attr))
+		return false;
 
-fail:
 	fail_dump(attr);
 
 	if (atomic_read(&attr->times) != -1)
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

