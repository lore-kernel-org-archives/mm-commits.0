From: akpm@linux-foundation.org
Subject: [merged] get_maintainerpl-teach-git-log-to-use-no-color.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:54:55 -0800
Message-ID: <201002031754.o13HstpZ008933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainer.pl: teach git log to use --no-color
has been removed from the -mm tree.  Its filename was
     get_maintainerpl-teach-git-log-to-use-no-color.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer.pl: teach git log to use --no-color
From: Richard Kennedy <richard@rsk.demon.co.uk>

When git has been set to always use color in .gitconfig then I get the
warning message

        Bad divisor in main::vcs_assign: 0

This is caused by vcs_file_signoffs not matching any commits due to the
pattern not understand the colour codes.  Fix this by telling git log to
never use colour.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainerpl-teach-git-log-to-use-no-color scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerpl-teach-git-log-to-use-no-color
+++ a/scripts/get_maintainer.pl
@@ -74,8 +74,8 @@ my %VCS_cmds;
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
-    "find_signers_cmd" => "git log --since=\$email_git_since -- \$file",
-    "find_commit_signers_cmd" => "git log -1 \$commit",
+    "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
+    "find_commit_signers_cmd" => "git log --no-color -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
linux-next.patch
cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch

