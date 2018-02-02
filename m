From: akpm@linux-foundation.org
Subject: + checkpatch-improve-open_brace-test.patch added to -mm tree
Date: Fri, 02 Feb 2018 13:54:17 -0800
Message-ID: <5a74de09.Uc/GJrXo1jL3EeS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBBVyS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Feb 2018 16:54:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, songliubraving@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve OPEN_BRACE test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-open_brace-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-open_brace-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-open_brace-test.patch

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
Subject: checkpatch: improve OPEN_BRACE test

Some structure definitions that use macros trip the OPEN_BRACE test.

e.g. +struct bpf_map_def SEC("maps") control_map = {

Improve the test by using $balanced_parens instead of a .*

Miscellanea:

o Use $sline so any comments are ignored
o Correct the message output from declaration to definition
o Remove unnecessary parentheses

Link: http://lkml.kernel.org/r/db9b772999d1d2fbda3b9ee24bbca81a87837e13.1517543491.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-open_brace-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-open_brace-test
+++ a/scripts/checkpatch.pl
@@ -3919,10 +3919,12 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
-		    !($line=~/\#\s*define.*do\s\{/) and !($line=~/}/)) {
+		if ($^V && $^V ge 5.10.0 &&
+		    $sline =~ /$Type\s*$Ident\s*$balanced_parens\s*\{/ &&
+		    $sline !~ /\#\s*define\b.*do\s*\{/ &&
+		    $sline !~ /}/) {
 			if (ERROR("OPEN_BRACE",
-				  "open brace '{' following function declarations go on the next line\n" . $herecurr) &&
+				  "open brace '{' following function definitions go on the next line\n" . $herecurr) &&
 			    $fix) {
 				fix_delete_line($fixlinenr, $rawline);
 				my $fixed_line = $rawline;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch
checkpatch-improve-the-tabstop-test-to-include-declarations.patch
checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch
checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch
checkpatch-improve-open_brace-test.patch
maintainers-remove-android-ion-pattern.patch
maintainers-remove-arm-clkdev-support-file-pattern.patch
maintainers-update-cortina-gemini-patterns.patch
maintainers-update-arm-oxnas-platform-support-patterns.patch
maintainers-update-various-palm-patterns.patch
maintainers-update-arm-qualcomm-support-patterns.patch

