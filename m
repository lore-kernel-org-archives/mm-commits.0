From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-camelcase-variable-names.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:51:17 -0800
Message-ID: <20121217215118.187D882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35870 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LQVvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:51:19 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so702093vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:51:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: warn on CamelCase variable names
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-camelcase-variable-names.patch

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
Subject: checkpatch: warn on CamelCase variable names

Store the camelcase variables in a hash and only emit a warning on the
first use of each new variable.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-camelcase-variable-names scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-camelcase-variable-names
+++ a/scripts/checkpatch.pl
@@ -1398,6 +1398,8 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
+	my %camelcase = ();
+
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
 	#
@@ -2905,12 +2907,17 @@ sub process {
 			}
 		}
 
-#studly caps, commented out until figure out how to distinguish between use of existing and adding new
-#		if (($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
-#		    print "No studly caps, use _\n";
-#		    print "$herecurr";
-#		    $clean = 0;
-#		}
+#CamelCase
+		while ($line =~ m{($Constant|$Lval)}g) {
+			my $var = $1;
+			if ($var !~ /$Constant/ &&
+			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
+			    !defined $camelcase{$var}) {
+				$camelcase{$var} = 1;
+				WARN("CAMELCASE",
+				     "Avoid CamelCase: <$var>\n" . $herecurr);
+			}
+		}
 
 #no spaces allowed after \ in define
 		if ($line=~/\#\s*define.*\\\s$/) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
printk-boot_delay-should-only-affect-output.patch
maintainers-chinese-maintainers-mailing-list-is-subscribers-only.patch
checkpatch-warn-on-unnecessary-line-continuations.patch
checkpatch-warn-about-using-config_experimental.patch
checkpatch-remove-reference-to-feature-removal-scheduletxt.patch
checkpatch-consolidate-if-foo-barfoo-checks-and-add-debugfs_remove.patch
checkpatch-allow-control-over-line-length-warning-default-remains-80.patch
checkpatch-extend-line-continuation-test.patch
checkpatch-add-strict-messages-for-blank-lines-around-braces.patch
checkpatch-warn-when-declaring-struct-spinlock-foo.patch
checkpatch-add-strict-test-for-switch-default-missing-break.patch
checkpatch-find-hex-constants-as-a-single-ident.patch
checkpatch-add-support-for-floating-point-constants.patch
checkpatch-warn-on-camelcase-variable-names.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

