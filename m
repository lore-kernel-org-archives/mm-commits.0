From: akpm@linux-foundation.org
Subject: +
 checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch added to -mm tree
Date: Thu, 11 Jan 2018 15:11:28 -0800
Message-ID: <5a57ef20.9Skn7a4u4iLiXK7J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbeAKXLd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 18:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: exclude drivers/staging from if with unnecessary parentheses test
has been added to the -mm tree.  Its filename is
     checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch

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
Subject: checkpatch: exclude drivers/staging from if with unnecessary parentheses test

Greg KH doesn't like this test so exclude the staging directory from the
implied --strict only test unless --strict is actually used on the
command-line.

Link: http://lkml.kernel.org/r/1515704034.9619.165.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test
+++ a/scripts/checkpatch.pl
@@ -4526,7 +4526,9 @@ sub process {
 		}
 
 # check for unnecessary parentheses around comparisons in if uses
-		if ($^V && $^V ge 5.10.0 && defined($stat) &&
+# when !drivers/staging or command-line uses --strict
+		if (($realfile !~ m@^(?:drivers/staging/)@ || $check_orig) &&
+		    $^V && $^V ge 5.10.0 && defined($stat) &&
 		    $stat =~ /(^.\s*if\s*($balanced_parens))/) {
 			my $if_stat = $1;
 			my $test = substr($2, 1, -1);
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch
checkpatch-improve-the-tabstop-test-to-include-declarations.patch
checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch
checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch

