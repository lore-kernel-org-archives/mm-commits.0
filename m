From: akpm@linux-foundation.org
Subject: [patch 024/114] checkpatch: allow space leading blank
 lines in email headers
Date: Mon, 08 May 2017 15:55:42 -0700
Message-ID: <20170508225542.e7tdJdqp3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdEHWzn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvhart@infradead.org, dvhart@vmware.com, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, warthog9@eaglescrag.net

From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow space leading blank lines in email headers

Allow a leading space and otherwise blank link in the email headers as it
can be a line wrapped Spamassassin multiple line string or any other valid
rfc 2822/5322 email header.

The line with space causes checkpatch to erroneously think that it's in
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
