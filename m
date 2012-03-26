From: akpm@linux-foundation.org
Subject: [obsolete] checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:22:55 -0700
Message-ID: <20120326192257.59A90A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:58824 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZTXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:23:06 -0400
Received: by vcbfk26 with SMTP id fk26so830663vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:23:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for strings split across multiple lines
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict test for strings split across multiple lines

Strings split across multiple lines are commonly used as formats.  These
uncoalesced formats are hard to grep and are relatively error prone.

Suggest coalescing split strings when using --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-strings-split-across-multiple-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-strings-split-across-multiple-lines
+++ a/scripts/checkpatch.pl
@@ -1860,6 +1860,12 @@ sub process {
 			    "Don't begin block comments with only a /* line, use /* comment...\n" . $hereprev);
 		}
 
+		if ($prevline =~ /^\+.*"[ \t]*$/ &&
+		    $line =~ /^\+[ \t]*"/) {
+			CHK("COALESCE_STRING",
+			    "Coalesced strings are easier to grep and less error prone\n" . $hereprev);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch
checkpatch-check-for-quoted-strings-broken-across-lines.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

