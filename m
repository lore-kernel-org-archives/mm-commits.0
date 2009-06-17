From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:08 -0700
Message-ID: <200906171838.n5HIc8qY004134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878AbZFQSqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: improve --git-chief-penquins (Linus Torvalds) filtering
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: improve --git-chief-penquins (Linus Torvalds) filtering
From: Joe Perches <joe@perches.com>

Moved linux-kernel@vger.kernel.org to MAINTAINERS
lkml will be added to all CC lists via F: pattern match

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering
+++ a/scripts/get_maintainer.pl
@@ -216,15 +216,19 @@ foreach my $file (@files) {
 
 }
 
-if ($email_git_penguin_chiefs) {
+if ($email) {
     foreach my $chief (@penguin_chief) {
 	if ($chief =~ m/^(.*):(.*)/) {
-	    my $chief_name = $1;
-	    my $chief_addr = $2;
+	    my $email_address;
 	    if ($email_usename) {
-		push(@email_to, format_email($chief_name, $chief_addr));
+		$email_address = format_email($1, $2);
 	    } else {
-		push(@email_to, $chief_addr);
+		$email_address = $2;
+	    }
+	    if ($email_git_penguin_chiefs) {
+		push(@email_to, $email_address);
+	    } else {
+		@email_to = grep(!/${email_address}/, @email_to);
 	    }
 	}
     }
@@ -236,10 +240,7 @@ if ($email || $email_list) {
 	@to = (@to, @email_to);
     }
     if ($email_list) {
-	if (@list_to == 0) {
-	    push(@list_to, "linux-kernel\@vger.kernel.org");
 	@to = (@to, @list_to);
-	}
     }
     output(uniq(@to));
 }
@@ -314,7 +315,7 @@ Default options:
   [--email --git --m --n --l --multiline]
 
 Other options:
-  --version -> show version
+  --version => show version
   --help => show this help information
 
 EOT
@@ -423,7 +424,7 @@ sub add_categories {
 sub which {
     my ($bin) = @_;
 
-    foreach my $path (split /:/, $ENV{PATH}) {
+    foreach my $path (split(/:/, $ENV{PATH})) {
 	if (-e "$path/$bin") {
 	    return "$path/$bin";
 	}
@@ -446,12 +447,8 @@ sub recent_git_signoffs {
     }
 
     $cmd = "git log --since=${email_git_since} -- ${file}";
-    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@\"";
-    if (!$email_git_penguin_chiefs) {
-	$cmd .= " | grep -Pv \"${penguin_chiefs}\"";
-    }
+    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
     $cmd .= " | cut -f2- -d\":\"";
-    $cmd .= " | sed -e \"s/^\\s+//g\"";
     $cmd .= " | sort | uniq -c | sort -rn";
 
     $output = `${cmd}`;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

