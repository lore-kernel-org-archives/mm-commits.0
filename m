From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-prefer-array_size-test.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:11 -0700
Message-ID: <553550b7.QVk9C11A6mLQ8+gO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add 'Prefer ARRAY_SIZE" test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-prefer-array_size-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add 'Prefer ARRAY_SIZE" test

Add a test for sizeof(foo)/sizeof(foo[0]) that could be ARRAY_SIZE(foo).

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-prefer-array_size-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-prefer-array_size-test
+++ a/scripts/checkpatch.pl
@@ -3227,6 +3227,19 @@ sub process {
 				$herecurr);
                }
 
+# check for sizeof(foo)/sizeof(foo[0]) that could be ARRAY_SIZE(foo)
+		if ($line =~ m@\bsizeof\s*\(\s*($Lval)\s*\)@) {
+			my $array = $1;
+			if ($line =~ m@\b(sizeof\s*\(\s*\Q$array\E\s*\)\s*/\s*sizeof\s*\(\s*\Q$array\E\s*\[\s*0\s*\]\s*\))@) {
+				my $array_div = $1;
+				if (WARN("ARRAY_SIZE",
+					 "Prefer ARRAY_SIZE($array)\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\Q$array_div\E/ARRAY_SIZE($array)/;
+				}
+			}
+		}
+
 # check for function declarations without arguments like "int foo()"
 		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

