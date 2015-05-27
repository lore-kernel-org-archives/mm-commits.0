From: akpm@linux-foundation.org
Subject: + checkpatch-use-string-consistently.patch added to -mm tree
Date: Wed, 27 May 2015 14:48:48 -0700
Message-ID: <55663bc0.MXTfOjex/NimyVpz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbE0Vst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 17:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use $String consistently
has been added to the -mm tree.  Its filename is
     checkpatch-use-string-consistently.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-use-string-consistently.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-use-string-consistently.patch

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

maintainers-update-capabilities-pattern.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

