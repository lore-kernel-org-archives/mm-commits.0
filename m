From: akpm@linux-foundation.org
Subject: + checkpatch-fix-usleep_range-test.patch added to -mm tree
Date: Thu, 31 Jan 2013 15:45:22 -0800
Message-ID: <20130131234522.A560A5A406B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:42321 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3AaXpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 18:45:23 -0500
Received: by mail-qc0-f201.google.com with SMTP id a22so370824qcs.2
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 15:45:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bruce.w.allan@intel.com, apw@canonical.com, joe@perches.com


The patch titled
     From: Bruce Allan <bruce.w.allan@intel.com>
has been added to the -mm tree.  Its filename is
     checkpatch-fix-usleep_range-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bruce Allan <bruce.w.allan@intel.com>
Subject: checkpatch: fix USLEEP_RANGE test

Do not test udelay() for a value less than 10usec when passed a variable
instead of a hard-coded number; there is no way for checkpatch to know the
value of the variable.  As it is today, it will complain about variables
with alphanumeric characters plus '_', e.g.  foo_bar, but not variables
with other characters, eg.  foo->bar.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-usleep_range-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-usleep_range-test
+++ a/scripts/checkpatch.pl
@@ -3253,9 +3253,9 @@ sub process {
 		}
 
 # prefer usleep_range over udelay
-		if ($line =~ /\budelay\s*\(\s*(\w+)\s*\)/) {
+		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however
-			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+			if (! ($1 < 10) ) {
 				CHK("USLEEP_RANGE",
 				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
 			}
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

linux-next.patch
checkpatch-fix-usleep_range-test.patch

