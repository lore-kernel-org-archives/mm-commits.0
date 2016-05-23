From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-prefer_is_enabled-test.patch removed from -mm tree
Date: Mon, 23 May 2016 12:51:33 -0700
Message-ID: <57435f45.kneWDrH89WxvAVMq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcEWTve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add PREFER_IS_ENABLED test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-prefer_is_enabled-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add PREFER_IS_ENABLED test

Using #if defined CONFIG_<FOO> || defined CONFIG_<FOO>_MODULE is
more verbose than necessary and IS_ENABLED(CONFIG_<FOO>) is preferred.

So add a test and a message for it.

--fix it to if desired.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-prefer_is_enabled-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-prefer_is_enabled-test
+++ a/scripts/checkpatch.pl
@@ -5637,6 +5637,16 @@ sub process {
 			}
 		}
 
+# check for #if defined CONFIG_<FOO> || defined CONFIG_<FOO>_MODULE
+		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(CONFIG_[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
+			my $config = $1;
+			if (WARN("PREFER_IS_ENABLED",
+				 "Prefer IS_ENABLED(<FOO>) to CONFIG_<FOO> || CONFIG_<FOO>_MODULE\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] = "\+#if IS_ENABLED($config)";
+			}
+		}
+
 # check for case / default statements not preceded by break/fallthrough/switch
 		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
 			my $has_break = 0;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
checkpatch-whine-about-access_once.patch
checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
checkpatch-reduce-number-of-git-log-calls-with-git.patch
checkpatch-improve-git-commit-count-shortcut.patch

