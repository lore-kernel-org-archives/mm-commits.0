From: akpm@linux-foundation.org
Subject: [merged] checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:12 -0800
Message-ID: <200903021923.n22JNCEr014382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758002AbZCBTXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: do not warn about -p0 patches when checking files
has been removed from the -mm tree.  Its filename was
     checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: do not warn about -p0 patches when checking files
From: Andy Whitcroft <apw@canonical.com>

We are triggering the -p0 check for our own diffs generated using --file
command line option.  Suppress this check for files.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-do-not-warn-about-p0-patches-when-checking-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-do-not-warn-about-p0-patches-when-checking-files
+++ a/scripts/checkpatch.pl
@@ -1240,7 +1240,8 @@ sub process {
 			$realfile =~ s@^([^/]*)/@@;
 
 			$p1_prefix = $1;
-			if ($tree && $p1_prefix ne '' && -e "$root/$p1_prefix") {
+			if (!$file && $tree && $p1_prefix ne '' &&
+			    -e "$root/$p1_prefix") {
 				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
 			}
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

