From: akpm@linux-foundation.org
Subject: + checkpatchpl-add-prefer-__packed-check.patch added to -mm tree
Date: Tue, 04 Jan 2011 13:55:33 -0800
Message-ID: <201101042155.p04LtXu8026339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1ADV4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 16:56:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@shadowen.org


The patch titled
     checkpatch.pl: add "prefer __packed" check
has been added to the -mm tree.  Its filename is
     checkpatchpl-add-prefer-__packed-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: add "prefer __packed" check
From: Joe Perches <joe@perches.com>

There's a __packed #define for __attribute__((packed)).  Add a checkpatch
to tell people about it.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-prefer-__packed-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-prefer-__packed-check
+++ a/scripts/checkpatch.pl
@@ -2743,6 +2743,11 @@ sub process {
 			WARN("plain inline is preferred over $1\n" . $herecurr);
 		}
 
+# Check for __attribute__ packed, prefer __packed
+		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
+			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
include-linux-printkh-move-console-functions-and-variables-together.patch
include-linux-printkh-use-space-after-define.patch
include-linux-printkh-use-and-neaten-no_printk.patch
include-linux-printkh-add-pr_level_once-macros.patch
include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch
include-linux-printkh-organize-printk_ratelimited-macros.patch
include-linux-printkh-use-tab-not-spaces-for-indent.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
checkpatchpl-add-prefer-__packed-check.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

