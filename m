From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-define-foo-string-long-line-exception.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:07 -0700
Message-ID: <553550b3.8d03I6utCyAp5mEZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbbDTTKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, madalin.bucur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add #define foo "string" long line exception
has been removed from the -mm tree.  Its filename was
     checkpatch-add-define-foo-string-long-line-exception.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add #define foo "string" long line exception

There are #defines with long string constants like:
	#define foo "some really long string > 80 columns"
Add a long line exception for them.

Miscellanea:

Use the $String variable for slightly better readability

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Madalin-Cristian Bucur <madalin.bucur@freescale.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-define-foo-string-long-line-exception scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-define-foo-string-long-line-exception
+++ a/scripts/checkpatch.pl
@@ -2513,8 +2513,9 @@ sub process {
 #line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
-		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
+		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?$String\s*(?:|,|\)\s*;)\s*$/ ||
+		      $line =~ /^\+\s*$String\s*(?:\s*|,|\)\s*;)\s*$/ ||
+		      $line =~ /^\+\s*#\s*define\s+\w+\s+$String$/) &&
 		    $length > $max_line_length)
 		{
 			WARN("LONG_LINE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

