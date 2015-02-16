From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-test-for-spaces-around-arithmetic.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:17:33 -0800
Message-ID: <54e2505d.IgOXwc4F8m1H1flo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbBPUSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for spaces around arithmetic
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-spaces-around-arithmetic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict test for spaces around arithmetic

Some prefer code to have spaces around arithmetic so instead of:
        a = b*c+d;
suggest
        a = b * c + d;

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-spaces-around-arithmetic scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-spaces-around-arithmetic
+++ a/scripts/checkpatch.pl
@@ -3689,7 +3689,22 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
+					if ($check) {
+						if (defined $fix_elements[$n + 2] && $ctx !~ /[EW]x[EW]/) {
+							if (CHK("SPACING",
+								"spaces preferred around that '$op' $at\n" . $hereptr)) {
+								$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+								$fix_elements[$n + 2] =~ s/^\s+//;
+								$line_fixed = 1;
+							}
+						} elsif (!defined $fix_elements[$n + 2] && $ctx !~ /Wx[OE]/) {
+							if (CHK("SPACING",
+								"space preferred before that '$op' $at\n" . $hereptr)) {
+								$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]);
+								$line_fixed = 1;
+							}
+						}
+					} elsif ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						if (ERROR("SPACING",
 							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

