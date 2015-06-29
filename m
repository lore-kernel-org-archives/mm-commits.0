From: akpm@linux-foundation.org
Subject: [merged] checkpatch-use-string-consistently.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:48:34 -0700
Message-ID: <5591af22.oGWfCyG0mXh8s3I3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbbF2Use (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use $String consistently
has been removed from the -mm tree.  Its filename was
     checkpatch-use-string-consistently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: use $String consistently

String detection where a source line with a string constant is converted
can either have an X or a space.

Some of the string detection regexes do not allow the space character, but
there is a handy $String variable that does.

Convert the remaining uses of string detection regexes to use the $String
variable to reduce possible false negatives.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-use-string-consistently scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-use-string-consistently
+++ a/scripts/checkpatch.pl
@@ -1008,7 +1008,7 @@ sub sanitise_line {
 sub get_quoted_string {
 	my ($line, $rawline) = @_;
 
-	return "" if ($line !~ m/(\"[X\t]+\")/g);
+	return "" if ($line !~ m/($String)/g);
 	return substr($rawline, $-[0], $+[0] - $-[0]);
 }
 
@@ -4343,8 +4343,8 @@ sub process {
 			}
 
 			# Flatten any obvious string concatentation.
-			while ($dstat =~ s/("X*")\s*$Ident/$1/ ||
-			       $dstat =~ s/$Ident\s*("X*")/$1/)
+			while ($dstat =~ s/($String)\s*$Ident/$1/ ||
+			       $dstat =~ s/$Ident\s*($String)/$1/)
 			{
 			}
 
@@ -4625,7 +4625,7 @@ sub process {
 # to grep for the string.  Make exceptions when the previous string ends in a
 # newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
 # (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
-		if ($line =~ /^\+\s*"[X\t]*"/ &&
+		if ($line =~ /^\+\s*$String/ &&
 		    $prevline =~ /"\s*$/ &&
 		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
 			if (WARN("SPLIT_STRING",
@@ -4671,13 +4671,13 @@ sub process {
 		}
 
 # concatenated string without spaces between elements
-		if ($line =~ /"X+"[A-Z_]+/ || $line =~ /[A-Z_]+"X+"/) {
+		if ($line =~ /$String[A-Z_]/ || $line =~ /[A-Za-z0-9_]$String/) {
 			CHK("CONCATENATED_STRING",
 			    "Concatenated strings should use spaces between elements\n" . $herecurr);
 		}
 
 # uncoalesced string fragments
-		if ($line =~ /"X*"\s*"/) {
+		if ($line =~ /$String\s*"/) {
 			WARN("STRING_FRAGMENTS",
 			     "Consecutive strings are generally better as a single string\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

