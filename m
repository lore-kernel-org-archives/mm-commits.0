From: akpm@linux-foundation.org
Subject: [patch 153/162] checkpatch: advertise the --fix and --fix-inplace options more
Date: Fri, 20 May 2016 17:04:11 -0700
Message-ID: <573fa5fb.YaHn85euNGAf8D8R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEUAEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: advertise the --fix and --fix-inplace options more

The --fix option is relatively unknown and underutilized.

Add some text to show that it's available when style defects are found.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-advertise-the-fix-and-fix-inplace-options-more scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-advertise-the-fix-and-fix-inplace-options-more
+++ a/scripts/checkpatch.pl
@@ -5975,6 +5975,14 @@ sub process {
 	}
 
 	if ($quiet == 0) {
+		# If there were any defects found and not already fixing them
+		if (!$clean and !$fix) {
+			print << "EOM"
+
+NOTE: For some of the reported defects, checkpatch may be able to
+      mechanically convert to the typical style using --fix or --fix-inplace.
+EOM
+		}
 		# If there were whitespace errors which cleanpatch can fix
 		# then suggest that.
 		if ($rpt_cleaners) {
_
