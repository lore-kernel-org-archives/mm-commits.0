From: akpm@linux-foundation.org
Subject: [patch 026/102] checkpatch: add warning for unnamed function
 definition arguments
Date: Tue, 11 Oct 2016 13:52:16 -0700
Message-ID: <57fd5100.z8FiN2/Y5Uzkz5tF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37921 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: add warning for unnamed function definition arguments

Function definitions without identifiers like
	 int foo(int)
are not preferred.  Emit a warning when they occur.

Link: http://lkml.kernel.org/r/94fe6378504745991b650f48fc92bb4648f25706.1474925354.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-for-unnamed-function-definition-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-unnamed-function-definition-arguments
+++ a/scripts/checkpatch.pl
@@ -5794,6 +5794,19 @@ sub process {
 			     "externs should be avoided in .c files\n" .  $herecurr);
 		}
 
+		if ($realfile =~ /\.[ch]$/ && defined $stat &&
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*$Ident\s*\(\s*([^{]+)\s*\)\s*;/s &&
+		    $1 ne "void") {
+			my $args = trim($1);
+			while ($args =~ m/\s*($Type\s*(?:$Ident|\(\s*\*\s*$Ident?\s*\)\s*$balanced_parens)?)/g) {
+				my $arg = trim($1);
+				if ($arg =~ /^$Type$/ && $arg !~ /enum\s+$Ident$/) {
+					WARN("FUNCTION_ARGUMENTS",
+					     "function definition argument '$arg' should also have an identifier name\n" . $herecurr);
+				}
+			}
+		}
+
 # checks for new __setup's
 		if ($rawline =~ /\b__setup\("([^"]*)"/) {
 			my $name = $1;
_
