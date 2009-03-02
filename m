From: akpm@linux-foundation.org
Subject: [merged] checkpatch-pointer-type-star-may-have-modifiers-following.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:16 -0800
Message-ID: <200903021923.n22JNGZV014389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbZCBTaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: pointer type star may have modifiers following
has been removed from the -mm tree.  Its filename was
     checkpatch-pointer-type-star-may-have-modifiers-following.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: pointer type star may have modifiers following
From: Andy Whitcroft <apw@canonical.com>

We may have any modifier following a pointer type star.  Handle this:

	void * __user * __user foo;

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-pointer-type-star-may-have-modifiers-following scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-pointer-type-star-may-have-modifiers-following
+++ a/scripts/checkpatch.pl
@@ -1886,11 +1886,11 @@ sub process {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
-					if ($op eq '*' && $cc =~/\s*const\b/) {
+					if ($op eq '*' && $cc =~/\s*$Modifier\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
+						ERROR("Aspace prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

