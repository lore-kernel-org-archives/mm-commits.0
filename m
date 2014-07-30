From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch
 added to -mm tree
Date: Wed, 30 Jul 2014 15:04:34 -0700
Message-ID: <53d96bf2.sa/e2YuJh9xDld5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:51072 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaG3WEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 18:04:35 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so349245pab.3
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 15:04:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on missing spaces in broken up quoted
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
makefile-tell-gcc-optimizer-to-never-introduce-new-data-races.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch
rtc-rtc-pcf8563-add-alarm-support-fix.patch
linux-next.patch

