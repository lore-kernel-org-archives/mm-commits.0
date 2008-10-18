From: akpm@linux-foundation.org
Subject: - checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:26 -0700
Message-ID: <200810182313.m9INDQSn028194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbYJRXNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: reduce warnings for #include of asm/foo.h to check from arch/bar.c
has been removed from the -mm tree.  Its filename was
     checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: reduce warnings for #include of asm/foo.h to check from arch/bar.c
From: Andy Whitcroft <apw@shadowen.org>

It is much more likely that an architecture file will want to directly
include asm header files.  Reduce this WARNING to a CHECK when the
referencing file is in the arch directory.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc
+++ a/scripts/checkpatch.pl
@@ -1942,12 +1942,17 @@ sub process {
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\s*\#\s*include\s*\<asm\/(.*)\.h\>}) {
-			my $checkfile = "include/linux/$1.h";
-			if (-f "$root/$checkfile" && $realfile ne $checkfile &&
+			my $file = "$1.h";
+			my $checkfile = "include/linux/$file";
+			if (-f "$root/$checkfile" &&
+			    $realfile ne $checkfile &&
 			    $1 ne 'irq')
 			{
-				WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
-					$herecurr);
+				if ($realfile =~ m{^arch/}) {
+					CHK("Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+				} else {
+					WARN("Use #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

