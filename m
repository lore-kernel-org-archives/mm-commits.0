From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-when-declaring-struct-spinlock-foo.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:57 -0800
Message-ID: <20121218200657.B8DB8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50713 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2LRUG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:58 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so125277yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mcgrof@do-not-panic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when declaring "struct spinlock foo;"
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-when-declaring-struct-spinlock-foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn when declaring "struct spinlock foo;"

spinlock_t should always be used.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-declaring-struct-spinlock-foo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-declaring-struct-spinlock-foo
+++ a/scripts/checkpatch.pl
@@ -3336,6 +3336,12 @@ sub process {
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
+# check for struct spinlock declarations
+		if ($line =~ /^.\s*\bstruct\s+spinlock\s+\w+\s*;/) {
+			WARN("USE_SPINLOCK_T",
+			     "struct spinlock should be spinlock_t\n" . $herecurr);
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

