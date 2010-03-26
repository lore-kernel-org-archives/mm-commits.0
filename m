From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-repair-stdin-usage.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:03 -0400
Message-ID: <201003261937.o2QJb24L016573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZThO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, joe@perches.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainer: repair STDIN usage
has been removed from the -mm tree.  Its filename was
     get_maintainer-repair-stdin-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer: repair STDIN usage
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
linux-next.patch
firmware-loader-use-statically-initialized-data-attribute.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

