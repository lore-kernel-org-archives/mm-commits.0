From: akpm@linux-foundation.org
Subject: + checkpatch-add-an-error-test-for-no-space-before-comma.patch
 added to -mm tree
Date: Wed, 15 Oct 2014 14:56:56 -0700
Message-ID: <543eeda8.aZ+UrUq51hXqc31x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJOV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add an error test for no space before comma
has been added to the -mm tree.  Its filename is
     checkpatch-add-an-error-test-for-no-space-before-comma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-an-error-test-for-no-space-before-comma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-an-error-test-for-no-space-before-comma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
checkpatch-add-an-error-test-for-no-space-before-comma.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

