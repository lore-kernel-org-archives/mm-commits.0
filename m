From: akpm@linux-foundation.org
Subject: + checkpatch-enable-whitespace-checks-for-dts-files.patch added
 to -mm tree
Date: Wed, 27 Aug 2014 13:10:52 -0700
Message-ID: <53fe3b4c.hMhIwcBCxO3lQ7VL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42756 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbaH0UKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 16:10:53 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so129334iec.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 13:10:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: enable whitespace checks for DTS files
has been added to the -mm tree.  Its filename is
     checkpatch-enable-whitespace-checks-for-dts-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-enable-whitespace-checks-for-dts-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-enable-whitespace-checks-for-dts-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2340,7 +2340,7 @@ sub process {
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
 
 #line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
@@ -2401,7 +2401,7 @@ sub process {
 		}
 
 # check we are in a valid source file C or perl if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|pl)$/);
+		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
_

Patches currently in -mm which might be from geert+renesas@glider.be are

checkpatch-enable-whitespace-checks-for-dts-files.patch
linux-next.patch

