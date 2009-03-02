From: akpm@linux-foundation.org
Subject: [merged] checkpatch-make-in_atomic-ok-in-the-core.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:10 -0800
Message-ID: <200903021923.n22JNAZx014379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbZCBTXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: make in_atomic ok in the core
has been removed from the -mm tree.  Its filename was
     checkpatch-make-in_atomic-ok-in-the-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: make in_atomic ok in the core
From: Andy Whitcroft <apw@canonical.com>

We say that in_atomic() is ok in the core kernel, but then always report
it regardless of where in the kernel it is.  Keep quiet if it is used in
kernel/*.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-in_atomic-ok-in-the-core scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-in_atomic-ok-in-the-core
+++ a/scripts/checkpatch.pl
@@ -2560,7 +2560,7 @@ sub process {
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {
 				ERROR("do not use in_atomic in drivers\n" . $herecurr);
-			} else {
+			} elsif ($realfile !~ m@^kernel/@) {
 				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

