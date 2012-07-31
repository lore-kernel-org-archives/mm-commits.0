From: akpm@linux-foundation.org
Subject: [merged] checkpatch-test-for-non-standard-signatures.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:37 -0700
Message-ID: <20120731185138.07A525C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:48958 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab2GaSvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:40 -0400
Received: by lbbgp10 with SMTP id gp10so295516lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: test for non-standard signatures
has been removed from the -mm tree.  Its filename was
     checkpatch-test-for-non-standard-signatures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: test for non-standard signatures

Warn on non-standard signature styles.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-test-for-non-standard-signatures scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-test-for-non-standard-signatures
+++ a/scripts/checkpatch.pl
@@ -1600,13 +1600,17 @@ sub process {
 
 # Check signature styles
 		if (!$in_header_lines &&
-		    $line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+		    $line =~ /^(\s*)([a-z0-9_-]+by:|$signature_tags)(\s*)(.*)/i) {
 			my $space_before = $1;
 			my $sign_off = $2;
 			my $space_after = $3;
 			my $email = $4;
 			my $ucfirst_sign_off = ucfirst(lc($sign_off));
 
+			if ($sign_off !~ /$signature_tags/) {
+				WARN("BAD_SIGN_OFF",
+				     "Non-standard signature: $sign_off\n" . $herecurr);
+			}
 			if (defined $space_before && $space_before ne "") {
 				WARN("BAD_SIGN_OFF",
 				     "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

