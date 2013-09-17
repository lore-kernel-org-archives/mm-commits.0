From: akpm@linux-foundation.org
Subject: +
 checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch added
 to -mm tree
Date: Tue, 17 Sep 2013 14:51:41 -0700
Message-ID: <5238ceed.ZewKWh1HtlyZVCUF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3IQVvl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 17:51:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, joe@perches.com

Subject: + checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch added to -mm tree
To: joe@perches.com,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 14:51:41 -0700


The patch titled
     Subject: checkpatch: report missing spaces around trigraphs with --strict
has been added to the -mm tree.  Its filename is
     checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch

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
Subject: checkpatch: report missing spaces around trigraphs with --strict

Spaces around trigraphs are specified by CodingStyle but checkpatch is
currently silent about them because there are many current instances
without them.

Make missing spaces around trigraphs a --strict message.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-report-missing-spaces-around-trigraphs-with-strict scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-report-missing-spaces-around-trigraphs-with-strict
+++ a/scripts/checkpatch.pl
@@ -2838,7 +2838,7 @@ sub process {
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
 				=>|->|<<|>>|<|>|=|!|~|
 				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%|
-				\?|:
+				\?:|\?|:
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 
@@ -3061,15 +3061,13 @@ sub process {
 					    	$ok = 1;
 					}
 
-					# Ignore ?:
-					if (($opv eq ':O' && $ca =~ /\?$/) ||
-					    ($op eq '?' && $cc =~ /^:/)) {
-					    	$ok = 1;
-					}
