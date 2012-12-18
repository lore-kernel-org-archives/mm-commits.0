From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-camelcase-variable-names.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:11 -0800
Message-ID: <20121218200712.14C97200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:63036 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab2LRUHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:14 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69641lbo.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on CamelCase variable names
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-camelcase-variable-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

