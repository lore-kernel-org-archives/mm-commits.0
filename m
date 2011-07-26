From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-a-prefer-__aligned-check.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:07 -0700
Message-ID: <201107260755.p6Q7tAUT003433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab1GZHz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add a "prefer __aligned" check
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-prefer-__aligned-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add a "prefer __aligned" check
From: Joe Perches <joe@perches.com>

Prefer the use of __aligned(size) over __attribute__((__aligned___(size)))

Link: http://lkml.kernel.org/r/20110609094526.1571774c.akpm@linux-foundation.org

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-prefer-__aligned-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-prefer-__aligned-check
+++ a/scripts/checkpatch.pl
@@ -2891,6 +2891,11 @@ sub process {
 			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
+# Check for __attribute__ aligned, prefer __aligned
+		if ($line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
+			WARN("__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

