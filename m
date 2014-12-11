From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-an-error-test-for-no-space-before-comma.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:05:20 -0800
Message-ID: <5489eaf0.TgrKGlFbqbZwm2vJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaLKTFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add an error test for no space before comma
has been removed from the -mm tree.  Its filename was
     checkpatch-add-an-error-test-for-no-space-before-comma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add an error test for no space before comma

Using code like:

	int foo , bar;

is not preferred to:

	int foo, bar;

so emit an error on this style.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-an-error-test-for-no-space-before-comma scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-an-error-test-for-no-space-before-comma
+++ a/scripts/checkpatch.pl
@@ -3563,14 +3563,33 @@ sub process {
 						}
 					}
 
-				# , must have a space on the right.
+				# , must not have a space before and must have a space on the right.
 				} elsif ($op eq ',') {
+					my $rtrim_before = 0;
+					my $space_after = 0;
+					if ($ctx =~ /Wx./) {
+						if (ERROR("SPACING",
+							  "space prohibited before that '$op' $at\n" . $hereptr)) {
+							$line_fixed = 1;
+							$rtrim_before = 1;
+						}
+					}
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 							$last_after = $n;
+							$space_after = 1;
+						}
+					}
+					if ($rtrim_before || $space_after) {
+						if ($rtrim_before) {
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+						} else {
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]);
+						}
+						if ($space_after) {
+							$good .= " ";
 						}
 					}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

