From: akpm@linux-foundation.org
Subject: + checkpatch-add-6-missing-types-to-list-types.patch added to -mm tree
Date: Tue, 05 Sep 2017 16:41:24 -0700
Message-ID: <59af3624.EM2mS4uNhYhPaZqY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42616 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753652AbdIEXlZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add 6 missing types to --list-types
has been added to the -mm tree.  Its filename is
     checkpatch-add-6-missing-types-to-list-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-6-missing-types-to-list-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-6-missing-types-to-list-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: checkpatch: add 6 missing types to --list-types

Unlike all other types, LONG_LINE, LONG_LINE_COMMENT and LONG_LINE_STRING
are passed to WARN() through a variable.  This causes the parser in
list_types() to miss them and consequently they are not present in the
output of --list-types.

Additionally, types TYPO_SPELLING, FSF_MAILING_ADDRESS and AVOID_BUG are
passed with a variable level, causing the parser to miss them too.

So modify the regex to also catch these special cases.

Link: http://lkml.kernel.org/r/20170902175610.7e4a7c9d@endymion
Fixes: 3beb42eced39 ("checkpatch: add --list-types to show message types to show or ignore")
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-6-missing-types-to-list-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-6-missing-types-to-list-types
+++ a/scripts/checkpatch.pl
@@ -145,7 +145,8 @@ sub list_types {
 	close($script);
 
 	my @types = ();
-	for ($text =~ /\b(?:(?:CHK|WARN|ERROR)\s*\(\s*"([^"]+)")/g) {
+	# Also catch when type or level is passed through a variable
+	for ($text =~ /(?:(?:\bCHK|\bWARN|\bERROR|&\{\$msg_level})\s*\(|\$msg_type\s*=)\s*"([^"]+)"/g) {
 		push (@types, $_);
 	}
 	@types = sort(uniq(@types));
_

Patches currently in -mm which might be from jdelvare@suse.de are

checkpatch-fix-typo-in-comment.patch
checkpatch-rename-variables-to-avoid-confusion.patch
checkpatch-add-6-missing-types-to-list-types.patch

