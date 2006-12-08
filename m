From: akpm@osdl.org
Subject: - fault-injection-optimize-and-simplify.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:43 -0800
Message-ID: <200612082011.kB8KBhbA002943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946647AbWLHUML (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: optimize and simplify should_fail()
has been removed from the -mm tree.  Its filename was
     fault-injection-optimize-and-simplify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 7 deletions(-)

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

fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
kconfig-refactoring-for-better-menu-nesting.patch
sched-improve-migration-accuracy-fix.patch

