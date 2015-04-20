From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-avoid-spaces-required-around-that-false-positive.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:17:24 -0700
Message-ID: <553550c4.PQu2iK7nQ1BJQjKI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, yehuday@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid "spaces required around that ':'" false positive
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-spaces-required-around-that-false-positive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid "spaces required around that ':'" false positive

Since commit 1f65f947a6a8 ("checkpatch: add checks for question mark and
colon spacing") back in 2008, checkpatch has reported false positive for
asm volatile uses of "::" checkpatch thinks colons should always have
spaces around it.

Add an exception for colons with colons on either side for this valid asm
volatile (and c++) use.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Yehuda Yitschak <yehuday@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-spaces-required-around-that-false-positive scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-spaces-required-around-that-false-positive
+++ a/scripts/checkpatch.pl
@@ -3845,6 +3845,14 @@ sub process {
 					    	$ok = 1;
 					}
 
+					# for asm volatile statements
+					# ignore a colon with another
+					# colon immediately before or after
+					if (($op eq ':') &&
+					    ($ca =~ /:$/ || $cc =~ /^:/)) {
+						$ok = 1;
+					}
+
 					# messages are ERROR, but ?: are CHK
 					if ($ok == 0) {
 						my $msg_type = \&ERROR;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

