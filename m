From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
 added to -mm tree
Date: Fri, 05 Jun 2020 17:28:53 -0700
Message-ID: <20200606002853.UW0i3mT3t%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgFFA2y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 20:28:54 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for possible misuse of IS_ENABLED() without CONFIG_
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for possible misuse of IS_ENABLED() without CONFIG_

IS_ENABLED is almost always used with CONFIG_<FOO> defines.

Add a test to verify that the #define being tested starts with CONFIG_.

Link: http://lkml.kernel.org/r/e7fda760b91b769ba82844ba282d432c0d26d709.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_
+++ a/scripts/checkpatch.pl
@@ -6472,6 +6472,12 @@ sub process {
 			}
 		}
 
+# check for IS_ENABLED() without CONFIG_<FOO> ($rawline for comments too)
+		if ($rawline =~ /\bIS_ENABLED\s*\(\s*(\w+)\s*\)/ && $1 !~ /^CONFIG_/) {
+			WARN("IS_ENABLED_CONFIG",
+			     "IS_ENABLED($1) is normally used as IS_ENABLED(CONFIG_$1)\n" . $herecurr);
+		}
+
 # check for #if defined CONFIG_<FOO> || defined CONFIG_<FOO>_MODULE
 		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(CONFIG_[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
 			my $config = $1;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
