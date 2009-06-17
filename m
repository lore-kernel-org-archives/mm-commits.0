From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:11 -0700
Message-ID: <200906171838.n5HIcB4X004276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbZFQSqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: warn on missing git or git repository
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: warn on missing git or git repository
From: Joe Perches <joe@perches.com>

support older versions of grep (use -E not -P)
no need to return data in routine recent_git_signoffs

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-warn-on-missing-git-or-git-repository scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-warn-on-missing-git-or-git-repository
+++ a/scripts/get_maintainer.pl
@@ -443,11 +443,21 @@ sub recent_git_signoffs {
     my @lines = ();
 
     if (which("git") eq "") {
-	die("$P: git not found.  Add --nogit to options?\n");
+	warn("$P: git not found.  Add --nogit to options?\n");
+	return;
+    }
+    if (!(-d ".git")) {
+	warn("$P: .git repository not found.\n");
+	warn("Use a .git repository for better results.\n");
+	warn("ie: git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	return;
     }
 
     $cmd = "git log --since=${email_git_since} -- ${file}";
-    $cmd .= " | grep -Pi \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
+    $cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
+    if (!$email_git_penguin_chiefs) {
+	$cmd .= " | grep -Ev \"${penguin_chiefs}\"";
+    }
     $cmd .= " | cut -f2- -d\":\"";
     $cmd .= " | sort | uniq -c | sort -rn";
 
@@ -486,7 +496,6 @@ sub recent_git_signoffs {
 	    push(@email_to, $line);
 	}
     }
-    return $output;
 }
 
 sub uniq {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

