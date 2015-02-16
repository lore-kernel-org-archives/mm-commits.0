From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:12 -0800
Message-ID: <54e25048.Qe7TRNw8Eu0Z2mwM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbBPURs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Allow comments in macros tested for single statements
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-comments-in-macros-tested-for-single-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Allow comments in macros tested for single statements

Convert all the comments to spaces before testing for single statement
macros.

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-allow-comments-in-macros-tested-for-single-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-comments-in-macros-tested-for-single-statements
+++ a/scripts/checkpatch.pl
@@ -4260,6 +4260,7 @@ sub process {
 			$ctx = $dstat;
 
 			$dstat =~ s/\\\n.//g;
+			$dstat =~ s/$;/ /g;
 
 			if ($dstat =~ /^\+\s*#\s*define\s+$Ident\s*${balanced_parens}\s*do\s*{(.*)\s*}\s*while\s*\(\s*0\s*\)\s*([;\s]*)\s*$/) {
 				my $stmts = $2;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

