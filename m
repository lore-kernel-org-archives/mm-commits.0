From: akpm@linux-foundation.org
Subject: [patch 098/115] checkpatch: warn when a MAINTAINERS entry
 isn't [A-Z]:
Date: Mon, 10 Jul 2017 15:52:07 -0700
Message-ID: <20170710225207.yYwrfERLR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754641AbdGJWwI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -2776,6 +2776,17 @@ sub process {
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
