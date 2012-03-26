From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-use-of-yield.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:30 -0700
Message-ID: <20120326193030.5D98AA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61526 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2CZTab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:31 -0400
Received: by yenq2 with SMTP id q2so832238yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, a.p.zijlstra@chello.nl, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on use of yield()
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-use-of-yield.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on use of yield()

Using yield() is generally wrong.  Warn on its use.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-use-of-yield scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-use-of-yield
+++ a/scripts/checkpatch.pl
@@ -3344,6 +3344,12 @@ sub process {
 			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for use of yield()
+		if ($line =~ /\byield\s*\(\s*\)/) {
+			WARN("YIELD",
+			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

