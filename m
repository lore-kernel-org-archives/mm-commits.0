From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-test-for-lines-ending-in-or.patch added
 to -mm tree
Date: Wed, 18 Oct 2017 14:54:39 -0700
Message-ID: <59e7cd9f.pAf57LqtYL1Oc2yG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdJRVyk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 17:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, vivien.didelot@savoirfairelinux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for lines ending in [ or (
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-lines-ending-in-or.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-test-for-lines-ending-in-or.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-test-for-lines-ending-in-or.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict test for lines ending in [ or (

Lines that end in an open bracket or open parenthesis are generally hard
to follow.  Lines following those ending with open parenthesis are also
rarely aligned to that open parenthesis.

Suggest not ending lines with '[' or '('

Link: http://lkml.kernel.org/r/8fd0b2b4a7482064254e37931eb9302a81d5aa2f.1508340786.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-lines-ending-in-or scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-lines-ending-in-or
+++ a/scripts/checkpatch.pl
@@ -3184,6 +3184,12 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# check for unusual line ending [ or (
+		if ($line =~ /^\+.*([\[\(])\s*$/) {
+			CHK("OPEN_ENDED_LINE",
+			    "Lines should not end with a '$1'\n" . $herecurr);
+		}
+
 # check if this appears to be the start function declaration, save the name
 		if ($sline =~ /^\+\{\s*$/ &&
 		    $prevline =~ /^\+(?:(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*)?($Ident)\(/) {
_

Patches currently in -mm which might be from joe@perches.com are

spellingtxt-add-unnecessary-typo-variants.patch
parse-maintainers-add-ability-to-specify-filenames.patch
checkpatch-printks-always-need-a-kern_level.patch
checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch
checkpatch-add-tp_printk-to-list-of-logging-functions.patch
checkpatch-add-strict-test-for-lines-ending-in-or.patch

