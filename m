From: akpm@linux-foundation.org
Subject: + checkpatch-improve-operator-spacing-check.patch added to -mm
 tree
Date: Tue, 07 Apr 2015 13:50:06 -0700
Message-ID: <552442fe./DQEkjfxsFf9AYDu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbbDGUuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2015 16:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam.bobroff@au1.ibm.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve operator spacing check
has been added to the -mm tree.  Its filename is
     checkpatch-improve-operator-spacing-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-operator-spacing-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-operator-spacing-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sam Bobroff <sam.bobroff@au1.ibm.com>
Subject: checkpatch: improve operator spacing check

Code such as:
       x = timercmp(&now, &end, <);
Will currently trigger a checkpatch error. e.g.

ERROR: spaces required around that '<'

This is because the "Ignore operators passed as parameters" check looks
only for a comma following the operator.  Improve the check by also
looking for a close parenthesis.

Signed-off-by: Sam Bobroff <sam.bobroff@au1.ibm.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-operator-spacing-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-operator-spacing-check
+++ a/scripts/checkpatch.pl
@@ -3652,7 +3652,7 @@ sub process {
 
 				# Ignore operators passed as parameters.
 				if ($op_type ne 'V' &&
-				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
+				    $ca =~ /\s$/ && $cc =~ /^\s*[,\)]/) {
 
 #				# Ignore comments
 #				} elsif ($op =~ /^$;+$/) {
_

Patches currently in -mm which might be from sam.bobroff@au1.ibm.com are

checkpatch-improve-operator-spacing-check.patch
linux-next.patch

