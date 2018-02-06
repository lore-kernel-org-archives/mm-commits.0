From: akpm@linux-foundation.org
Subject: [patch 052/114] checkpatch: exclude drivers/staging from
 if with unnecessary parentheses test
Date: Tue, 06 Feb 2018 15:39:03 -0800
Message-ID: <20180206233903.HSwsGMW0L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
