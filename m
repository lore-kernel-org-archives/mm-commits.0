From: akpm@linux-foundation.org
Subject: + checkpatch-warn-when-a-maintainers-entry-isnt-t.patch added to
 -mm tree
Date: Thu, 01 Jun 2017 14:19:29 -0700
Message-ID: <593084e1.BYvN/t8TjALCjE21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdFAVTa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when a MAINTAINERS entry isn't [A-Z]:\t
has been added to the -mm tree.  Its filename is
     checkpatch-warn-when-a-maintainers-entry-isnt-t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-when-a-maintainers-entry-isnt-t.patch

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
Subject: checkpatch: warn when a MAINTAINERS entry isn't [A-Z]:\t

For consistency, MAINTAINERS entries should be an upper case letter, then
a colon, then a tab, then the value.

Warn when an entry doesn't have this form.  --fix it too.

Link: http://lkml.kernel.org/r/9aaaf03ec10adf3888b5e98dd2176b7fe9b5fad8.1496343345.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-when-a-maintainers-entry-isnt-t scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-when-a-maintainers-entry-isnt-t
+++ a/scripts/checkpatch.pl
@@ -2775,6 +2775,17 @@ sub process {
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
+# check for MAINTAINERS entries that don't have the right form
+		if ($realfile =~ /^MAINTAINERS$/ &&
+		    $rawline =~ /^\+[A-Z]:/ &&
+		    $rawline !~ /^\+[A-Z]:\t\S/) {
+			if (WARN("MAINTAINERS_STYLE",
+				 "MAINTAINERS entries use one tab after TYPE:\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/^(\+[A-Z]):\s*/$1:\t/;
+			}
+		}
+
 # discourage the use of boolean for type definition attributes of Kconfig options
 		if ($realfile =~ /Kconfig/ &&
 		    $line =~ /^\+\s*\bboolean\b/) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch

