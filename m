From: akpm@linux-foundation.org
Subject: + checkpatch-add-prefer_is_enabled-test.patch added to -mm tree
Date: Mon, 28 Mar 2016 14:48:03 -0700
Message-ID: <56f9a693./lg7irtC80WdJ3OF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbcC1VsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 17:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add PREFER_IS_ENABLED test
has been added to the -mm tree.  Its filename is
     checkpatch-add-prefer_is_enabled-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-prefer_is_enabled-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-prefer_is_enabled-test.patch

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

checkpatch-add-prefer_is_enabled-test.patch

