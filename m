From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch added to -mm tree
Date: Mon, 05 Mar 2012 12:21:42 -0800
Message-ID: <20120305202142.DA488A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:54035 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab2CEUVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Mar 2012 15:21:44 -0500
Received: by qcsp5 with SMTP id p5so530473qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Mar 2012 12:21:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org


The patch titled
     Subject: checkpatch: add --strict test for strings split across multiple lines
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch

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
Subject: checkpatch: add --strict test for strings split across multiple lines

Strings split across multiple lines are commonly used as formats.  These
uncoalesced formats are hard to grep and are relatively error prone.

Suggest coalescing split strings when using --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-strings-split-across-multiple-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-strings-split-across-multiple-lines
+++ a/scripts/checkpatch.pl
@@ -1860,6 +1860,12 @@ sub process {
 			    "Don't begin block comments with only a /* line, use /* comment...\n" . $hereprev);
 		}
 
+		if ($prevline =~ /^\+.*"[ \t]*$/ &&
+		    $line =~ /^\+[ \t]*"/) {
+			CHK("COALESCE_STRING",
+			    "Coalesced strings are easier to grep and less error prone\n" . $hereprev);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
_
Subject: Subject: checkpatch: add --strict test for strings split across multiple lines

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch

