From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-make-the-camelcase-cache-work-for-non-git-trees-too.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:57 -0700
Message-ID: <51dc9ad9.k4l+jLYpvzwqS80A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3GIXU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] checkpatch-make-the-camelcase-cache-work-for-non-git-trees-too.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:57 -0700


The patch titled
     Subject: checkpatch: make the CamelCase cache work for non-git trees too
has been removed from the -mm tree.  Its filename was
     checkpatch-make-the-camelcase-cache-work-for-non-git-trees-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: make the CamelCase cache work for non-git trees too

Might as well check include timestamps and cache the include file
CamelCase uses for the non-git case too.

The camelcase cache file is now named:

for git:	.checkpatch-camelcase.git.<commit_id>
for non-git:	.checkpatch-camelcase.date.<YYYYMMDDhhmm>

All .checkpatch-camelcase* files are deleted if not current.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   54 +++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-the-camelcase-cache-work-for-non-git-trees-too scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-the-camelcase-cache-work-for-non-git-trees-too
+++ a/scripts/checkpatch.pl
@@ -6,6 +6,7 @@
 # Licensed under the terms of the GNU GPL License version 2
 
 use strict;
+use POSIX;
 
 my $P = $0;
 $P =~ s@.*/@@g;
@@ -399,37 +400,52 @@ sub seed_camelcase_includes {
 	return if ($camelcase_seeded);
 
 	my $files;
-	my $camelcase_git_file = "";
+	my $camelcase_cache = "";
+	my @include_files = ();
+
+	$camelcase_seeded = 1;
 
 	if (-d ".git") {
 		my $git_last_include_commit = `git log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
-		$camelcase_git_file = ".checkpatch-camelcase.$git_last_include_commit";
-		if (-f $camelcase_git_file) {
-			open(my $camelcase_file, '<', "$camelcase_git_file")
-			    or warn "$P: Can't read '$camelcase_git_file' $!\n";
-			while (<$camelcase_file>) {
-				chomp;
-				$camelcase{$_} = 1;
-			}
-			close($camelcase_file);
-
-			return;
-		}
-		$files = `git ls-files include`;
+		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
 	} else {
+		my $last_mod_date = 0;
 		$files = `find $root/include -name "*.h"`;
+		@include_files = split('\n', $files);
+		foreach my $file (@include_files) {
+			my $date = POSIX::strftime("%Y%m%d%H%M",
+						   localtime((stat $file)[9]));
+			$last_mod_date = $date if ($last_mod_date < $date);
+		}
+		$camelcase_cache = ".checkpatch-camelcase.date.$last_mod_date";
+	}
+
+	if ($camelcase_cache ne "" && -f $camelcase_cache) {
+		open(my $camelcase_file, '<', "$camelcase_cache")
+		    or warn "$P: Can't read '$camelcase_cache' $!\n";
+		while (<$camelcase_file>) {
+			chomp;
+			$camelcase{$_} = 1;
+		}
+		close($camelcase_file);
+
+		return;
 	}
-	my @include_files = split('\n', $files);
+
+	if (-d ".git") {
+		$files = `git ls-files "include/*.h"`;
+		@include_files = split('\n', $files);
+	}
+
 	foreach my $file (@include_files) {
 		seed_camelcase_file($file);
 	}
-	$camelcase_seeded = 1;
 
-	if ($camelcase_git_file ne "") {
+	if ($camelcase_cache ne "") {
 		unlink glob ".checkpatch-camelcase.*";
-		open(my $camelcase_file, '>', "$camelcase_git_file")
-		    or warn "$P: Can't write '$camelcase_git_file' $!\n";
+		open(my $camelcase_file, '>', "$camelcase_cache")
+		    or warn "$P: Can't write '$camelcase_cache' $!\n";
 		foreach (sort { lc($a) cmp lc($b) } keys(%camelcase)) {
 			print $camelcase_file ("$_\n");
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
linux-next.patch

