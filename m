From: akpm@linux-foundation.org
Subject: [patch 095/126] checkpatch: add 6 missing types to
 --list-types
Date: Fri, 08 Sep 2017 16:16:11 -0700
Message-ID: <20170908231611.A7SEe4RyQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXQM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jdelvare@suse.de, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
