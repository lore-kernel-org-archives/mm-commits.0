From: akpm@linux-foundation.org
Subject: + checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:14:25 -0800
Message-ID: <201001280114.o0S1EP3W011595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674Ab0A1BOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:14:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maramaopercheseimorto@gmail.com, apw@shadowen.org


The patch titled
     checkpatch.pl: warn if an adding line introduce spaces before tabs.
has been added to the -mm tree.  Its filename is
     checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs.patch

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
Subject: checkpatch.pl: warn if an adding line introduce spaces before tabs.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs
+++ a/scripts/checkpatch.pl
@@ -1422,6 +1422,12 @@ sub process {
 			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
+# check for space before tabs.
+		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("please, no space before tabs\n" . $herevet);
+		}
+
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
_

Patches currently in -mm which might be from maramaopercheseimorto@gmail.com are

linux-next.patch
mx3fb-some-debug-and-initialisation-fixes.patch
checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs.patch

