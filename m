From: akpm@linux-foundation.org
Subject: + checkpatchpl-add-check-for-change-id.patch added to -mm tree
Date: Fri, 28 Mar 2014 15:34:06 -0700
Message-ID: <5335f8de.gmoruJyoTJXwd9tx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaC1WeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 18:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, apw@shadowen.org, cov@codeaurora.org

Subject: + checkpatchpl-add-check-for-change-id.patch added to -mm tree
To: cov@codeaurora.org,apw@shadowen.org,joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 15:34:06 -0700


The patch titled
     Subject: checkpatch.pl: add check for Change-Id
has been added to the -mm tree.  Its filename is
     checkpatchpl-add-check-for-change-id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-add-check-for-change-id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-add-check-for-change-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1930,6 +1930,12 @@ sub process {
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

checkpatchpl-add-check-for-change-id.patch
linux-next.patch

