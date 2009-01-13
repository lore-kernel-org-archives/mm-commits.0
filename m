From: akpm@linux-foundation.org
Subject: + documentation-accounting-getdelaysc-fix-endless-loop.patch added to -mm tree
Date: Tue, 13 Jan 2009 00:28:30 -0800
Message-ID: <200901130828.n0D8SUPG023630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285AbZAMI2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 03:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: meissner@suse.de


The patch titled
     Documentation/accounting/getdelays.c: fix endless loop
has been added to the -mm tree.  Its filename is
     documentation-accounting-getdelaysc-fix-endless-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

documentation-accounting-getdelaysc-fix-endless-loop.patch

