From: akpm@linux-foundation.org
Subject: +
 checkpatch-allow-space-leading-blank-lines-in-email-headers.patch added to
 -mm tree
Date: Tue, 28 Mar 2017 16:40:18 -0700
Message-ID: <58daf462.obF/GFpD1zZQyrVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753312AbdC1XkV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dvhart@infradead.org, dvhart@vmware.com, warthog9@eaglescrag.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow space leading blank lines in email headers
has been added to the -mm tree.  Its filename is
     checkpatch-allow-space-leading-blank-lines-in-email-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-space-leading-blank-lines-in-email-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-space-leading-blank-lines-in-email-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow space leading blank lines in email headers

Allow a leading space and otherwise blank link in the email headers as it
can be a line wrapped Spamassassin multiple line string or any other valid
rfc 2822/5322 email header.

The line with space causes checkpatch to erroniously think that it's in
the content body, as opposed to headers and thus flag a mail header as an
unwrapped long comment line.

Link: http://lkml.kernel.org/r/d75a9f0b78b3488078429f4037d9fff3bdfa3b78.1490247180.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>Reported-by: Darren Hart (VMware) <dvhart@infradead.org>
Tested-by: Darren Hart (VMware) <dvhart@infradead.org>
Reviewed-by: Darren Hart (VMware) <dvhart@vmware.com>
Original-patch-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-space-leading-blank-lines-in-email-headers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-space-leading-blank-lines-in-email-headers
+++ a/scripts/checkpatch.pl
@@ -2628,8 +2628,8 @@ sub process {
 # Check if it's the start of a commit log
 # (not a header line and we haven't seen the patch filename)
 		if ($in_header_lines && $realfile =~ /^$/ &&
-		    !($rawline =~ /^\s+\S/ ||
-		      $rawline =~ /^(commit\b|from\b|[\w-]+:).*$/i)) {
+		    !($rawline =~ /^\s+(?:\S|$)/ ||
+		      $rawline =~ /^(?:commit\b|from\b|[\w-]+:)/i)) {
 			$in_header_lines = 0;
 			$in_commit_log = 1;
 			$has_commit_log = 1;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch
checkpatch-allow-space-leading-blank-lines-in-email-headers.patch

