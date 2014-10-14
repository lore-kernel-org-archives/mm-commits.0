From: akpm@linux-foundation.org
Subject: [merged] checkpatch-enable-whitespace-checks-for-dts-files.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:39 -0700
Message-ID: <543d693b.NQrzyYvGrnStAN/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaJNSTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: enable whitespace checks for DTS files
has been removed from the -mm tree.  Its filename was
     checkpatch-enable-whitespace-checks-for-dts-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: checkpatch: enable whitespace checks for DTS files

When run on *.dtsi or *.dts files, the whitespace checks were skipped,
while they are valid for DTS files.  Hence stop skipping them.

I ran checkpatch on all in-tree DTS files, and didn't notice any error or
warning messages that are inappropriate for DTS files.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-enable-whitespace-checks-for-dts-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-enable-whitespace-checks-for-dts-files
+++ a/scripts/checkpatch.pl
@@ -2343,7 +2343,7 @@ sub process {
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
 
 #line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
@@ -2404,7 +2404,7 @@ sub process {
 		}
 
 # check we are in a valid source file C or perl if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|pl)$/);
+		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
_

Patches currently in -mm which might be from geert+renesas@glider.be are

origin.patch
linux-next.patch

