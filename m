From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-usleep_range-test.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:59 -0800
Message-ID: <20130222204259.A9F9331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60856 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3BVUnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:00 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so104150yhz.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix USLEEP_RANGE test
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-usleep_range-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

