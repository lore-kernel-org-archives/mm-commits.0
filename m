From: akpm@linux-foundation.org
Subject: + get_maintainerpl-teach-git-log-to-use-no-color.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:59:17 -0800
Message-ID: <201001270059.o0R0xHSB001607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754268Ab0A0A77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:59:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, joe@perches.com


The patch titled
     get_maintainer.pl: teach git log to use --no-color
has been added to the -mm tree.  Its filename is
     get_maintainerpl-teach-git-log-to-use-no-color.patch

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

get_maintainerpl-teach-git-log-to-use-no-color.patch
kernel-timekeeping-move-xtime_cache-to-be-in-the-same-cache-line-as-the-lock.patch

