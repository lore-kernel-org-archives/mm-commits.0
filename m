From: akpm@linux-foundation.org
Subject: + checkpatch-add-a-prefer-__aligned-check.patch added to -mm tree
Date: Mon, 20 Jun 2011 12:59:46 -0700
Message-ID: <201106201959.p5KJxk64015191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab1FTT7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 15:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org


The patch titled
     checkpatch: add a "prefer __aligned" check
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-prefer-__aligned-check.patch

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
Subject: checkpatch: add a "prefer __aligned" check
From: Joe Perches <joe@perches.com>

Prefer the use of __aligned(size) over __attribute__((__aligned___(size)))

Link: http://lkml.kernel.org/r/20110609094526.1571774c.akpm@linux-foundation.org

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-prefer-__aligned-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-prefer-__aligned-check
+++ a/scripts/checkpatch.pl
@@ -2891,6 +2891,11 @@ sub process {
 			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
+# Check for __attribute__ aligned, prefer __aligned
+		if ($line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
+			WARN("__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("sizeof(& should be avoided\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

