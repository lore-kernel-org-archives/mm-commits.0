From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?checkpatch-exclude-drivers-staging-from-if-with-unnecessar?=
 =?US-ASCII?Q?y-parentheses-test.patch?= removed from -mm tree
Date: Wed, 07 Feb 2018 11:57:43 -0800
Message-ID: <20180207195743.myKxQ_wr8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754446AbeBGT5p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: exclude drivers/staging from if with unnecessary parentheses test
has been removed from the -mm tree.  Its filename was
     checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


