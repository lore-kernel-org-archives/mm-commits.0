From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch added to -mm tree
Date: Tue, 26 May 2009 14:41:51 -0700
Message-ID: <200905262141.n4QLfpAR029732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254AbZEZVmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: warn on missing git or git repository
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch

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

maintainers-pair-edac-e752x-p-and-m-entries.patch
linux-next.patch
scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch
scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch
scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch
scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch
scripts-get_maintainerpl-support-m-lines-with-names-and-multiple-entries-per-m-line.patch
scripts-get_maintainerpl-better-email-name-quoting.patch
scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch
scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch
scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch
scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch
maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch
maintainers-add-file-patterns-to-the-rest.patch
maintainers-update-m32r-file-patterns-after-rename.patch
maintainers-mark-alsa-lists-as-moderated.patch
maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch
maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch
maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch

