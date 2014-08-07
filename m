From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:09:37 -0700
Message-ID: <53e3dd01.5B6Bw2pMBUyaXyKT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:48885 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:39 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so837511oig.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on missing spaces in broken up quoted
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: checkpatch: warn on missing spaces in broken up quoted

Checkpatch already complains when people break up quoted strings but it's
still pretty common.  One mistake that people often make is they leave out
the space character between the two strings.

This check adds around 450 new warnings and has a low rate of false
positives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-missing-spaces-in-broken-up-quoted scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-missing-spaces-in-broken-up-quoted
+++ a/scripts/checkpatch.pl
@@ -2361,6 +2361,12 @@ sub process {
 			     "quoted string split across lines\n" . $hereprev);
 		}
 
+# check for missing a space in a string concatination
+		if ($prevrawline =~ /[^\\]\w"$/ && $rawline =~ /^\+[\t ]+"\w/) {
+			WARN('MISSING_SPACE',
+			     "break quoted strings at a space character\n" . $hereprev);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
rtc-rtc-pcf8563-add-alarm-support-fix.patch
linux-next.patch

