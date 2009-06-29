From: akpm@linux-foundation.org
Subject: + get_maintainer-support-directories-as-well-as-regular-files.patch added to -mm tree
Date: Mon, 29 Jun 2009 13:49:17 -0700
Message-ID: <200906292049.n5TKnHf1028749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbZF2UuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 16:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     get_maintainer: support directories as well as regular files
has been added to the -mm tree.  Its filename is
     get_maintainer-support-directories-as-well-as-regular-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer: support directories as well as regular files
From: Joe Perches <joe@perches.com>

-enochangelog etc ;)

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-support-directories-as-well-as-regular-files scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-support-directories-as-well-as-regular-files
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.16';
+my $V = '0.17';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -146,8 +146,9 @@ close(MAINT);
 my @files = ();
 
 foreach my $file (@ARGV) {
-    next if ((-d $file));
-    if (!(-f $file)) {
+    if ((-d $file)) {
+	$file =~ s@([^/])$@$1/@;
+    } elsif (!(-f $file)) {
 	die "$P: file '${file}' not found\n";
     }
     if ($from_filename) {
@@ -273,17 +274,15 @@ exit($exit);
 
 sub file_match_pattern {
     my ($file, $pattern) = @_;
-    if (substr($pattern, -1) eq "/") {
-	if ($file =~ m@^$pattern@) {
+    if ($file =~ m@^$pattern@) {
+	if (substr($pattern, -1) eq "/" ||
+	    $file =~ m@^$pattern/@) {
 	    return 1;
 	}
-    } else {
-	if ($file =~ m@^$pattern@) {
-	    my $s1 = ($file =~ tr@/@@);
-	    my $s2 = ($pattern =~ tr@/@@);
-	    if ($s1 == $s2) {
-		return 1;
-	    }
+	my $s1 = ($file =~ tr@/@@);
+	my $s2 = ($pattern =~ tr@/@@);
+	if ($s1 == $s2) {
+	    return 1;
 	}
     }
     return 0;
@@ -292,7 +291,7 @@ sub file_match_pattern {
 sub usage {
     print <<EOT;
 usage: $P [options] patchfile
-       $P [options] -f file
+       $P [options] -f file|directory
 version: $V
 
 MAINTAINER field selection options:
@@ -322,6 +321,13 @@ Other options:
   --version => show version
   --help => show this help information
 
+Notes:
+  Using "-f directory" may give unexpected results:
+
+  Used with "--git", git signators for all files below are examined.
+  Used with "--nogit", directory is used as a pattern match,
+     no individual file within the directory or subdirectory
+     is matched.
 EOT
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-edac-i82975x.patch
linux-next.patch
maintainers-starfire-duralan-update.patch
get_maintainer-support-directories-as-well-as-regular-files.patch

