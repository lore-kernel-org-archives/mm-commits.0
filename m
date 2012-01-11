From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:29 -0800
Message-ID: <20120111213130.14DBD20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44200 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:31 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32631eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix 'return is not a function' square bracket handling
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: fix 'return is not a function' square bracket handling

We are incorrectly matching square brackets '[' and ']' leading to false
positives on more complex functions as below:

    return (dt3155_fbuffer[m]->ready_head -
	dt3155_fbuffer[m]->ready_len +
	dt3155_fbuffer[m]->nbuffers)%
	(dt3155_fbuffer[m]->nbuffers);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-return-is-not-a-function-square-bracket-handling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-return-is-not-a-function-square-bracket-handling
+++ a/scripts/checkpatch.pl
@@ -2609,7 +2609,7 @@ sub process {
 			# Flatten any parentheses
 			$value =~ s/\(/ \(/g;
 			$value =~ s/\)/\) /g;
-			while ($value =~ s/\[[^\{\}]*\]/1/ ||
+			while ($value =~ s/\[[^\[\]]*\]/1/ ||
 			       $value !~ /(?:$Ident|-?$Constant)\s*
 					     $Compare\s*
 					     (?:$Ident|-?$Constant)/x &&
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

