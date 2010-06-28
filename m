From: akpm@linux-foundation.org
Subject: + checkpatch-fix-handling-of-leading-spaces.patch added to -mm tree
Date: Mon, 28 Jun 2010 12:49:19 -0700
Message-ID: <201006281949.o5SJnJbU027328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab0F1Ttx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jun 2010 15:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raffaele.recalcati@bticino.it, apw@shadowen.org, w.sang@pengutronix.de


The patch titled
     checkpatch: fix handling of leading spaces
has been added to the -mm tree.  Its filename is
     checkpatch-fix-handling-of-leading-spaces.patch

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
Subject: checkpatch: fix handling of leading spaces
From: Raffaele Recalcati <raffaele.recalcati@bticino.it>

I've got a false positive when spaces are present at the beginning of a
line.

So I add this check, obviously excluding to check the lines in the middle of
comments.

For instance this code passes the checkpatch test:

+struct davinci_mcbsp_data {
+       unsigned int    fmt;
+    int             clk_div;
+};
+
+static struct davinci_mcbsp_data mcbsp_data;


Where, before the string "int             clk_div", I have 4 spaces (\040
ascii character).

With v2.6.34 scripts/checkpatch.pl script I get:

scripts/checkpatch.pl 0001-ASoC-DaVinci-Added-support-for-stereo-I2S.patch
total: 0 errors, 0 warnings, 201 lines checked
0001-ASoC-DaVinci-Added-support-for-stereo-I2S.patch has no obvious style
problems and is ready for submission.

That is not correct.  Instead with the proposed patch I get:

scripts/checkpatch.pl 0001-ASoC-DaVinci-Added-support-for-stereo-I2S.patch
WARNING: please, no space for starting a line,
                excluding comments
#63: FILE: sound/soc/davinci/davinci-i2s.c:165:
+    int             clk_div;$

WARNING: please, no space for starting a line,
                excluding comments
#95: FILE: sound/soc/davinci/davinci-i2s.c:406:
+    return 0;$

total: 0 errors, 2 warnings, 201 lines checked

That is correct.

Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-fix-handling-of-leading-spaces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-handling-of-leading-spaces
+++ a/scripts/checkpatch.pl
@@ -1454,6 +1454,13 @@ sub process {
 			WARN("please, no space before tabs\n" . $herevet);
 		}
 
+# check for spaces at the beginning of a line.
+		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("please, no space for starting a line, \
+				excluding comments\n" . $herevet);
+		}
+
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
_

Patches currently in -mm which might be from raffaele.recalcati@bticino.it are

checkpatch-fix-handling-of-leading-spaces.patch

