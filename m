From: akpm@linux-foundation.org
Subject: + get_maintainer-repair-stdin-usage.patch added to -mm tree
Date: Thu, 18 Mar 2010 15:32:48 -0700
Message-ID: <201003182232.o2IMWmtk019693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab0CRWdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 18:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, joe@perches.com, shemminger@vyatta.com


The patch titled
     get_maintainer: Repair STDIN usage
has been added to the -mm tree.  Its filename is
     get_maintainer-repair-stdin-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer: Repair STDIN usage
From: Wolfram Sang <w.sang@pengutronix.de>

Commit 22dd5b0cba50a197aaa3bd2790a29ee2e8e4e372 (fix perlcritic warnings)
broke the ability to handle STDIN because the three argument version of
open() cannot handle standard IO-streams (which is mentioned in
PerlBestPractices, too).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-repair-stdin-usage scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-repair-stdin-usage
+++ a/scripts/get_maintainer.pl
@@ -284,7 +284,7 @@ foreach my $file (@ARGV) {
 	my $file_cnt = @files;
 	my $lastfile;
 
-	open(my $patch, '<', $file)
+	open(my $patch, "< $file")
 	    or die "$P: Can't open $file: $!\n";
 	while (<$patch>) {
 	    my $patch_line = $_;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
get_maintainer-repair-stdin-usage.patch
linux-next.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

