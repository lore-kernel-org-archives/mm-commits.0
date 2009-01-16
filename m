From: akpm@linux-foundation.org
Subject: [merged] documentation-accounting-getdelaysc-fix-endless-loop.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:56 -0800
Message-ID: <200901161916.n0GJGu1F025483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933967AbZAPTRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: meissner@suse.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/accounting/getdelays.c: fix endless loop
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-fix-endless-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/accounting/getdelays.c: fix endless loop
From: Marcus Meissner <meissner@suse.de>

When no option is passed to getdelays it just hangs, waiting
for a reply which will never come.

This patch prints usage() when no output marker is specified.

Signed-off-by: Marcus Meissner <meissner@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-fix-endless-loop Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-fix-endless-loop
+++ a/Documentation/accounting/getdelays.c
@@ -392,6 +392,10 @@ int main(int argc, char *argv[])
 			goto err;
 		}
 	}
+	if (!maskset && !tid && !containerset) {
+		usage();
+		goto err;
+	}
 
 	do {
 		int i;
_

Patches currently in -mm which might be from meissner@suse.de are

origin.patch

