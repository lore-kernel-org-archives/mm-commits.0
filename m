From: akpm@linux-foundation.org
Subject: [patch 149/162] checkpatch: add PREFER_IS_ENABLED test
Date: Fri, 20 May 2016 17:04:00 -0700
Message-ID: <573fa5f0.UqslfZe21IiG6CZg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEUAEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

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
