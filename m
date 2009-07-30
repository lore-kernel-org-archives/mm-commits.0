From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-add-f-directory-use.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:10 -0700
Message-ID: <200907302038.n6UKcA7j012729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbZG3Uil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: Add -f directory use
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-f-directory-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: Add -f directory use
From: Joe Perches <joe@perches.com>

Don't require a specific file in a directory to be tested.

Also Arnd Bergmann pointed out that the MAINTAINERS pattern requirement
that directory patterns have a trailing slash was unnecessary and was
likely to be error prone.  Removed that requirement.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-f-directory-use scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-f-directory-use
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.16';
+my $V = '0.17';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -132,6 +132,10 @@ while (<MAINT>) {
 	    $value =~ s@\.@\\\.@g;       ##Convert . to \.
 	    $value =~ s/\*/\.\*/g;       ##Convert * to .*
 	    $value =~ s/\?/\./g;         ##Convert ? to .
+	    ##if pattern is a directory and it lacks a trailing slash, add one
+	    if ((-d $value)) {
+		$value =~ s@([^/])$@$1/@;
+	    }
 	}
 	push(@typevalue, "$type:$value");
     } elsif (!/^(\s)*$/) {
@@ -146,8 +150,10 @@ close(MAINT);
 my @files = ();
 
 foreach my $file (@ARGV) {
-    next if ((-d $file));
-    if (!(-f $file)) {
+    ##if $file is a directory and it lacks a trailing slash, add one
+    if ((-d $file)) {
+	$file =~ s@([^/])$@$1/@;
+    } elsif (!(-f $file)) {
 	die "$P: file '${file}' not found\n";
     }
     if ($from_filename) {
@@ -292,7 +298,7 @@ sub file_match_pattern {
 sub usage {
     print <<EOT;
 usage: $P [options] patchfile
-       $P [options] -f file
+       $P [options] -f file|directory
 version: $V
 
 MAINTAINER field selection options:
@@ -322,6 +328,15 @@ Other options:
   --version => show version
   --help => show this help information
 
+Notes:
+  Using "-f directory" may give unexpected results:
+
+  Used with "--git", git signators for _all_ files in and below
+     directory are examined as git recurses directories.
+     Any specified X: (exclude) pattern matches are _not_ ignored.
+  Used with "--nogit", directory is used as a pattern match,
+     no individual file within the directory or subdirectory
+     is matched.
 EOT
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

