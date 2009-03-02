From: akpm@linux-foundation.org
Subject: [merged] checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:14 -0800
Message-ID: <200903021923.n22JNEXL014386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758071AbZCBTXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: correctly handle type spacing in the face of modifiers
has been removed from the -mm tree.  Its filename was
     checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: correctly handle type spacing in the face of modifiers
From: Andy Whitcroft <apw@canonical.com>

We need to handle interspersed modifiers in the middle of pointer types,
for example:

	void * __user * __user bar;

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers
+++ a/scripts/checkpatch.pl
@@ -1658,7 +1658,7 @@ sub process {
 
 # * goes on variable not on type
 		# (char*[ const])
-		if ($line =~ m{\($NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)*)\)}) {
+		if ($line =~ m{\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\)}) {
 			my ($from, $to) = ($1, $1);
 
 			# Should start with a space.
@@ -1673,7 +1673,7 @@ sub process {
 			if ($from ne $to) {
 				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
-		} elsif ($line =~ m{\b$NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)?)($Ident)}) {
+		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
 			my ($from, $to, $ident) = ($1, $1, $2);
 
 			# Should start with a space.
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

