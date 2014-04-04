From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-add-check-for-change-id.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:34:28 -0700
Message-ID: <533f0944.ggP4u3S+OAjGHrU1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaDDTe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, apw@shadowen.org, cov@codeaurora.org

Subject: [merged] checkpatchpl-add-check-for-change-id.patch removed from -mm tree
To: cov@codeaurora.org,apw@shadowen.org,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:28 -0700


The patch titled
     Subject: checkpatch.pl: add check for Change-Id
has been removed from the -mm tree.  Its filename was
     checkpatchpl-add-check-for-change-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christopher Covington <cov@codeaurora.org>
Subject: checkpatch.pl: add check for Change-Id

A commit hook for the Gerrit code review server [1] inserts change
identifiers so Gerrit can track patches through multiple revisions.  These
identifiers are noise in the context of the upstream kernel.  (Many Gerrit
servers are private.  Even given a public instance, given only a
Change-Id, one must guess which server a change was tracked on.  Patches
submitted to the Linux kernel mailing lists should be able to stand on
their own.  If it's truly useful to reference code review on a Gerrit
server, a URL is a much clearer way to do so.) Thus, issue an error when a
Change-Id line is encountered before the Signed-off-by.

1. https://gerrit.googlesource.com/gerrit/+/master/gerrit-server/src/main/resources/com/google/gerrit/server/tools/root/hooks/commit-msg

Signed-off-by: Christopher Covington <cov@codeaurora.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-check-for-change-id scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-check-for-change-id
+++ a/scripts/checkpatch.pl
@@ -1924,6 +1924,12 @@ sub process {
 			}
 		}
 
+# Check for unwanted Gerrit info
+		if ($in_commit_log && $line =~ /^\s*change-id:/i) {
+			ERROR("GERRIT_CHANGE_ID",
+			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("CORRUPTED_PATCH",
_

Patches currently in -mm which might be from cov@codeaurora.org are

origin.patch
linux-next.patch

