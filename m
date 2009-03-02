From: akpm@linux-foundation.org
Subject: [merged] checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:18 -0800
Message-ID: <200903021923.n22JNI0R014392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbZCBTaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: a modifier is not an identifier at the end of a type
has been removed from the -mm tree.  Its filename was
     checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: a modifier is not an identifier at the end of a type
From: Andy Whitcroft <apw@canonical.com>

We must make sure we do not misrecognise a modifier as an Identifier
when trying to match types.  Prevent us matching this:

	void * __ref

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type
+++ a/scripts/checkpatch.pl
@@ -1686,8 +1686,8 @@ sub process {
 			# Modifiers should have spaces.
 			$to =~ s/(\b$Modifier$)/$1 /;
 
-			#print "from<$from> to<$to>\n";
-			if ($from ne $to) {
+			#print "from<$from> to<$to> ident<$ident>\n";
+			if ($from ne $to && $ident !~ /^$Modifier$/) {
 				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

