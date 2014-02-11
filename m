From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-fix-detection-of-git-repository.patch
 removed from -mm tree
Date: Tue, 11 Feb 2014 11:23:18 -0800
Message-ID: <52fa78a6.UTaaLfH+V3BUE5L1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaBKTXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, apw@canonical.com, richard.genoud@gmail.com

Subject: [merged] get_maintainer-fix-detection-of-git-repository.patch removed from -mm tree
To: richard.genoud@gmail.com,apw@canonical.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:18 -0800


The patch titled
     Subject: get_maintainer: fix detection of git repository
has been removed from the -mm tree.  Its filename was
     get_maintainer-fix-detection-of-git-repository.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Genoud <richard.genoud@gmail.com>
Subject: get_maintainer: fix detection of git repository

Since git v1.7.7, the .git directory can be a file when, for example, the
kernel is a submodule of another git super project.  So, the check "-d
.git" is not working anymore in this case.  Using a more generic check
like "-e .git" corrects this behaviour.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-fix-detection-of-git-repository scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-fix-detection-of-git-repository
+++ a/scripts/get_maintainer.pl
@@ -95,7 +95,7 @@ my %VCS_cmds;
 
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
-    "available" => '(which("git") ne "") && (-d ".git")',
+    "available" => '(which("git") ne "") && (-e ".git")',
     "find_signers_cmd" =>
 	"git log --no-color --follow --since=\$email_git_since " .
 	    '--numstat --no-merges ' .
_

Patches currently in -mm which might be from richard.genoud@gmail.com are

origin.patch

