From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-operator-spacing-check.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:17:13 -0700
Message-ID: <553550b9.Ie9+XkW/wHWP9Icm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam.bobroff@au1.ibm.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve operator spacing check
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-operator-spacing-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

