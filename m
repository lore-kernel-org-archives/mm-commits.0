From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:17 -0700
Message-ID: <200906171838.n5HIcH7G004301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757959AbZFQSqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: support both "P:/M:" and integrated "M:" lines
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: support both "P:/M:" and integrated "M:" lines
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines
+++ a/scripts/get_maintainer.pl
@@ -55,7 +55,7 @@ foreach my $chief (@penguin_chief) {
 }
 my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
 
-# rfc822 - preloaded methods go here.
+# rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
 my $rfc822_char = '[\\000-\\177]';
 
@@ -396,7 +396,19 @@ sub add_categories {
 		    }
 		}
 	    } elsif ($ptype eq "M") {
-		if ($email_maintainer) {
+		my $p_used = 0;
+		if ($index >= 0) {
+		    my $tv = $typevalue[$index - 1];
+		    if ($tv =~ m/^(\C):\s*(.*)/) {
+			if ($1 eq "P") {
+			    if ($email_usename) {
+				push_email_address(format_email($2, $pvalue));
+				$p_used = 1;
+			    }
+			}
+		    }
+		}
+		if (!$p_used) {
 		    push_email_addresses($pvalue);
 		}
 	    } elsif ($ptype eq "T") {
@@ -436,13 +448,16 @@ sub push_email_addresses {
 
     my @address_list = ();
 
-    if (@address_list = rfc822_validlist($address)) {
+    if (rfc822_valid($address)) {
+	push_email_address($address);
+    } elsif (@address_list = rfc822_validlist($address)) {
 	my $array_count = shift(@address_list);
 	while (my $entry = shift(@address_list)) {
 	    push_email_address($entry);
 	}
+    } else {
+	warn("Invalid MAINTAINERS address: '" . $address . "'\n");
     }
-
 }
 
 sub which {
@@ -471,9 +486,8 @@ sub recent_git_signoffs {
 	return;
     }
     if (!(-d ".git")) {
-	warn("$P: .git repository not found.\n");
-	warn("Use a .git repository for better results.\n");
-	warn("ie: git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	warn("$P: .git directory not found.  Use a git repository for better results.\n");
+	warn("$P: perhaps 'git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git'\n");
 	return;
     }
 
@@ -632,7 +646,7 @@ sub rfc822_validlist ($) {
     my @r;
     if ($s =~ m/^(?:$rfc822re)?(?:,(?:$rfc822re)?)*$/so &&
 	$s =~ m/^$rfc822_char*$/) {
-        while($s =~ m/(?:^|,$rfc822_lwsp*)($rfc822re)/gos) {
+        while ($s =~ m/(?:^|,$rfc822_lwsp*)($rfc822re)/gos) {
             push @r, $1;
         }
         return wantarray ? (scalar(@r), @r) : 1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

