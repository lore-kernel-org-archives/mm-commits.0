From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-the-storage_class-test.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:43:09 -0700
Message-ID: <20170713204309.zn-1CK3Vw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdGMUnK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the STORAGE_CLASS test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-the-storage_class-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the STORAGE_CLASS test

Make sure static, extern, and asmlinkage appear before a specific type.

e.g.:
	int asmlinkage foo(void)
is better written
       asmlinkage int foo(void)

Link: http://lkml.kernel.org/r/31704c96df2d5fd9df0b41165940a7a4feb16a63.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-storage_class-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-storage_class-test
+++ a/scripts/checkpatch.pl
@@ -5576,10 +5576,18 @@ sub process {
 			    "architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
+# check that the storage class is not after a type
+		if ($line =~ /\b($Type)\s+($Storage)\b/) {
+			WARN("STORAGE_CLASS",
+			     "storage class '$2' should be located before type '$1'\n" . $herecurr);
+		}
 # Check that the storage class is at the beginning of a declaration
-		if ($line =~ /\b$Storage\b/ && $line !~ /^.\s*$Storage\b/) {
+		if ($line =~ /\b$Storage\b/ &&
+		    $line !~ /^.\s*$Storage/ &&
+		    $line =~ /^.\s*(.+?)\$Storage\s/ &&
+		    $1 !~ /[\,\)]\s*$/) {
 			WARN("STORAGE_CLASS",
-			     "storage class should be at the beginning of the declaration\n" . $herecurr)
+			     "storage class should be at the beginning of the declaration\n" . $herecurr);
 		}
 
 # check the location of the inline attribute, that it is between
_

Patches currently in -mm which might be from joe@perches.com are


