From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-unnecessary-else-after-return-or-break.patch added to -mm tree
Date: Tue, 10 Jun 2014 16:46:42 -0700
Message-ID: <539798e2.lqMLnJbrm/za0R8/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaFJXqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-warn-on-unnecessary-else-after-return-or-break.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:46:42 -0700


The patch titled
     Subject: checkpatch: warn on unnecessary else after return or break
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-unnecessary-else-after-return-or-break.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-unnecessary-else-after-return-or-break.patch

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
Subject: checkpatch: warn on unnecessary else after return or break

Using an else following a break or return can unnecessarily indent code
blocks.

ie:
	for (i = 0; i < 100; i++) {
		int foo = bar();
		if (foo < 1)
			break;
		else
			usleep(1);
	}

is generally better written as:

	for (i = 0; i < 100; i++) {
		int foo = bar();
		if (foo < 1)
			break;
		usleep(1);
	}

Warn when a bare else statement is preceded by a break or return indented
1 tab more than the else.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-else-after-return-or-break scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-unnecessary-else-after-return-or-break
+++ a/scripts/checkpatch.pl
@@ -2350,6 +2350,16 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# check indentation of any line with a bare else
+# if the previous line is a break or return and is indented 1 tab more...
+		if ($sline =~ /^\+([\t]+)(?:}[ \t]*)?else(?:[ \t]*{)?\s*$/) {
+			my $tabs = length($1) + 1;
+			if ($prevline =~ /^\+\t{$tabs,$tabs}(?:break|return)\b/) {
+				WARN("UNNECESSARY_ELSE",
+				     "else is not generally useful after a break or return\n" . $hereprev);
+			}
+		}
+
 # discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
 		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
 			WARN("CONFIG_EXPERIMENTAL",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
linux-next.patch

