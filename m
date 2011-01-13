From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-add-prefer-__packed-check.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:04 -0800
Message-ID: <201101132009.p0DK9jHO029978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933352Ab1AMUKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch.pl: add "prefer __packed" check
has been removed from the -mm tree.  Its filename was
     checkpatchpl-add-prefer-__packed-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: add "prefer __packed" check
From: Joe Perches <joe@perches.com>

There's a __packed #define for __attribute__((packed)).  Add a checkpatch
to tell people about it.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-prefer-__packed-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-prefer-__packed-check
+++ a/scripts/checkpatch.pl
@@ -2743,6 +2743,11 @@ sub process {
 			WARN("plain inline is preferred over $1\n" . $herecurr);
 		}
 
+# Check for __attribute__ packed, prefer __packed
+		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
+			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

