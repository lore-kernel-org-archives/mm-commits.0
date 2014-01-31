From: akpm@linux-foundation.org
Subject: + get_maintainer-fix-detection-of-git-repository.patch added to
 -mm tree
Date: Fri, 31 Jan 2014 13:57:27 -0800
Message-ID: <52ec1c47.l3D+uhFAh9BNVMlG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaAaV52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, apw@canonical.com, richard.genoud@gmail.com

Subject: + get_maintainer-fix-detection-of-git-repository.patch added to -mm tree
To: richard.genoud@gmail.com,apw@canonical.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:57:27 -0800


The patch titled
     Subject: get_maintainer: fix detection of git repository
has been added to the -mm tree.  Its filename is
     get_maintainer-fix-detection-of-git-repository.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-fix-detection-of-git-repository.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-fix-detection-of-git-repository.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch

