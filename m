From: akpm@linux-foundation.org
Subject: + checkpatch-categorize-some-long-line-length-checks.patch added
 to -mm tree
Date: Thu, 28 May 2015 14:12:28 -0700
Message-ID: <556784bc.yv1ju3uMFw1n6QM1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbbE1VM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 17:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, julia.lawall@lip6.fr, shuey@purdue.edu, mm-commits@vger.kernel.org


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     checkpatch-categorize-some-long-line-length-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-categorize-some-long-line-length-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-categorize-some-long-line-length-checks.patch

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
Subject: checkpatch: Categorize some long line length checks

Many lines of code extend beyond the maximum line length.  Some of these
are possibly justified by use type.

For instance:

structure definitions where comments are added per member like:
struct foo {
	type member;		/* some long description */

And lines that don't fit the typical logging message style
where a string constant is used like:

        SOME_MACRO(args, "Some long string");

Categorize these long line types so that checkpatch can use a command-line
--ignore=<type> option to avoid emitting some long line warnings.

One of the existing checkpatch exclusions allowed kernel-doc argument
documentation to exceed 80 columns because old versions of kernel-doc
required single line documentation.  The requirement was removed in 2009
so remove that exclusion.

Add documentation to make the test a bit clearer.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Michael Shuey <shuey@purdue.edu>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   60 +++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-categorize-some-long-line-length-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-categorize-some-long-line-length-checks
+++ a/scripts/checkpatch.pl
@@ -2517,16 +2517,56 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
 
-#line length limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?$String\s*(?:|,|\)\s*;)\s*$/ ||
-		      $line =~ /^\+\s*$String\s*(?:\s*|,|\)\s*;)\s*$/ ||
-		      $line =~ /^\+\s*#\s*define\s+\w+\s+$String$/) &&
-		    $length > $max_line_length)
-		{
-			WARN("LONG_LINE",
-			     "line over $max_line_length characters\n" . $herecurr);
+# line length limit (with some exclusions)
+#
+# There are a few types of lines that may extend beyond $max_line_length:
+#	logging functions like pr_info that end in a string
+#	lines with a single string
+#	#defines that are a single string
+#
+# There are 3 different line length message types:
+# LONG_LINE_COMMENT	a comment starts before but extends beyond $max_linelength
+# LONG_LINE_STRING	a string starts before but extends beyond $max_line_length
+# LONG_LINE		all other lines longer than $max_line_length
+#
+# if LONG_LINE is ignored, the other 2 types are also ignored
+#
+
+		if ($length > $max_line_length) {
+			my $msg_type = "LONG_LINE";
+
+			# Check the allowed long line types first
+
+			# logging functions that end in a string that starts
+			# before $max_line_length
+			if ($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(?:KERN_\S+\s*|[^"]*))?($String\s*(?:|,|\)\s*;)\s*)$/ &&
+			    length(expand_tabs(substr($line, 1, length($line) - length($1) - 1))) <= $max_line_length) {
+				$msg_type = "";
+
+			# lines with only strings (w/ possible termination)
+			# #defines with only strings
+			} elsif ($line =~ /^\+\s*$String\s*(?:\s*|,|\)\s*;)\s*$/ ||
+				 $line =~ /^\+\s*#\s*define\s+\w+\s+$String$/) {
+				$msg_type = "";
+
+			# Otherwise set the alternate message types
+
+			# a comment starts before $max_line_length
+			} elsif ($line =~ /($;[\s$;]*)$/ &&
+				 length(expand_tabs(substr($line, 1, length($line) - length($1) - 1))) <= $max_line_length) {
+				$msg_type = "LONG_LINE_COMMENT"
+
+			# a quoted string starts before $max_line_length
+			} elsif ($sline =~ /\s*($String(?:\s*(?:\\|,\s*|\)\s*;\s*))?)$/ &&
+				 length(expand_tabs(substr($line, 1, length($line) - length($1) - 1))) <= $max_line_length) {
+				$msg_type = "LONG_LINE_STRING"
+			}
+
+			if ($msg_type ne "" &&
+			    (show_type("LONG_LINE") || show_type($msg_type))) {
+				WARN($msg_type,
+				     "line over $max_line_length characters\n" . $herecurr);
+			}
 		}
 
 # check for adding lines without a newline.
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
checkpatch-categorize-some-long-line-length-checks.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

