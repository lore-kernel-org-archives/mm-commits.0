From: akpm@linux-foundation.org
Subject: [to-be-updated] get_maintainer-support-directories-as-well-as-regular-files.patch removed from -mm tree
Date: Mon, 29 Jun 2009 14:07:52 -0700
Message-ID: <200906292107.n5TL7qbr016603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbZF2VIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 17:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainer: support directories as well as regular files
has been removed from the -mm tree.  Its filename was
     get_maintainer-support-directories-as-well-as-regular-files.patch

This patch was dropped because an updated version will be merged

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

