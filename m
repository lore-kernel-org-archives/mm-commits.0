From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-detection-of-git-repository.patch removed from -mm tree
Date: Tue, 11 Feb 2014 11:23:20 -0800
Message-ID: <52fa78a8.WjycFyi6xHnKvFm/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbaBKTXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, apw@canonical.com, richard.genoud@gmail.com

Subject: [merged] checkpatch-fix-detection-of-git-repository.patch removed from -mm tree
To: richard.genoud@gmail.com,apw@canonical.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:20 -0800


The patch titled
     Subject: checkpatch: fix detection of git repository
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-detection-of-git-repository.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Genoud <richard.genoud@gmail.com>
Subject: checkpatch: fix detection of git repository

Since git v1.7.7, the .git directory can be a file when, for example, the
kernel is a submodule of another git super project.  So, the check "-d
.git" is not working anymore in this case.  Using a more generic check
like "-e .git" corrects this behaviour.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-detection-of-git-repository scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-detection-of-git-repository
+++ a/scripts/checkpatch.pl
@@ -471,7 +471,7 @@ sub seed_camelcase_includes {
 
 	$camelcase_seeded = 1;
 
-	if (-d ".git") {
+	if (-e ".git") {
 		my $git_last_include_commit = `git log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
@@ -499,7 +499,7 @@ sub seed_camelcase_includes {
 		return;
 	}
 
-	if (-d ".git") {
+	if (-e ".git") {
 		$files = `git ls-files "include/*.h"`;
 		@include_files = split('\n', $files);
 	}
_

Patches currently in -mm which might be from richard.genoud@gmail.com are

origin.patch

